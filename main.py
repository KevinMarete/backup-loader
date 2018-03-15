import configparser
import ftplib
import sys
import os
import pymysql.cursors
import time
import zipfile
import warnings

def getcheckbackups(ftpcfg, backup_dir, local_dir):
	backup_count = 0
	good_count = 0
	corrupted_count = 0
	empty_dir_count = 0
	#Connect to ftp
	ftp = ftplib.FTP(ftpcfg['hostname'], ftpcfg['username'], ftpcfg['password'])
	#Switch directories
	ftp.cwd(backup_dir)
	#List folders
	folders = ftp.nlst()
	#List folder contents
	for folder in folders:
		ftp.cwd(backup_dir+folder)
		backups = ftp.nlst()
		for backup in backups:
			#Download ftp file
			try:
				localfile = os.path.join(local_dir, backup)
				with open(localfile, 'wb') as local_file:
					ftp.retrbinary('RETR ' + backup, local_file.write)
			except ftplib.error_perm:
				pass

			#Check file status
			try:
				zipfile.ZipFile(localfile)
				good_count += 1
			except zipfile.BadZipfile:
				#Remove from ftp
				ftp.delete(backup)
				corrupted_count += 1

			#Remove localfile
			os.remove(localfile)

		#Remove folder if empty
		dir_backup_count = len(ftp.nlst())
		backup_count += dir_backup_count
		if(dir_backup_count == 0):
			#ftp.rmd(folder)
			empty_dir_count += 1

	#Reset Switch directories
	ftp.cwd(backup_dir)

	print 'Facilties:', len(ftp.nlst()), 'Backups:', backup_count, 'Good:', good_count, 'Corrupted:', corrupted_count, 'Empty Directories:', empty_dir_count

def getlatestbackups(ftpcfg, backup_dir, local_dir):
	latest_backups = {}
	#Get already imported files
	imported_files = [item[0] for item in getimportedfiles(cfg)]
	#Connect to ftp
	ftp = ftplib.FTP(ftpcfg['hostname'], ftpcfg['username'], ftpcfg['password'])
	#Switch directories
	ftp.cwd(backup_dir)
	#List folders
	folders = ftp.nlst()
	#List folder contents
	for folder in folders:
		ftp.cwd(backup_dir+folder)
		backups = ftp.nlst()
		#Get latest backup
		if len(backups) > 0:
			filename = backups[-1]
			#Check if file has already been processed
			if filename not in imported_files:
				host_file = os.path.join(local_dir, filename)
				latest_backups[folder] = filename
				try:
					with open(host_file, 'wb') as local_file:
						ftp.retrbinary('RETR ' + filename, local_file.write)
				except ftplib.error_perm:
					pass
	#Exit ftp
	ftp.quit()
	#Show number of latest backups
	print 'Latest Backups:', len(latest_backups), 'file(s)'

	return latest_backups

def getimportedfiles(cfg):
	cnx = getdbconnection(cfg, cfg['main']['db_name'])
	cursor = cnx.cursor()
	cursor.execute("SELECT DISTINCT(filename) filename FROM tbl_backup")
	return cursor.fetchall()

def getdbconnection(cfg, db_name):
	dbcfg = {
		'user': str(cfg["database"]["username"]),
		'password': str(cfg["database"]["password"]),
		'host': str(cfg["database"]["hostname"]),
		'port': int(cfg["database"]["port"]),
		'database': db_name,
		'charset': 'utf8mb4',
		'cursorclass': pymysql.cursors.Cursor
	}
	return pymysql.connect(**dbcfg)

def extractbackup(mflcode, backup):
	start = time.time()
	filename = backup
	db_status = False
	db_name = str(cfg['main']['db_prefix'])+mflcode
	#Unzip sqlfile
	zipfile = os.path.join(files_dir, filename)
	sqlfile = getuncompressedfile(zipfile, files_dir, mflcode)
	#Remove zipfile
	os.remove(zipfile)
	#Import sqlfile
	if(sqlfile != False):
		sqlfile = os.path.join(files_dir, sqlfile)
		response = importsql(cfg, db_name, sqlfile)
		#Remove sqlfile
		os.remove(sqlfile)
		#Show response
		if(response['status']):
			db_status = True
			print 'Started:',filename,'was imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
		else:
			print 'Error:',filename,' failed to be imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
		
	return {db_name: db_status}

def getuncompressedfile(path_to_zip_file, directory_to_extract_to, mflcode):
	import zipfile
	try:
		archive = zipfile.ZipFile(path_to_zip_file)
		for file in archive.namelist():
			if file.startswith(mflcode):
				archive.extract(file, directory_to_extract_to)
		return file
	except zipfile.BadZipfile:
		return False

def importsql(cfg, db_name, sqlfile):
	cnx = getconnection(cfg)
	cursor = cnx.cursor()
	try:
		dropdatabase(cfg, db_name)
		cursor.execute("CREATE DATABASE "+db_name)
		import_command = "mysql -h "+cfg["database"]["hostname"]+" -P "+cfg["database"]["port"]+" -u "+cfg["database"]["username"]+" -p"+cfg["database"]["password"]+" "+db_name+" < "+sqlfile
		os.system(import_command)
		cursor.close()
		cnx.close()
		return {'status': True, 'message': 'Database Imported Successful'}
	except Exception, e:
		return {'status': False, 'message': e}

def getconnection(cfg):
	dbcfg = {
		'user': str(cfg["database"]["username"]),
		'password': str(cfg["database"]["password"]),
		'host': str(cfg["database"]["hostname"]),
		'port': int(cfg["database"]["port"]),
		'charset': 'utf8mb4',
		'cursorclass': pymysql.cursors.Cursor
	}
	return pymysql.connect(**dbcfg)

def dropdatabase(cfg, db_name):
	cnx = getconnection(cfg)
	with warnings.catch_warnings():
		warnings.filterwarnings("ignore")
		cursor = cnx.cursor()
		cursor.execute("DROP DATABASE IF EXISTS "+db_name)
		cnx.commit()

def logbackup(cfg, filename, mflcode, adt_version):
	try:
		cnx = getdbconnection(cfg, cfg['main']['db_name'])
		cursor = cnx.cursor()
		#Get facility_id
		cursor.execute("SELECT id FROM tbl_facility WHERE mflcode = '"+mflcode+"'")
		row = cursor.fetchone()
		#Log backupfile
		if row is not None:
			facility_id = row[0]
			cursor.execute("INSERT INTO tbl_backup(filename, foldername, adt_version, facility_id) VALUES (%s, %s, %s, %s)", (filename, mflcode, adt_version, facility_id))
			#Commit and close connection
			cnx.commit()
			cursor.close()
			cnx.close()
			return {'status': True, 'message': 'Success: Backupfile '+ filename +' was logged!'}
		else:
			return {'status': False, 'message': 'Error: mflcode '+ mflcode +' is missing!'}
	except Exception, e:
		return {'status': False, 'message': 'Error: ' + e}
	
def extractdata(cfg, source_db, mflcode):
	start = time.time()
	source_tables = cfg['main']['source_tables'].split(',')
	batch_size = int(cfg['main']['batch_size'])
	source_cnx = getdbconnection(cfg, source_db)
	source_cursor = source_cnx.cursor()
	extract_status = False

	#Fix for source tables
	fixfile = cfg['main']['queries_dir']+'create_alter_source_tables.sql'	
	filestream = getsql(fixfile).format(db_name=source_db).strip().replace('\r\n','')
	for stmt in filestream.split('//'):
		if len(stmt) > 0:
			try:
				with warnings.catch_warnings():
					warnings.filterwarnings("ignore")
					source_cursor.execute(stmt)
					source_cnx.commit()
			except Exception, e:
				print 'Error:', e, 'Query:', stmt
	source_cursor.close()
	source_cnx.close()
	#Add missing columns
	addcolumns(cfg, source_db)
	print 'Success: Missing tables and columns added to database:',source_db

	#Get queries from source_tables
	source_cnx = getdbconnection(cfg, source_db)
	for source_table in source_tables:
		table_size = 0
		inner_start = time.time()
		sql_counter = 0
		sqlfile = cfg['main']['queries_dir']+'select_'+source_table+'_table.sql'
		destination_table = str(cfg['destination'][source_table])
		#Get table_size
		sql_count = "SELECT COUNT(*) total FROM " + source_table + " WHERE active = '1'"
		source_cursor = source_cnx.cursor()
		source_cursor.execute(sql_count)
		result = source_cursor.fetchone()
		if result:
			table_size = result[0]
		source_cursor.close()
		#Use batch to get data
		print 'Info: Migration of table',source_table,'containing rows',table_size,'has started!'
		while sql_counter < table_size:
			try:
				with warnings.catch_warnings():
					warnings.filterwarnings("ignore")
					source_cursor = source_cnx.cursor()
					query = getsql(sqlfile).format(mflcode, batch_size, sql_counter)
					source_cursor.execute(query)
					source_data = list(source_cursor)
					source_cursor.close()
				#Save source_data using bulk replace_into
				savebatch(cfg, destination_table, source_data)
				#Increment batch_size
				sql_counter += batch_size
				print 'Info: Migration of table',source_table,'imported rows',sql_counter,'currently in progress!'
			except Exception, e:
				logfile = cfg['main']['logs_dir']+'failed_'+source_table+'.log'
				message = "Database: "+ source_db + " Error: "+ str(e)
				writelog(logfile, message)
		extract_status = True
		print 'Success: Migration of table',source_table,'completed in',time.strftime('%H:%M:%S', time.gmtime(time.time()-inner_start))
	#Close source connections
	source_cursor.close()
	source_cnx.close()
	#Display message
	print 'Finished: Database',source_db,'data was extracted in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))

	return extract_status

def addcolumns(cfg, source_db):
	source_cnx = getdbconnection(cfg, source_db)
	source_cursor = source_cnx.cursor()
	columns = {
		"breastfeeding": {
			"table": "patient", 
			"query": "ALTER TABLE `patient` ADD `breastfeeding` tinyint(2) NOT NULL DEFAULT '0' AFTER `pregnant`"
		},
		"clinicalappointment": {
			"table": "patient", 
			"query": "ALTER TABLE `patient` ADD `clinicalappointment` varchar(20) NOT NULL AFTER `nextappointment`"
		},
		"differentiated_care": {
			"table": "patient", 
			"query": "ALTER TABLE `patient` ADD `differentiated_care` tinyint(1) NOT NULL AFTER `clinicalappointment`"
		},
		"prep_reason_id": {
			"table": "patient_prep_test", 
			"query": "ALTER TABLE `patient_prep_test` ADD `prep_reason_id` int(11) NULL AFTER `patient_id`"
		}
	}

	try:
		with warnings.catch_warnings():
			warnings.filterwarnings("ignore")
			for column in columns:
				table = columns[column]['table']
				query = columns[column]['query']
				stmt = ("SELECT COUNT(*) total FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '{}' AND table_schema = '{}' AND column_name = '{}'").format(table, source_db, column)
				source_cursor.execute(stmt)
				row = source_cursor.fetchone()
				if row is not None:
					if row[0] < 1:
						source_cursor.execute(query)
			source_cnx.commit()
			source_cursor.close()
			source_cnx.close()
	except Exception, e:
		print 'Error:', e


def savebatch(cfg, destination_table, source_data):
	#Get database connection
	target_db = cfg['main']['db_name']
	target_cnx = getdbconnection(cfg, target_db)
	target_cursor = target_cnx.cursor()
	try:
		with warnings.catch_warnings():
			warnings.filterwarnings("ignore")
			target_cursor.executemany(getsql(cfg['main']['queries_dir']+'insert_'+destination_table+'_table.sql'), source_data)
			#Commit changes and close connection
			target_cnx.commit()
			target_cursor.close()
			target_cnx.close()
		return {'status': True, 'message': destination_table + ' batch saved!'}
	except Exception, e:
		logfile = cfg['main']['logs_dir']+'failed_'+destination_table+'.log'
		message = "Database: "+ target_db + " Error: "+ str(e)+";"
		writelog(logfile, message)
		return {'status': False, 'message': e}

def runproc(cfg, proc_name):
	start = time.time()
	#Get database connection
	target_db = cfg['main']['db_name']
	target_cnx = getdbconnection(cfg, target_db)
	target_cursor = target_cnx.cursor()
	try:
		target_cursor.callproc(proc_name)
		#Commit changes and close connection
		target_cnx.commit()
		target_cursor.close()
		target_cnx.close()
		print 'Success: Procedure',proc_name,'completed in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
	except Exception, e:
		logfile = cfg['main']['logs_dir']+'failed_'+proc_name+'.log'
		message = "DATABASE: "+ target_db + " ERROR: "+ str(e)
		writelog(logfile, message)
		print 'Error: Procedure',proc_name,'has the following error',e

def getsql(sqlfile):
	file = open(sqlfile, 'r')
	sql = " ".join(file.readlines())
	return sql

def writelog(logfile,logmsg):
	import logging

	logger = logging.getLogger(__name__)
	logger.setLevel(logging.INFO)
	#create a logfile handler
	handler = logging.FileHandler(logfile)
	handler.setLevel(logging.INFO)
	#create a logging format
	formatter = logging.Formatter('%(asctime)s %(message)s')
	handler.setFormatter(formatter)
	#add the handlers to the logger
	logger.addHandler(handler)
	#write message to logfile
	logger.info(logmsg)
	#remove handler
	logger.removeHandler(handler)

if __name__ == '__main__':
	#Encode strings to utf-8
	reload(sys)
	sys.setdefaultencoding('utf-8')

	#Get configuration
	cfg = configparser.ConfigParser()
	cfg.read('config/properties.ini')

	#Get params 
	ftpusername = cfg['ftp']['username']
	ftppassword = cfg['ftp']['password']
	backup_dir = cfg['ftp']['backup_dir']
	files_dir = cfg['main']['files_dir']
	response = {}

	#FTP configuration
	ftpcfg = {
		'hostname': cfg['ftp']['hostname'],
		'username': cfg['ftp']['username'],
		'password': cfg['ftp']['password']
	}

	#Check backups
	getcheckbackups(ftpcfg, backup_dir, files_dir)

	#Get latest backups
	backups = getlatestbackups(ftpcfg, backup_dir, files_dir)

	#Import and extract backup data
	for mflcode, backup in backups.iteritems():
		for db_name, db_status in extractbackup(mflcode, backup).iteritems():
			if db_status:
				#Extract data
				if(extractdata(cfg, db_name, mflcode)):
					#Log imported file
					adt_version = backup.split('_')[2].replace('.sql.zip','')
					logstatus = logbackup(cfg, backup, mflcode, adt_version)
					if(logstatus['status'] == False):	
						print logstatus['message']
			#Drop source database
			dropdatabase(cfg, db_name)

	#Run cleanup procedure on dsh_adt_tables
	runproc(cfg, str(cfg['main']['proc_name']))

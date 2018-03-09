import configparser
import ftplib
import sys
import os
import mysql.connector
import time
import zipfile

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
			ftp.rmd(folder)
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
	ftp.quit()
	return latest_backups

def getimportedfiles(cfg):
	cnx = getdbconnection(cfg, cfg['main']['db_name'])
	cursor = cnx.cursor()
	cursor.execute("SELECT DISTINCT(filename) filename FROM tbl_backup")
	return cursor.fetchall()

def getdbconnection(cfg, db_name):
	dbcfg = {
		'user': cfg["database"]["username"],
		'password': cfg["database"]["password"],
		'host': cfg["database"]["hostname"],
		'port': cfg["database"]["port"],
		'database': db_name
	}
	return mysql.connector.connect(**dbcfg)

def extractbackup(backups):
	databases = []
	#Drop/Create database based on backup file
	for mflcode in backups:

		db_name = str(cfg['main']['db_prefix'])+mflcode
		extractdata(cfg, db_name, mflcode)

		"""
		start = time.time()
		filename = backups[mflcode]
		adt_version = filename.split('_')[2].replace('.sql.zip','')
		#Unzip sqlfile
		zipfile = os.path.join(files_dir, filename)
		sqlfile = getuncompressedfile(zipfile, files_dir, mflcode)
		#Remove zipfile
		os.remove(zipfile)
		#Import sqlfile
		if(sqlfile != False):
			sqlfile = os.path.join(files_dir, sqlfile)
			db_name = str(cfg['main']['db_prefix'])+mflcode
			response = importsql(cfg, db_name, sqlfile)
			#Remove sqlfile
			os.remove(sqlfile)
			#Show response
			if(response['status']):
				databases.append(db_name)
				#Log imported file
				logimportedfile(cfg, filename, mflcode, adt_version)	
				print 'Success:',filename,'was imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
				#Extract data
				extractdata(cfg, db_name, mflcode)
			else:
				print 'Error:',filename,' failed to be imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
		"""
	return databases

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
		return {'status': True, 'message': 'Database Imported Successful'}
	except Exception, e:
		print 'Error:',e
		return {'status': False, 'message': e}
	cursor.close()
	cnx.close()

def getconnection(cfg):
	dbcfg = {
		'user': cfg["database"]["username"],
		'password': cfg["database"]["password"],
		'host': cfg["database"]["hostname"],
		'port': cfg["database"]["port"]
	}
	return mysql.connector.connect(**dbcfg)

def dropdatabase(cfg, db_name):
	cnx = getconnection(cfg)
	cursor = cnx.cursor()
	cursor.execute("DROP DATABASE IF EXISTS "+db_name)

def logimportedfile(cfg, filename, mflcode, adt_version):
	try:
		cnx = getdbconnection(cfg, cfg['main']['db_name'])
		cursor = cnx.cursor()
		#Get facility_id
		cursor.execute("SELECT id FROM tbl_facility WHERE mflcode = '"+mflcode+"'")
		row = cursor.fetchone()
		if row is not None:
			facility_id = row[0]
			cursor.execute("INSERT INTO tbl_backup(filename, foldername, adt_version, facility_id) VALUES (%s, %s, %s, %s)", (filename, mflcode, adt_version, facility_id))
		else:
			print 'Error: mflcode', mflcode, 'is missing!'
	except Exception, e:
		print 'Error:', e
	#Commit changes and close connection
	cnx.commit()
	cursor.close()
	cnx.close()

def extractdata(cfg, source_db, mflcode):
	start = time.time()
	source_tables = cfg['main']['source_tables'].split(',')
	batch_size = int(cfg['main']['batch_size'])
	source_cnx = getdbconnection(cfg, source_db)
	source_cursor = source_cnx.cursor()

	#Fix for source tables
	fixfile = cfg['main']['queries_dir']+'source_fix.sql'	
	source_cursor.execute(getsql(fixfile), multi=True)
	source_cnx.commit()

	#Get queries from source_tables
	for source_table in source_tables:
		sql_counter = 0
		sqlfile = cfg['main']['queries_dir']+source_table+'.sql'
		destination_table = str(cfg['destination'][source_table])
		#Get table_size
		sql_count = "SELECT COUNT(*) total FROM " + source_table + " WHERE active = '1'"
		source_cursor.execute(sql_count)
		table_size = source_cursor.fetchone()[0]
		#Use batch to get data
		while sql_counter < table_size:
			try:
				query = getsql(sqlfile).format(sql_counter, batch_size)
				source_cursor.execute(query)
				source_data = source_cursor.fetchall()
				#Save source_data using bulk replace_into
				savebatch(cfg, destination_table, source_data)
				#Increment batch_size
				sql_counter += batch_size
			except Exception, e:
				logfile = cfg['main']['logs_dir']+'failed_'+source_table+'.log'
				message = "Database: "+ source_db + " Error: "+ str(e)+" Query: "+query+";"
				writelog(logfile, message)
	#Close source connections
	source_cursor.close()
	source_cnx.close()
	#Drop source_db
	dropdatabase(cfg, source_db)
	#Display message
	print 'Success:',source_db,'data was extracted in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))

def savebatch(cfg, destination_table, source_data):
	#Get database connection
	target_db = cfg['main']['db_name']
	target_cnx = getdbconnection(cfg, target_db)
	target_cursor = target_cnx.cursor()
	try:
		target_cursor.executemany('"""'+getsql(cfg['main']['queries_dir']+destination_table+'_insert.sql')+'"""', source_data)
		#Commit changes and close connection
		target_cnx.commit()
		target_cursor.close()
		target_cnx.close()
		return {'status': True, 'message': destination_table + ' batch saved!'}
	except Exception, e:
		logfile = cfg['main']['logs_dir']+'failed_'+source_table+'.log'
		message = "Database: "+ target_db + " Error: "+ str(e)+";"
		writelog(logfile, message)
		return {'status': False, 'message': e}

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
	#getcheckbackups(ftpcfg, backup_dir, files_dir)

	#Get latest backups
	#backups = getlatestbackups(ftpcfg, backup_dir, files_dir)

	backups = {'14947' : '14947_20170925145229_v3.2.2.sql.zip'}
	#Import backups
	databases = extractbackup(backups)
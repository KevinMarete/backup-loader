import configparser
import ftplib
import sys
import os
import mysql.connector
import time

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
		start = time.time()
		filename = backups[mflcode]
		adt_version = filename.split('_')[2].replace('.sql.zip','')
		#Unzip sqlfile
		zipfile = os.path.join(files_dir, filename)
		sqlfile = os.path.join(files_dir, getuncompressedfile(zipfile, files_dir, mflcode))
		#Remove zipfile
		os.remove(zipfile)
		#Import sqlfile
		db_name = str(cfg['main']['db_prefix'])+mflcode
		response = importsql(cfg, db_name, sqlfile)
		#Remove sqlfile
		os.remove(sqlfile)
		#Show response
		if(response['status']):
			databases.append(db_name)
			#Log imported file
			logimportedfile(cfg, filename, mflcode, adt_version)	
			print 'success:',filename,'was imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
		else:
			print 'error:',filename,' failed to be imported in',time.strftime('%H:%M:%S', time.gmtime(time.time()-start))
	return databases

def getuncompressedfile(path_to_zip_file, directory_to_extract_to, mflcode):
	import zipfile
	archive = zipfile.ZipFile(path_to_zip_file)
	for file in archive.namelist():
	    if file.startswith(mflcode):
	        archive.extract(file, directory_to_extract_to)
		return file

def importsql(cfg, db_name, sqlfile):
	cnx = getconnection(cfg)
	cursor = cnx.cursor()
	try:
		cursor.execute("DROP DATABASE IF EXISTS "+db_name)
		cursor.execute("CREATE DATABASE "+db_name)
		import_command = "mysql -h "+cfg["database"]["hostname"]+" -P "+cfg["database"]["port"]+" -u "+cfg["database"]["username"]+" -p"+cfg["database"]["password"]+" "+db_name+" < "+sqlfile
		os.system(import_command)
		return {'status': True, 'message': 'Database Imported Successful'}
	except Exception, e:
		print 'error:',e
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
			print 'error: mflcode', mflcode, 'is missing!'
	except Exception, e:
		print 'error:',e
	#Commit changes and close connection
	cnx.commit()
	cursor.close()
	cnx.close()

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

	#Get backups
	backups = getlatestbackups(ftpcfg, backup_dir, files_dir)

	#Import backups
	databases = extractbackup(backups)
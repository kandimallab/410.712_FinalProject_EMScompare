#!/usr/bin/python

import sys
import csv
import MySQLdb
import hashlib
import time

# COMMENTED OUT TO PROTECT DATABASE CONTENTS FROM ACCIDENTAL RUNS


mydb = MySQLdb.connect(host='localhost',
  user='bkandim1',
  passwd='password',
  db='bkandim1')
cursor = mydb.cursor()

#csv_data = csv.reader(file('Crosswalk.txt'))
#csv_data = csv.reader(file('EMS Patients.txt'))
#csv_data = csv.reader(file('Hospital Patients.txt'))

for row in csv_data:
  #id = hashlib.sha256(row[0].upper() + row[1]).hexdigest()
  #it = time.strptime(row[2], "%m/%d/%Y %H:%M:%S");
  #ot = time.strftime("%Y-%m-%d %H:%M:%S", it)
  
  #cursor.execute("INSERT INTO crosswalk VALUES(" +
  #      "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", row)
  
  #cursor.execute("INSERT INTO ems_patients VALUES(%s, %s, %s)", 
  #      (id, ot, row[3]))

  #cursor.execute("INSERT INTO hospital_patients VALUES(" +
  #    "%s, %s, %s, %s, %s, %s, %s, %s, %s)", 
  #    (id, ot, row[3], row[4], row[5], row[6], row[7], row[8], row[9]))



# close the connection to the database.
mydb.commit()
cursor.close()



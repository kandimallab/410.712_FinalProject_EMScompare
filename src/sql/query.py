#!/usr/bin/python

import MySQLdb
import sys

mydb = MySQLdb.connect(host='localhost',
  user='bkandim1',
  passwd='password',
  db='bkandim1')
cursor = mydb.cursor()

qry = """
SELECT * FROM patient_points
WHERE impression=%s
AND sum_points=%s
ORDER BY sum_points ASC;
"""

cursor.execute(qry, ('%%', '%%'))

for row in cursor:
  print row


# close the connection to the database.
mydb.commit()
cursor.close()


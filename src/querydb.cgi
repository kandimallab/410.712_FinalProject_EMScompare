#!/usr/local/bin/python3

import mysql.connector
import cgi
import jinja2

# setup connection to the database
mydb = mysql.connector.connect(host='localhost',
  user='bkandim1',
  passwd='password',
  db='bkandim1')
cursor = mydb.cursor()

# tell template loader where to search for template files
templateLoader = jinja2.FileSystemLoader(searchpath="./templates")

# load a specific template
env = jinja2.Environment(loader=templateLoader)
template = env.get_template('table.html')

# get values from webpage and convert them to lower case
form = cgi.FieldStorage()
imp = form.getvalue("impression") 
score = form.getvalue("score")

# create select statement
qry = "SELECT * FROM patient_points"

if imp != 'all' and score != 'all':
  qry += " WHERE impression=%s"
  qry += " AND sum_points=%s;"
  cursor.execute(qry, (imp, score,))
elif imp != 'all':
  qry += " WHERE impression=%s;"
  cursor.execute(qry, (imp,))
elif score != 'all':
  qry += " WHERE sum_points=%s;"
  cursor.execute(qry, (score,))
else:
  cursor.execute(qry+';', )

# fetchall gets all data, makes len valid (not -1)
rows = cursor.fetchall() 

# print result to webpage
print("Content-Type:text/html\n\n")
print(template.render(rows=rows, num=len(rows), imp=imp, score=score))

# close the connection to the database.
cursor.close()


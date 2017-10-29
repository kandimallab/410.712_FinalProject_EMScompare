**PROGRAM**
--------------------------------------------------------------------------------
JHU - 410.712 Advanced Practical Computer Concepts for Bioinformatics
Final Project


**AUTHOR**
--------------------------------------------------------------------------------
Bhavya Kandimalla


**ABOUT**
--------------------------------------------------------------------------------
This program is an online quality control tool that asses EMS performance for
training and process improvement purposes by comparing EMS impressions to
eventual hospital diagnosis.

The program's algorithm calculates a EMS quality care score for each event
using a crosswalk to quantify EMS performance based on a 5-3-1-0 point system
assigned to impression-diagnosis matches. 5 points are awarded if the EMS
impression matches the first hospital diagnosis, 3 points are awarded if the
impression matches the second diagnosis, 1 point is awarded if the impression
matches the third diagnosis, and 0 points are awarded if the impression does not
match any of the three hospital diagnoses.

The results, which can be filtered by score and impression, are viewed at:
http://bfx.eng.jhu.edu/bkandim1/410.712_Advanced_Practical_Computer_Concepts_for_Bioinformatics/final/


**REQUIREMENTS**
--------------------------------------------------------------------------------
The recommended Python version is Python 2.6.6.

The recommended MySQL version is 5.1.73.

The program requires a stable internet connection. Any web browser can be used.

The EMS patient raw data file must be in the following format:  
   >`"Name",DateOfBirth,DispatchDate,"EMS Impression"`

The hospital patient raw data file must be in the following format:  
   >`"Name",DateOfBirth,AdmitDate,"Reason For Visit","Diagnosis1 Code", "Diagnosis1", "Diagnosis2 Code","Diagnosis2","Diagnosis3 Code","Diagnosis3"`


**USAGE**
--------------------------------------------------------------------------------
**SETUP AND BACKEND USE:**

1. Raw data files of the EMS Patients and Hospital must be uploaded to the
server as source files

2. To de-identify EMS patients and create patient-event table, un-comment lines
19, 23-25, and 30-31 of the insert.py script and, on the server, run command:  
   >`python insert.py`

3. To de-identify hospital patients and create patient-event table, un-comment
lines 20, 23-25, and 33-35 of the insert.py script and, on the server, run
command:  
   >`python insert.py`

4. To create crosswalk table, un-comment lines 18 and 27-28 of the insert.py
script and, on the server, run command:  
   >`python insert.py`

5. To run the data through the program and upload to database

   1. Log into the MySQL server:     
      >`mysql -u USERNAME -h localhost -p`

   2. Use the bkandim1 database:        
      >`use bkandim1;`
  
   3. Direct the source to the views.sql script:     
      >`source /FULLPATH/views.sql;`
    
    
**USER USE:**

6. View and query the results at:
(http://bfx.eng.jhu.edu/bkandim1/410.712_Advanced_Practical_Computer_Concepts_for_Bioinformatics/final/)  
  
  
**FILE NOTES:**  

EMS Patients.txt - raw EMS patient file  
Hospital Patients.txt - raw hospital patient file  
insert.py - de-identifies patients and inserts data into input tables  
tables.sql - defines structure of input tables  
views.sql - input table queries to create 8 views and 1 table for the program  
querydb.cgi - runs queries and returns results to the webpage  
query.sql - script to test queries  
query.py - test script


**DEMO DATA**
--------------------------------------------------------------------------------
The project source files can be found here:
https://github.com/kandimallab/410.712_FinalProject

A sample dataset can be viewed at:
http://bfx.eng.jhu.edu/bkandim1/410.712_Advanced_Practical_Computer_Concepts_for_Bioinformatics/final/
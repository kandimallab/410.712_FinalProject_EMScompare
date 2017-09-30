
use bkandim1;

/* COMMENTED OUT TO PROTECT DATABASE CONTENTS


DROP TABLE IF EXISTS crosswalk;
CREATE TABLE crosswalk (
  icd9code    VARCHAR(8), 
  cat1code    VARCHAR(64),
  cat2code    VARCHAR(64), 
  cat3code    VARCHAR(64), 
  diagnosis   VARCHAR(64), 
  impression1 VARCHAR(64), 
  impression2 VARCHAR(64), 
  impression3 VARCHAR(64),
  impression4 VARCHAR(64),
  impression5 VARCHAR(64)
);

DROP TABLE IF EXISTS ems_patients;
CREATE TABLE ems_patients (
  id            VARCHAR(64) NOT NULL, 
  dispatch_date DATETIME,
  impression    VARCHAR(64)
);

DROP TABLE IF EXISTS hospital_patients;
CREATE TABLE hospital_patients (
  id         VARCHAR(64) NOT NULL, 
  admit_date DATETIME,
  reason     VARCHAR(64),
  diag1code  VARCHAR(8),
  diag1      VARCHAR(64),
  diag2code  VARCHAR(8),
  diag2      VARCHAR(64),
  diag3code  VARCHAR(8),
  diag3      VARCHAR(64)
);
*/


/* THIS DOES NOT WORK- PERMISSION ISSUES

LOAD DATA INFILE '/home/bkandim1/tmp/Crosswalk.txt'
INTO TABLE crosswalk
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
*/

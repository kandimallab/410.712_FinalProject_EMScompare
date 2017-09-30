use bkandim1;

DROP VIEW IF EXISTS patient_events_raw;
CREATE VIEW patient_events_raw AS
SELECT
ems_patients.id,
ems_patients.dispatch_date,  hospital_patients.admit_date, 
ems_patients.impression,     hospital_patients.reason,
hospital_patients.diag1code, hospital_patients.diag1,
hospital_patients.diag2code, hospital_patients.diag2, 
hospital_patients.diag3code, hospital_patients.diag3
FROM 
ems_patients INNER JOIN hospital_patients ON 
ems_patients.id = hospital_patients.id
WHERE
ems_patients.dispatch_date   < admit_date AND
ems_patients.dispatch_date   > DATE(DATE_SUB(admit_date, INTERVAL 1 DAY)) AND
hospital_patients.admit_date > dispatch_date AND
hospital_patients.admit_date < DATE(DATE_ADD(dispatch_date, INTERVAL 2 DAY));


DROP VIEW IF EXISTS patient_events;
CREATE VIEW patient_events AS
SELECT
id,        dispatch_date, admit_date, impression,    reason,   
diag1code, diag1,         diag2code,  diag2,         diag3code, diag3
FROM 
patient_events_raw
WHERE impression='Airway Obstruction' OR 
impression='Allergic Reaction' OR impression='Amputation' OR 
impression='Behavioral Disorder' OR impression='Bleeding / Hemorrhage' OR 
impression='Burns' OR impression='Cardiac Arrest' OR 
impression='Cardiac Related (Potential)' OR 
impression='Diabetic Related (Potential)' OR 
impression='Environmental - Cold' OR impression='Environmental - Heat' OR
impression='Fracture / Dislocation' OR impression='Gastro-Intestinal Distress' 
OR impression='General Illness/Malaise' OR impression='Hazardous Materials' OR 
impression='Head Injury' OR impression='Major Trauma' OR impression='OB / GYN' 
OR impression='Obvious Death' OR impression='Other' OR impression='Pain' OR 
impression='Poisoning (Accidental)' OR impression='Respiratory Arrest' OR 
impression='Respiratory Distress' OR impression='Seizure' OR impression='Shock' 
OR impression='Soft Tissue Injury' OR impression='Spinal Injury' OR 
impression='Stroke / CVA' OR impression='Substance Abuse (Potential)' OR 
impression='Syncope' OR impression='Trauma - Blunt' OR 
impression='Trauma - Penetrating' OR impression='Unconscious / Unresponsive';


DROP VIEW IF EXISTS patient_points1;
CREATE VIEW patient_points1 (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT patient_events.id, patient_events.dispatch_date, patient_events.admit_date,
patient_events.impression, patient_events.reason,
crosswalk.cat1code, crosswalk.cat2code,
crosswalk.cat3code, patient_events.diag1code,
patient_events.diag1, IF(patient_events.diag1code <> '',
  IF(patient_events.diag1code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 5,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'), '') AS points1,
patient_events.diag2code, patient_events.diag2, NULL AS points2, patient_events.diag3code, patient_events.diag3, NULL AS points3
FROM patient_events, crosswalk
WHERE
patient_events.diag1code=crosswalk.icd9code;


DROP VIEW IF EXISTS patient_points2;
CREATE VIEW patient_points2 (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT patient_events.id, patient_events.dispatch_date, patient_events.admit_date,
patient_events.impression, patient_events.reason,
crosswalk.cat1code, crosswalk.cat2code,
crosswalk.cat3code, patient_events.diag1code,
patient_events.diag1, NULL AS points1, patient_events.diag2code, patient_events.diag2, IF(patient_events.diag2code <> '',
  IF(patient_events.diag2code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
      patient_events.impression=crosswalk.impression2 OR 
      patient_events.impression=crosswalk.impression3 OR 
      patient_events.impression=crosswalk.impression4 OR 
      patient_events.impression=crosswalk.impression5, 3,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'),'') AS points2, 
patient_events.diag3code, patient_events.diag3, NULL AS points3
FROM patient_events, crosswalk
WHERE patient_events.diag2code=crosswalk.icd9code;


DROP VIEW IF EXISTS patient_points3;
CREATE VIEW patient_points3 (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT patient_events.id, patient_events.dispatch_date, patient_events.admit_date,
patient_events.impression, patient_events.reason,
crosswalk.cat1code, crosswalk.cat2code,
crosswalk.cat3code, patient_events.diag1code,
patient_events.diag1, NULL AS points1, patient_events.diag2code, patient_events.diag2, NULL AS points2,
patient_events.diag3code, patient_events.diag3, IF(patient_events.diag3code <> '',
  IF(patient_events.diag3code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 1,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'),'')
AS points3
FROM patient_events, crosswalk
WHERE patient_events.diag3code=crosswalk.icd9code;


DROP VIEW IF EXISTS patient_points_rawUnion;
CREATE VIEW patient_points_rawUnion (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT patient_points1.id AS id, patient_points1.dispatch_date AS dispatch_date,
patient_points1.admit_date AS admit_date, patient_points1.impression AS impression,
patient_points1.reason AS reason, patient_points1.diag1_volume AS diag1_volume,
patient_points1.diag1_chapter AS diag1_chapter, patient_points1.diag1_category AS diag1_category,
patient_points1.diag1code AS diag1code, patient_points1.diag1 AS diag1, patient_points1.points1 AS points1,
patient_points1.diag2code, patient_points1.diag2, patient_points2.points2 AS points2,
patient_points1.diag3code AS diag3code, patient_points1.diag3 AS diag3, patient_points3.points3 AS points3
FROM patient_points1
LEFT JOIN patient_points2 ON patient_points1.id = patient_points2.id
LEFT JOIN patient_points3 ON patient_points1.id = patient_points3.id;


DROP VIEW IF EXISTS patient_points_raw;
CREATE VIEW patient_points_raw (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT id, dispatch_date, admit_date,
impression, reason, diag1_volume,
diag1_chapter, diag1_category,
diag1code, diag1, points1,
diag2code, diag2,
IF(points1 = 5 or ISNULL(points1), '', points2) AS points2,
diag3code, diag3,
IF(points2 = 3 or ISNULL(points2), '', points3) AS points3
FROM patient_points_rawUnion;


DROP VIEW IF EXISTS patient_points_sum;
CREATE VIEW patient_points_sum (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT id, dispatch_date, admit_date,
impression, reason, diag1_volume,
diag1_chapter, diag1_category,
diag1code, diag1, points1,
diag2code, diag2, IF(points1 = 5, '', points2) AS points2,
diag3code, diag3,
IF(points2 = 3 OR points2 = '', '', points3) AS points3
FROM patient_points_raw;




DROP TABLE IF EXISTS patient_points;
CREATE TABLE patient_points AS
SELECT DISTINCT id, dispatch_date, admit_date, impression, reason, 
diag1code, diag1, diag2code, diag2, diag3code, diag3,
(IF(points1='',0,points1)+IF(points2='',0,points2)+IF(points3='',0,points3)) AS sum_points
FROM patient_points_sum
GROUP BY id;




/*UNION
SELECT DISTINCT patient_points2.id AS id, patient_points2.dispatch_date AS dispatch_date,
patient_points2.admit_date AS admit_date, patient_points2.impression AS impression,
patient_points2.reason AS reason, patient_points2.diag1_volume AS diag1_volume,
patient_points2.diag1_chapter AS diag1_chapter, patient_points2.diag1_category AS diag1_category,
patient_points2.diag1code AS diag1code, patient_points2.diag1 AS diag1, NULL AS points1,
patient_points2.diag2code, patient_points2.diag2, patient_points2.points2 AS points2,
patient_points2.diag3code AS diag3code, patient_points2.diag3 AS diag3, NULL AS points3
FROM patient_points2
UNION
SELECT DISTINCT patient_points3.id AS id, patient_points3.dispatch_date AS dispatch_date,
patient_points3.admit_date AS admit_date, patient_points3.impression AS impression,
patient_points3.reason AS reason, patient_points3.diag1_volume AS diag1_volume,
patient_points3.diag1_chapter AS diag1_chapter, patient_points3.diag1_category AS diag1_category,
patient_points3.diag1code AS diag1code, patient_points3.diag1 AS diag1, NULL AS points1,
patient_points3.diag2code, patient_points3.diag2, NULL AS points2,
patient_points3.diag3code AS diag3code, patient_points3.diag3 AS diag3, patient_points3.points3 AS points3
FROM patient_points3;*/

/*DROP VIEW IF EXISTS patient_points_rawUnion;
CREATE VIEW patient_points_rawUnion (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT DISTINCT patient_points1.id AS id, patient_points1.dispatch_date AS dispatch_date,
patient_points1.admit_date AS admit_date, patient_points1.impression AS impression,
patient_points1.reason AS reason, patient_points1.diag1_volume AS diag1_volume,
patient_points1.diag1_chapter AS diag1_chapter, patient_points1.diag1_category AS diag1_category,
patient_points1.diag1code AS diag1code, patient_points1.diag1 AS diag1, patient_points1.points1 AS points1,
patient_points1.diag2code, patient_points1.diag2, NULL AS points2,
patient_points1.diag3code AS diag3code, patient_points1.diag3 AS diag3, NULL AS points3
FROM patient_points1
UNION
SELECT DISTINCT patient_points2.id AS id, patient_points2.dispatch_date AS dispatch_date,
patient_points2.admit_date AS admit_date, patient_points2.impression AS impression,
patient_points2.reason AS reason, patient_points2.diag1_volume AS diag1_volume,
patient_points2.diag1_chapter AS diag1_chapter, patient_points2.diag1_category AS diag1_category,
patient_points2.diag1code AS diag1code, patient_points2.diag1 AS diag1, NULL AS points1,
patient_points2.diag2code, patient_points2.diag2, patient_points2.points2 AS points2,
patient_points2.diag3code AS diag3code, patient_points2.diag3 AS diag3, NULL AS points3
FROM patient_points2
UNION
SELECT DISTINCT patient_points3.id AS id, patient_points3.dispatch_date AS dispatch_date,
patient_points3.admit_date AS admit_date, patient_points3.impression AS impression,
patient_points3.reason AS reason, patient_points3.diag1_volume AS diag1_volume,
patient_points3.diag1_chapter AS diag1_chapter, patient_points3.diag1_category AS diag1_category,
patient_points3.diag1code AS diag1code, patient_points3.diag1 AS diag1, NULL AS points1,
patient_points3.diag2code, patient_points3.diag2, NULL AS points2,
patient_points3.diag3code AS diag3code, patient_points3.diag3 AS diag3, patient_points3.points3 AS points3
FROM patient_points3;*/

/*SELECT id, diag1code, diag1, MAX(points1) AS points1, diag2code, diag2,
IF(points1 <> 5, MAX(points2), points2 = '') AS points2, diag3code, diag3,
IF(points2 <> 3 AND points2 <> '', MAX(points3), points3 = '') AS points3,
SUM(IF(ISNULL(points1), 0, points1) +IF(ISNULL(points2), 0, points2) +IF(ISNULL(points3), 0, points3)) AS sum_points
 FROM patient_points
 WHERE impression='Allergic Reaction'
 GROUP BY id;*/

/*DROP VIEW IF EXISTS patient_points3;
CREATE VIEW patient_points3 (id, dispatch_date, admit_date, impression, reason, diag1_volume, diag1_chapter,
diag1_category, diag1code, diag1, points1, diag2code, diag2, points2, diag3code, diag3, points3)
AS SELECT patient_events.id, patient_events.dispatch_date, patient_events.admit_date,
patient_events.impression, patient_events.reason,
crosswalk.cat1code, crosswalk.cat2code,
crosswalk.cat3code, patient_events.diag1code,
patient_events.diag1, patient_points2.points1,
patient_events.diag2code, patient_events.diag2, patient_points2.points2, 
patient_events.diag3code, patient_events.diag3, IF(patient_events.diag3code <> '',
  IF(points2 <> 3 AND points2 <> '',
  IF(patient_events.diag3code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 1,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'),''),'')
AS points3
FROM patient_events, patient_points2, crosswalk
WHERE patient_events.diag3code=crosswalk.icd9code;*/


/*CREATE VIEW patient_points1 AS
SELECT patient_events.id AS id, patient_events.dispatch_date AS dispatch_date, patient_events.admit_date AS admit_date,
patient_events.impression AS impression, patient_events.reason AS reason,
crosswalk.cat1code AS diag1_volume, crosswalk.cat2code AS diag1_chapter,
crosswalk.cat3code AS diag1_category, patient_events.diag1code,
patient_events.diag1,
@points1 :=
  IF(patient_events.diag1code <> '',
  IF(patient_events.diag1code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 5,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'), '')
AS points1,
patient_events.diag2code, patient_events.diag2, NULL AS points2, 
patient_events.diag3code, patient_events.diag3, NULL AS points3
FROM patient_events, crosswalk
WHERE
patient_events.diag1code=crosswalk.icd9code;*/

/*DROP VIEW IF EXISTS patient_events_points;

CREATE VIEW patient_events_points AS
(SELECT patient_events.id AS id, patient_events.dispatch_date AS dispatch_date, patient_events.admit_date AS admit_date,
patient_events.impression AS impression, patient_events.reason AS reason,
crosswalk.cat1code AS diag1_volume, crosswalk.cat2code AS diag1_chapter,
crosswalk.cat3code AS diag1_category, patient_events.diag1code,
patient_events.diag1,
@points1 :=
  IF(patient_events.diag1code <> '',
  IF(patient_events.diag1code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 5,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'), '')
AS points1,
patient_events.diag2code, patient_events.diag2, NULL AS points2, 
patient_events.diag3code, patient_events.diag3, NULL AS points3
FROM patient_events, crosswalk
WHERE
patient_events.diag1code=crosswalk.icd9code)
UNION
(SELECT patient_events.id AS id, patient_events.dispatch_date AS dispatch_date, patient_events.admit_date AS admit_date,
patient_events.impression AS impression, patient_events.reason AS reason,
NULL AS diag1_volume, NULL AS diag1_chapter, NULL AS diag1_category, patient_events.diag1code,
patient_events.diag1, NULL AS points1,
patient_events.diag2code, patient_events.diag2, @points2 :=
  IF(patient_events.diag2code <> '',
  IF(@points1 <> 5, 
  IF (patient_events.diag2code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
      patient_events.impression=crosswalk.impression2 OR 
      patient_events.impression=crosswalk.impression3 OR 
      patient_events.impression=crosswalk.impression4 OR 
      patient_events.impression=crosswalk.impression5, 3,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'),''),'')
AS points2, 
patient_events.diag3code, patient_events.diag3, NULL AS points3
FROM patient_events, crosswalk
WHERE
patient_events.diag2code=crosswalk.icd9code)
UNION
(SELECT patient_events.id AS id, patient_events.dispatch_date AS dispatch_date, patient_events.admit_date AS admit_date,
patient_events.impression AS impression, patient_events.reason AS reason,
NULL AS diag1_volume, NULL AS diag1_chapter,
NULL AS diag1_category, patient_events.diag1code,
patient_events.diag1, NULL AS points1,
patient_events.diag2code, patient_events.diag2, NULL AS points2, 
patient_events.diag3code, patient_events.diag3,@points3 :=
  IF(patient_events.diag3code <> '',
  IF(@points2 <> 3 AND @points2 <> '',
  IF(patient_events.diag3code=crosswalk.icd9code, 
  IF(patient_events.impression=crosswalk.impression1 OR 
    patient_events.impression=crosswalk.impression2 OR 
    patient_events.impression=crosswalk.impression3 OR 
    patient_events.impression=crosswalk.impression4 OR 
    patient_events.impression=crosswalk.impression5, 1,
  IF (ISNULL(crosswalk.impression1), 'no impression', 0)), 'no diagnosis'),''),'')
AS points3
FROM patient_events, crosswalk
WHERE
patient_events.diag3code=crosswalk.icd9code);*/

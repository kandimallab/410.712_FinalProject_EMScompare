use bkandim1;

/*
SELECT DISTINCT id, dispatch_date, admit_date, impression, reason, 
diag1code, diag1, diag2code, diag2, diag3code, diag3,
(IF(points1='',0,points1)+IF(points2='',0,points2)+IF(points3='',0,points3)) AS sum_points
 FROM patient_points
 WHERE impression='Allergic Reaction'
 AND sum_points=0
 ORDER BY sum_points ASC;
*/

SELECT * FROM patient_points
WHERE impression='Allergic Reaction'
AND sum_points=0
ORDER BY sum_points ASC;


/*SELECT id, diag1code, diag1, points1, diag2code, diag2,
IF(points1 = 5, '', points2) AS points2, diag3code,
diag3, IF(points2 = 3 OR points2 = '', '', points3) AS points3, (points1+points2+points3) AS sum_points 
 FROM patient_points
 WHERE impression='Pain'
 GROUP BY id;*/
/*@sum_points := 
  IF(@points1 <> 5, 0, @points1) +
  IF(@points2 <> 3, 0, @points2) +
  IF(@points3 <> 1, 0, @points3)
AS sum_points*/




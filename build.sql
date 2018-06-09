CONNECT TO CS240 @

-- NBC contains actual frequency counts for all column value class combinations
DROP TABLE NBC @

CREATE TABLE NBC (
	ColName VARCHAR(50),
	ColVal  VARCHAR(100),
	ClassLL VARCHAR(50),
	Freq INTEGER
) @

INSERT INTO NBC
	SELECT ColName, ColVal, ClassLL, count(*) AS Freq FROM 
	(SELECT ColName, ColVal, ClassLL FROM VTRAINDATA INNER JOIN VTRAINLABEL 
		ON VTRAINDATA.TupleId = VTRAINLABEL.TupleId)
	GROUP BY ColName, ColVal, ClassLL @

-- NBCTEST contains frequency counts for all column value class combinations in testing dataset
DROP TABLE NBCTEST @

CREATE TABLE NBCTEST (
	ColName VARCHAR(50),
	ColVal  VARCHAR(100),
	ClassLL VARCHAR(50)
) @

INSERT INTO NBCTEST
	SELECT ColName, ColVal, ClassLL AS Freq FROM 
	(SELECT ColName, ColVal, ClassLL FROM VTESTDATA INNER JOIN VTESTLABEL 
		ON VTESTDATA.TupleId = VTESTLABEL.TupleId)
	GROUP BY ColName, ColVal, ClassLL @

-- Insert combinations present in testing dataset but missing from training dataset
INSERT INTO NBC
	SELECT NBCTEST.ColName, NBCTEST.ColVal, NBCTEST.ClassLL, 0
	FROM NBCTEST
	LEFT JOIN NBC on NBCTEST.ColName = NBC.ColName and NBCTEST.ColVal = NBC.ColVal and NBCTEST.ClassLL = NBC.ClassLL
	WHERE NBC.ColName is null @

-- Apply Smoothing
CREATE OR REPLACE PROCEDURE smoothing(IN TabName VARCHAR(50), IN ColName VARCHAR(50), IN SmoothVal INTEGER)
LANGUAGE SQL
BEGIN
	DECLARE STMT VARCHAR(300);
	SET STMT = 'UPDATE ' || TabName || ' SET ' || ColName || ' = ' || ColName || ' + ' || SmoothVal;
	EXECUTE IMMEDIATE STMT;
END @

CALL smoothing('NBC', 'Freq', 1) @


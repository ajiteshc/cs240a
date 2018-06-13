CONNECT TO CS240 @

-- Number of test tuples for which class labels were correctly predicted.
SELECT COUNT(*)
	FROM PREDICTION AS P JOIN VTESTLABEL AS T 
	ON P.TupleId = T.TupleID AND P.ClassLL = T.ClassLL @

-- Total number of test tuples.
SELECT COUNT(*) FROM VTESTLABEL @

DROP TABLE ACCURACY @

CREATE TABLE ACCURACY (
	correctClassified INTEGER,
	testSamples INTEGER,
	accuracy DOUBLE
) @

BEGIN
	DECLARE correctClassified DOUBLE;
	DECLARE testSamples DOUBLE;
	DECLARE accuracy DOUBLE;
	
	SET correctClassified = (SELECT count(*) FROM
								PREDICTION AS P JOIN VTESTLABEL AS T 
								ON P.TupleId = T.TupleID AND P.ClassLL = T.ClassLL) ;
	
	SET testSamples = (SELECT COUNT(*) FROM VTESTLABEL);
	
	SET accuracy = correctClassified * 100 / testSamples;
	
	INSERT INTO ACCURACY VALUES (correctClassified, testSamples, accuracy);
END @

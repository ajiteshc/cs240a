CONNECT TO CS240 @

DROP TABLE LABELFREQ @

CREATE TABLE LABELFREQ (
	ClassLL VARCHAR (50),
	Freq INTEGER
) @

INSERT INTO LABELFREQ 
	SELECT ClassLL, count(ClassLL) FROM VTRAINLABEL GROUP BY ClassLL @

DROP TABLE PREDICTIONALL @

CREATE TABLE PREDICTIONALL (
	TupleId INTEGER,
	ClassLL VARCHAR(50),
	Prob DOUBLE
) @

DROP TABLE PREDICTION @

CREATE TABLE PREDICTION (
	TupleId INTEGER,
	ClassLL VARCHAR(50),
	Prob DOUBLE
) @

BEGIN
	DECLARE probCurrent DOUBLE;
	DECLARE probOutput DOUBLE;
	DECLARE classOutput VARCHAR(50);
	DECLARE numberOfTrainSamples INTEGER;
	DECLARE numberOfTestSamples INTEGER;
	DECLARE freqCurrent INTEGER;
	SET numberOfTrainSamples = (SELECT COUNT(*) FROM VTRAINLABEL);
	FOR testSample as SELECT * FROM VTESTLABEL DO
		SET probOutput = 0;
		FOR class AS SELECT * FROM LABELFREQ DO
			SET probCurrent = class.Freq;
			-- SET probCurrent = probCurrent / numberOfTrainSamples;
			FOR row AS SELECT * FROM VTESTDATA WHERE TupleId = testSample.TupleId DO
				SET freqCurrent = (SELECT Freq FROM NBC 
										WHERE NBC.ColName = row.ColName
											and NBC.ColVal = row.ColVal
											and NBC.ClassLL = class.ClassLL);
				SET probCurrent = probCurrent * freqCurrent;
				-- SET probCurrent = probCurrent / class.Freq;
			END FOR;
			INSERT INTO PREDICTIONALL VALUES (testSample.TupleId, class.ClassLL, probCurrent);
			IF probCurrent > probOutput THEN
				SET probOutput = probCurrent;
				SET classOutput = class.ClassLL;
			END IF;
		END FOR;
	INSERT INTO PREDICTION VALUES (testSample.TupleId, classOutput, probOutput);
	END FOR;
END @


CONNECT TO CS240 @

-- LABELFREQ containes class label frequencies in train data.
DROP TABLE LABELFREQ @

CREATE TABLE LABELFREQ (
	ClassLL VARCHAR(100),
	Freq INTEGER
) @

INSERT INTO LABELFREQ 
	SELECT ClassLL, count(ClassLL) FROM VTRAINLABEL GROUP BY ClassLL @

-- PREDICTION table holds the actual predicted class labels.
DROP TABLE PREDICTION @

CREATE TABLE PREDICTION (
	TupleId INTEGER,
	ClassLL VARCHAR(100),
	Prob DOUBLE
) @

BEGIN
	DECLARE probCurrent DOUBLE;
	DECLARE probOutput DOUBLE;
	DECLARE classOutput VARCHAR(100);
	DECLARE numberOfTrainSamples INTEGER;
	DECLARE numberOfTestSamples INTEGER;
	DECLARE freqCurrent INTEGER;
	DECLARE expCurrent DOUBLE;
	DECLARE meanCurrent DOUBLE;
	DECLARE varCurrent DOUBLE;
	DECLARE denomCurrent DOUBLE;
	SET numberOfTrainSamples = (SELECT COUNT(*) FROM VTRAINLABEL);
	
	-- Iterate over each testing tuple.
	FOR testSample as SELECT * FROM VTESTLABEL DO
		SET probOutput = 0;
		-- Iterate over each class label.
		FOR class AS SELECT * FROM LABELFREQ DO
			-- Calculate class label probability.
			SET probCurrent = class.Freq;
			SET probCurrent = probCurrent / numberOfTrainSamples;
			-- Iterate over each non-numeric column of a tuple.
			FOR row AS SELECT * FROM VTESTDATA WHERE TupleId = testSample.TupleId DO
				-- The attribute is non-numeric, use normal NBC with frequency counts.
				SET freqCurrent = (SELECT Freq FROM NBC 
										WHERE NBC.ColName = row.ColName
											AND NBC.ColVal = row.ColVal
											AND NBC.ClassLL = class.ClassLL);
				SET probCurrent = probCurrent * freqCurrent;
				SET probCurrent = probCurrent / class.Freq;
			END FOR;
			-- Iterate over each numeric column of a tuple.
			FOR row AS SELECT * FROM VTESTDATANUMERIC WHERE TupleId = testSample.TupleId DO
				-- The attribute is numeric, use Gaussian probability distribution
				-- with the mean and variance values.
				SET meanCurrent = (SELECT Mean FROM NBCNUMERIC
									WHERE NBCNUMERIC.ColName = row.ColName
										AND NBCNUMERIC.ClassLL = class.ClassLL);
				SET varCurrent = (SELECT Variance FROM NBCNUMERIC
									WHERE NBCNUMERIC.ColName = row.ColName
										AND NBCNUMERIC.ClassLL = class.ClassLL);
				SET expCurrent = (SELECT POWER((row.ColVal - meanCurrent), 2)
									FROM SYSIBM.SYSDUMMY1);
				SET expCurrent = expCurrent / (2 * varCurrent);
				SET expCurrent = (SELECT EXP(-expCurrent) FROM SYSIBM.SYSDUMMY1);
				SET probCurrent = probCurrent * expCurrent;
				SET denomCurrent = (SELECT 2*ASIN(1) FROM SYSIBM.SYSDUMMY1);
				SET denomCurrent = 2 * denomCurrent * varCurrent;
				SET denomCurrent = (SELECT SQRT(denomCurrent) FROM SYSIBM.SYSDUMMY1);
				SET probCurrent = probCurrent / denomCurrent;
			END FOR;
			-- Update class label if probability is highest ever seen.
			IF probCurrent > probOutput THEN
				SET probOutput = probCurrent;
				SET classOutput = class.ClassLL;
			END IF;
		END FOR;
	INSERT INTO PREDICTION VALUES (testSample.TupleId, classOutput, probOutput);
	END FOR;
END @

DROP TABLE LABELFREQ @
DROP TABLE NBC @
DROP TABLE NBCNUMERIC @
DROP TABLE VTRAINLABEL @
DROP TABLE VTESTDATA @
DROP TABLE VTESTDATANUMERIC @
DROP TABLE NUMERIC @

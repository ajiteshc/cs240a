CONNECT TO CS240 @

DROP TABLE vtraindata @

CREATE TABLE vtraindata (
	TupleId INTEGER,
	ColNum  INTEGER,
	ColName VARCHAR(50),
	ColVal  VARCHAR(100),
	IsCont  INTEGER DEFAULT '0' NOT NULL,
	Weight  DECIMAL DEFAULT '1.0' NOT NULL
) @

DROP TABLE vtrainlabel @

CREATE TABLE vtrainlabel (
	TupleId INTEGER,
	ClassLL VARCHAR(50),
	Weight  DECIMAL DEFAULT '1.0' NOT NULL
) @

DROP TABLE vtestdata @

CREATE TABLE vtestdata (
	TupleId INTEGER,
	ColNum  INTEGER,
	ColName VARCHAR(50),
	ColVal  VARCHAR(100),
	IsCont  INTEGER DEFAULT '0' NOT NULL,
	Weight  DECIMAL DEFAULT '1.0' NOT NULL
) @

DROP TABLE vtestlabel @

CREATE TABLE vtestlabel (
	TupleId INTEGER,
	ClassLL VARCHAR(50),
	Weight  DECIMAL DEFAULT '1.0' NOT NULL
) @

CREATE OR REPLACE PROCEDURE getTotalColumns(IN TabName VARCHAR(100), OUT TotCols INTEGER)
LANGUAGE SQL
BEGIN
	SET TotCols = (	SELECT count(*)
			FROM   SYSIBM.SYSCOLUMNS
			WHERE  tbname = TabName );
END @

CREATE OR REPLACE PROCEDURE getColumnName(IN TabName VARCHAR(100), IN ColNum INTEGER, OUT ColName VARCHAR(100))
LANGUAGE SQL
BEGIN
	SET ColName = (	SELECT name
			FROM   SYSIBM.SYSCOLUMNS
			WHERE  tbname = TabName AND colno = ColNum );
END @

CREATE OR REPLACE PROCEDURE getColumnNumber(IN TabName VARCHAR(100), IN ColName VARCHAR(100), OUT ColNum INTEGER)
LANGUAGE SQL
BEGIN
	SET ColNum =  (	SELECT colno
			FROM   SYSIBM.SYSCOLUMNS
			WHERE  tbname = TabName AND name = ColName );
END @


CREATE OR REPLACE PROCEDURE verticalize(IN TrainTabName VARCHAR(50), IN TestTabName VARCHAR(50), IN classColName VARCHAR(100))
LANGUAGE SQL
BEGIN
	DECLARE TCol INTEGER;
	DECLARE CNo  INTEGER;
	DECLARE classCol INTEGER;
	DECLARE CNam VARCHAR(100);
	DECLARE STMT VARCHAR(300);

	CALL getTotalColumns(TrainTabName, TCol);

	-- For training data
	-- For data values except class labels
	CALL getColumnNumber(TrainTabName, classColName, classCol);
	SET CNo = 1;
	WHILE CNo < TCol
	DO
		IF CNo != classCol THEN
			CALL getColumnName(TrainTabName, CNo, CNam);
			SET STMT = 'INSERT INTO VTRAINDATA (TupleId, ColNum, ColName, ColVal)
				SELECT row_id, ''' || CNo || ''', ''' || CNam || ''', ' || CNam || ' FROM ' || TrainTabName;
			EXECUTE IMMEDIATE STMT;
		END IF;
		SET CNo = CNo + 1;
	END WHILE;

	-- For class labels
	CALL getColumnName(TrainTabName, classCol, CNam);
	SET STMT = 'INSERT INTO VTRAINLABEL (TupleId, ClassLL)
		SELECT row_id, ' || CNam || ' FROM ' || TrainTabName;
	EXECUTE IMMEDIATE STMT;

	-- For testing data
	-- For data values except class labels
	CALL getColumnNumber(TrainTabName, classColName, classCol);
	SET CNo = 1;
	WHILE CNo < TCol
	DO
		IF CNo != classCol THEN
			CALL getColumnName(TestTabName, CNo, CNam);
			SET STMT = 'INSERT INTO VTESTDATA (TupleId, ColNum, ColName, ColVal)
				SELECT row_id, ''' || CNo || ''', ''' || CNam || ''', ' || CNam || ' FROM ' || TestTabName;
			EXECUTE IMMEDIATE STMT;
		END IF;
		SET CNo = CNo + 1;
	END WHILE;

	-- For class labels
	CALL getColumnName(TestTabName, classCol, CNam);
	SET STMT = 'INSERT INTO VTESTLABEL (TupleId, ClassLL)
		SELECT row_id, ' || CNam || ' FROM ' || TestTabName;
	EXECUTE IMMEDIATE STMT;
	
	-- Handling Missing Class Values
	-- Most frequent label
	SET STMT = 'SELECT classll FROM vtrainlabel GROUP BY classll ORDER BY COUNT(classll) DESC LIMIT 1';
	-- SET STMT = '';
	-- EXECUTE IMMEDIATE STMT;
	
END @

CALL verticalize('TRAIN1', 'TEST1', 'EATABLE') @

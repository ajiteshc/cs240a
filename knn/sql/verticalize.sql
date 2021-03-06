CONNECT TO CS240 @

DROP TABLE vtraindata @

CREATE TABLE vtraindata (
	TupleId INTEGER,
	ColNum INTEGER,
	ColName VARCHAR(50),
	ColVal DOUBLE
) @

DROP TABLE vtrainlabel @

CREATE TABLE vtrainlabel (
	TupleId INTEGER,
	ClassLL VARCHAR(50)
) @

DROP TABLE vtestdata @

CREATE TABLE vtestdata (
	TupleId INTEGER,
	ColNum INTEGER,
	ColName VARCHAR(50),
	ColVal DOUBLE
) @

DROP TABLE vtestlabel @

CREATE TABLE vtestlabel (
	TupleId INTEGER,
	ClassLL VARCHAR(50)
) @

CREATE OR REPLACE PROCEDURE getTotalColumns(IN TabName VARCHAR(100), OUT TotCols INTEGER)
LANGUAGE SQL
BEGIN
	SET TotCols = (SELECT count(*) FROM SYSIBM.SYSCOLUMNS WHERE tbname = TabName);
END @

CREATE OR REPLACE PROCEDURE getColumnName(IN TabName VARCHAR(100), IN ColNum INTEGER, OUT ColName VARCHAR(100))
LANGUAGE SQL
BEGIN
	SET ColName = (SELECT name FROM SYSIBM.SYSCOLUMNS WHERE tbname = TabName AND colno = ColNum);
END @

CREATE OR REPLACE PROCEDURE getColumnNumber(IN TabName VARCHAR(100), IN ColName VARCHAR(100), OUT ColNum INTEGER)
LANGUAGE SQL
BEGIN
	SET ColNum = (SELECT colno FROM SYSIBM.SYSCOLUMNS WHERE tbname = TabName AND name = ColName);
END @


CREATE OR REPLACE PROCEDURE verticalize(IN TrainTabName VARCHAR(50), IN TestTabName VARCHAR(50), IN classColName VARCHAR(100))
LANGUAGE SQL
BEGIN
	DECLARE TCol INTEGER;
	DECLARE CNo INTEGER;
	DECLARE classCol INTEGER;
	DECLARE colName VARCHAR(100);
	DECLARE STMT VARCHAR(300);

	CALL getTotalColumns(TrainTabName, TCol);

	-- For training data
	-- For data values except class labels
	CALL getColumnNumber(TrainTabName, classColName, classCol);
	SET CNo = 1;
	WHILE CNo < TCol
	DO
		IF CNo != classCol THEN
			CALL getColumnName(TrainTabName, CNo, colName);
			SET STMT = 'INSERT INTO VTRAINDATA (TupleId, ColNum, ColName, ColVal)
				SELECT row_id, ''' || CNo || ''', ''' || colName || ''', ' || colName || ' FROM ' || TrainTabName;
			EXECUTE IMMEDIATE STMT;
		END IF;
		SET CNo = CNo + 1;
	END WHILE;

	-- For class labels
	CALL getColumnName(TrainTabName, classCol, colName);
	SET STMT = 'INSERT INTO VTRAINLABEL (TupleId, ClassLL)
		SELECT row_id, ' || colName || ' FROM ' || TrainTabName;
	EXECUTE IMMEDIATE STMT;
	
	-- For testing data
	-- For data values except class labels
	CALL getColumnNumber(TestTabName, classColName, classCol);
	SET CNo = 1;
	WHILE CNo < TCol
	DO
		IF CNo != classCol THEN
			CALL getColumnName(TestTabName, CNo, colName);
			SET STMT = 'INSERT INTO VTESTDATA (TupleId, ColNum, ColName, ColVal)
				SELECT row_id, ''' || CNo || ''', ''' || colName || ''', ' || colName || ' FROM ' || TestTabName;
			EXECUTE IMMEDIATE STMT;
		END IF;
		SET CNo = CNo + 1;
	END WHILE;

	-- For class labels
	CALL getColumnName(TestTabName, classCol, colName);
	SET STMT = 'INSERT INTO VTESTLABEL (TupleId, ClassLL)
		SELECT row_id, ' || colName || ' FROM ' || TestTabName;
	EXECUTE IMMEDIATE STMT;
END @

CALL verticalize('TRAIN', 'TEST', 'CLASS') @


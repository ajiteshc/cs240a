DROP TABLE DISTANCE @

CREATE TABLE DISTANCE (
	TrainTupleId INTEGER,
	TestTupleId INTEGER,
	Distance DOUBLE
) @

DROP TABLE PREDICTION @

CREATE TABLE PREDICTION (
	TupleId INTEGER,
	ClassLL INTEGER
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

CREATE OR REPLACE PROCEDURE knn(IN k INTEGER)
LANGUAGE SQL
BEGIN
	DECLARE distCurrent DOUBLE;
	DECLARE testNo INTEGER;
	DECLARE trainNo INTEGER;
	DECLARE testTotal INTEGER;
	DECLARE trainTotal INTEGER;
	DECLARE distPoint DOUBLE;
	
	DECLARE p INTEGER;
	
	SET trainTotal = (SELECT COUNT(*) FROM VTRAINLABEL);
	SET testTotal = (SELECT COUNT(*) FROM VTESTLABEL);
	
	SET testNo = 1;
	WHILE testNo <= testTotal DO
		SET trainNo = 1;
		WHILE trainNo <= trainTotal DO
			SET distCurrent = 0;
			FOR column AS (SELECT VTRAINDATA.ColName,
								VTRAINDATA.ColVal AS TrainVal,
								VTESTDATA.ColVal AS TestVal
							FROM VTRAINDATA JOIN VTESTDATA ON VTRAINDATA.ColName = VTESTDATA.ColName
							WHERE VTRAINDATA.TupleId = trainNo AND VTESTDATA.TupleId = testNo) DO
				SET distPoint = (SELECT POWER((column.TrainVal - column.TestVal), 2)
									FROM SYSIBM.SYSDUMMY1);
				SET distCurrent = distCurrent + distPoint;
			END FOR;
			INSERT INTO DISTANCE VALUES (trainNo, testNo, distCurrent);
			SET trainNo = trainNo + 1;
		END WHILE;
		
		SET p = (select classll from (
					SELECT vtrainlabel.classll, distance.distance
						from distance join vtrainlabel 
							on distance.testtupleid = testNo
							and distance.traintupleid = vtrainlabel.tupleid
						order by distance.distance
						limit k
					)
					group by classll
					order by count(classll) desc
					limit 1
				);
		INSERT INTO PREDICTION VALUES (testNo, p);
		SET testNo = testNo + 1;
	END WHILE;
END @

CALL knn(20) @
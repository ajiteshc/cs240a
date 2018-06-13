CONNECT TO CS240 @

DROP TABLE dataset2 @

CREATE TABLE dataset2 (
	row_id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1, INCREMENT BY +1),
	age INTEGER,
	job VARCHAR(50),
	marital VARCHAR(50),
	education VARCHAR(50),
	default VARCHAR(50),
	housing VARCHAR(50),
	loan VARCHAR(50),
	contact VARCHAR(50),
	month VARCHAR(50),
	day_of_week VARCHAR(50),
	duration INTEGER,
	campaign INTEGER,
	pdays INTEGER,
	previous DOUBLE,
	poutcome VARCHAR(50),
	emp_var_rate DOUBLE,
	cons_price_idx DOUBLE,
	cons_conf_idx DOUBLE,
	euribor3m DOUBLE,
	nr_employed DOUBLE,
	y VARCHAR(50)
) @


IMPORT FROM '../data/bank-additional/bank-additional.csv' 
OF DEL MODIFIED by coldel; SKIPCOUNT 1
INSERT INTO dataset2
	(age,
	job,
	marital,
	education,
	default,
	housing,
	loan,
	contact,
	month,
	day_of_week,
	duration,
	campaign,
	pdays,
	previous,
	poutcome,
	emp_var_rate,
	cons_price_idx,
	cons_conf_idx,
	euribor3m,
	nr_employed,
	y) @

DROP TABLE numeric @

CREATE TABLE numeric (
	ColName VARCHAR(50)
) @

INSERT INTO numeric (ColName) VALUES
	('AGE'),
	('DURATION'),
	('CAMPAIGN'),
	('PDAYS'),
	('PREVIOUS'),
	('EMP_VAR_RATE'),
	('CONS_PRICE_IDX'),
	('CONS_CONF_IDX'),
	('EURIBOR3M'),
	('NR_EMPLOYED') @


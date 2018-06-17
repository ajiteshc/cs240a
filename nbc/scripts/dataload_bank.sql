CONNECT TO CS240 @

DROP TABLE dataset2 @

CREATE TABLE dataset2 (
	row_id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1, INCREMENT BY +1),
	age INTEGER,
	job VARCHAR(100),
	marital VARCHAR(100),
	education VARCHAR(100),
	default VARCHAR(100),
	housing VARCHAR(100),
	loan VARCHAR(100),
	contact VARCHAR(100),
	month VARCHAR(100),
	day_of_week VARCHAR(100),
	duration INTEGER,
	campaign INTEGER,
	pdays INTEGER,
	previous DOUBLE,
	poutcome VARCHAR(100),
	emp_var_rate DOUBLE,
	cons_price_idx DOUBLE,
	cons_conf_idx DOUBLE,
	euribor3m DOUBLE,
	nr_employed DOUBLE,
	y VARCHAR(100)
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
	ColName VARCHAR(100)
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


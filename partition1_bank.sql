CONNECT TO CS240 @

DROP TABLE train2 @
DROP TABLE test2 @

CREATE TABLE train2 (
	row_id INTEGER,
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

CREATE TABLE test2 (
	row_id INTEGER,
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

BEGIN
	DECLARE total_rows INTEGER;
	DECLARE test_rows INTEGER;
	DECLARE counter INTEGER;
	SET total_rows = (SELECT COUNT(*) FROM dataset2);
	SET test_rows = total_rows / 5;
	SET counter = 1;
	FOR temp AS SELECT * FROM dataset2 ORDER BY row_id DO
		IF counter <= test_rows THEN
			INSERT INTO test2 VALUES
				(temp.row_id,
				temp.age,
				temp.job,
				temp.marital,
				temp.education,
				temp.default,
				temp.housing,
				temp.loan,
				temp.contact,
				temp.month,
				temp.day_of_week,
				temp.duration,
				temp.campaign,
				temp.pdays,
				temp.previous,
				temp.poutcome,
				temp.emp_var_rate,
				temp.cons_price_idx,
				temp.cons_conf_idx,
				temp.euribor3m,
				temp.nr_employed,
				temp.y);
		ELSE
			INSERT INTO train2 VALUES
				(temp.row_id,
				temp.age,
				temp.job,
				temp.marital,
				temp.education,
				temp.default,
				temp.housing,
				temp.loan,
				temp.contact,
				temp.month,
				temp.day_of_week,
				temp.duration,
				temp.campaign,
				temp.pdays,
				temp.previous,
				temp.poutcome,
				temp.emp_var_rate,
				temp.cons_price_idx,
				temp.cons_conf_idx,
				temp.euribor3m,
				temp.nr_employed,
				temp.y);
		END IF;
		SET counter = counter + 1;
	END FOR;
END @

DROP TABLE dataset2 @

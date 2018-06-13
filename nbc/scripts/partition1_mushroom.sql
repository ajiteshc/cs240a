CONNECT TO CS240 @

DROP TABLE train1 @
DROP TABLE test1 @

CREATE TABLE train1 (
	row_id INTEGER,
	eatable VARCHAR(50),
	cap_shape VARCHAR(50),
	cap_surface VARCHAR(50),
	cap_color VARCHAR(50),
	bruises VARCHAR(50),
	odor VARCHAR(50),
	gill_attachment VARCHAR(50),
	gill_spacing VARCHAR(50),
	gill_size VARCHAR(50),
	gill_color VARCHAR(50),
	st_shape VARCHAR(50),
	st_root VARCHAR(50),
	st_surface_above_ring VARCHAR(50),
	st_surface_below_ring VARCHAR(50),
	st_color_above_ring VARCHAR(50),
	st_color_below_ring VARCHAR(50),
	veil_type VARCHAR(50),
	veil_color VARCHAR(50),
	ring_number VARCHAR(50),
	ring_type VARCHAR(50),
	spore_print_color VARCHAR(50),
	population VARCHAR(50),
	habitat VARCHAR(50)
) @

CREATE TABLE test1 (
	row_id INTEGER,
	eatable VARCHAR(50),
	cap_shape VARCHAR(50),
	cap_surface VARCHAR(50),
	cap_color VARCHAR(50),
	bruises VARCHAR(50),
	odor VARCHAR(50),
	gill_attachment VARCHAR(50),
	gill_spacing VARCHAR(50),
	gill_size VARCHAR(50),
	gill_color VARCHAR(50),
	st_shape VARCHAR(50),
	st_root VARCHAR(50),
	st_surface_above_ring VARCHAR(50),
	st_surface_below_ring VARCHAR(50),
	st_color_above_ring VARCHAR(50),
	st_color_below_ring VARCHAR(50),
	veil_type VARCHAR(50),
	veil_color VARCHAR(50),
	ring_number VARCHAR(50),
	ring_type VARCHAR(50),
	spore_print_color VARCHAR(50),
	population VARCHAR(50),
	habitat VARCHAR(50)
) @

-- Divide into partitions based on row positions.
BEGIN
	DECLARE total_rows INTEGER;
	DECLARE test_rows INTEGER;
	DECLARE counter INTEGER;
	SET total_rows = (SELECT COUNT(*) FROM dataset1);
	SET test_rows = total_rows / 5;
	SET counter = 1;
	FOR temp AS SELECT * FROM dataset1 ORDER BY row_id DO
		IF counter <= test_rows THEN
			INSERT INTO test1 VALUES
				(temp.row_id,
				temp.eatable,
				temp.cap_shape,
				temp.cap_surface,
				temp.cap_color,
				temp.bruises,
				temp.odor,
				temp.gill_attachment,
				temp.gill_spacing,
				temp.gill_size,
				temp.gill_color,
				temp.st_shape,
				temp.st_root,
				temp.st_surface_above_ring,
				temp.st_surface_below_ring,
				temp.st_color_above_ring,
				temp.st_color_below_ring,
				temp.veil_type,
				temp.veil_color,
				temp.ring_number,
				temp.ring_type,
				temp.spore_print_color,
				temp.population,
				temp.habitat);
		ELSE
			INSERT INTO train1 VALUES
				(temp.row_id,
				temp.eatable,
				temp.cap_shape,
				temp.cap_surface,
				temp.cap_color,
				temp.bruises,
				temp.odor,
				temp.gill_attachment,
				temp.gill_spacing,
				temp.gill_size,
				temp.gill_color,
				temp.st_shape,
				temp.st_root,
				temp.st_surface_above_ring,
				temp.st_surface_below_ring,
				temp.st_color_above_ring,
				temp.st_color_below_ring,
				temp.veil_type,
				temp.veil_color,
				temp.ring_number,
				temp.ring_type,
				temp.spore_print_color,
				temp.population,
				temp.habitat);
		END IF;
		SET counter = counter + 1;
	END FOR;
END @

DROP TABLE dataset1 @

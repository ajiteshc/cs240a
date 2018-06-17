CONNECT TO CS240 @

DROP TABLE train1 @
DROP TABLE test1 @

CREATE TABLE train1 (
	row_id INTEGER,
	eatable VARCHAR(100),
	cap_shape VARCHAR(100),
	cap_surface VARCHAR(100),
	cap_color VARCHAR(100),
	bruises VARCHAR(100),
	odor VARCHAR(100),
	gill_attachment VARCHAR(100),
	gill_spacing VARCHAR(100),
	gill_size VARCHAR(100),
	gill_color VARCHAR(100),
	st_shape VARCHAR(100),
	st_root VARCHAR(100),
	st_surface_above_ring VARCHAR(100),
	st_surface_below_ring VARCHAR(100),
	st_color_above_ring VARCHAR(100),
	st_color_below_ring VARCHAR(100),
	veil_type VARCHAR(100),
	veil_color VARCHAR(100),
	ring_number VARCHAR(100),
	ring_type VARCHAR(100),
	spore_print_color VARCHAR(100),
	population VARCHAR(100),
	habitat VARCHAR(100)
) @

CREATE TABLE test1 (
	row_id INTEGER,
	eatable VARCHAR(100),
	cap_shape VARCHAR(100),
	cap_surface VARCHAR(100),
	cap_color VARCHAR(100),
	bruises VARCHAR(100),
	odor VARCHAR(100),
	gill_attachment VARCHAR(100),
	gill_spacing VARCHAR(100),
	gill_size VARCHAR(100),
	gill_color VARCHAR(100),
	st_shape VARCHAR(100),
	st_root VARCHAR(100),
	st_surface_above_ring VARCHAR(100),
	st_surface_below_ring VARCHAR(100),
	st_color_above_ring VARCHAR(100),
	st_color_below_ring VARCHAR(100),
	veil_type VARCHAR(100),
	veil_color VARCHAR(100),
	ring_number VARCHAR(100),
	ring_type VARCHAR(100),
	spore_print_color VARCHAR(100),
	population VARCHAR(100),
	habitat VARCHAR(100)
) @

-- Divide into partitions randomly.
BEGIN
	FOR temp AS SELECT * FROM dataset1 ORDER BY row_id DO
		IF rand() > 0.8 THEN
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
	END FOR;
END @

DROP TABLE dataset1 @

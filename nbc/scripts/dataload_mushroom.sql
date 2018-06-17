CONNECT TO CS240 @

DROP TABLE dataset1 @

CREATE TABLE dataset1 (
	row_id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1, INCREMENT BY +1),
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


LOAD FROM '../data/mushroom/agaricus-lepiota.data'
OF DEL MODIFIED by coldel, IDENTITYMISSING
INSERT INTO dataset1 @

DROP TABLE numeric @

CREATE TABLE numeric (
	ColName VARCHAR(100)
) @

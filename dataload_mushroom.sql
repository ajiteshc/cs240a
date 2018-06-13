CONNECT TO CS240 @

DROP TABLE dataset1 @

CREATE TABLE dataset1 (
	row_id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH +1, INCREMENT BY +1),
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


LOAD FROM '../data/mushroom/agaricus-lepiota.data' 
OF DEL MODIFIED by coldel, IDENTITYMISSING
INSERT INTO dataset1 @

DROP TABLE numeric @

CREATE TABLE numeric (
	ColName VARCHAR(50)
) @

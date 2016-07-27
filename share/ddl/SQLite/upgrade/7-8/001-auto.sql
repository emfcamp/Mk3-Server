-- Convert schema 'share/ddl/_source/deploy/7/001-auto.yml' to 'share/ddl/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE categories_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(25) NOT NULL
);

;
INSERT INTO categories_temp_alter( id, name) SELECT id, name FROM categories;

;
DROP TABLE categories;

;
CREATE TABLE categories (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(25) NOT NULL
);

;
CREATE UNIQUE INDEX categories_name02 ON categories (name);

;
INSERT INTO categories SELECT id, name FROM categories_temp_alter;

;
DROP TABLE categories_temp_alter;

;

COMMIT;


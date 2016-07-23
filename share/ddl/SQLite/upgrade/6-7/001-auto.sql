-- Convert schema 'share/ddl/_source/deploy/6/001-auto.yml' to 'share/ddl/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE categories (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(10) NOT NULL
);

;
CREATE UNIQUE INDEX categories_name ON categories (name);

;
ALTER TABLE projects ADD COLUMN category_id int;

;
CREATE INDEX projects_idx_category_id ON projects (category_id);

;

;

COMMIT;


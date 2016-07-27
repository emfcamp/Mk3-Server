-- Convert schema 'share/ddl/_source/deploy/7/001-auto.yml' to 'share/ddl/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE categories CHANGE COLUMN name name varchar(25) NOT NULL;

;

COMMIT;


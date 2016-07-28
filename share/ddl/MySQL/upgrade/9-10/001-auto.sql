-- Convert schema 'share/ddl/_source/deploy/9/001-auto.yml' to 'share/ddl/_source/deploy/10/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE users CHANGE COLUMN password password varchar(100) NOT NULL;

;

COMMIT;


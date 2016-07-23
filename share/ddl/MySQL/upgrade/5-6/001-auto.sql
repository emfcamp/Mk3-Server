-- Convert schema 'share/ddl/_source/deploy/5/001-auto.yml' to 'share/ddl/_source/deploy/6/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE files ADD COLUMN file_hash varchar(70) NULL;

;

COMMIT;


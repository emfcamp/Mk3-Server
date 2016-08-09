-- Convert schema 'share/ddl/_source/deploy/11/001-auto.yml' to 'share/ddl/_source/deploy/12/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE projects ADD COLUMN published boolean DEFAULT 1 NOT NULL;

;

COMMIT;


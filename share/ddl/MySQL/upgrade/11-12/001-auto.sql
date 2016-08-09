-- Convert schema 'share/ddl/_source/deploy/11/001-auto.yml' to 'share/ddl/_source/deploy/12/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE projects ADD COLUMN published enum('0','1') NOT NULL DEFAULT 1;

;

COMMIT;


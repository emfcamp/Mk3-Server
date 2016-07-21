-- Convert schema 'share/ddl/_source/deploy/4/001-auto.yml' to 'share/ddl/_source/deploy/5/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE projects ADD COLUMN latest_allowed_version integer NULL;

;

COMMIT;


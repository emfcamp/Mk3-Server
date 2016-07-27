-- Convert schema 'share/ddl/_source/deploy/8/001-auto.yml' to 'share/ddl/_source/deploy/9/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE projects CHANGE COLUMN category_id category_id integer NULL DEFAULT 0;

;

COMMIT;


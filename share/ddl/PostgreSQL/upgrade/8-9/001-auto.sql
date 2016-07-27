-- Convert schema 'share/ddl/_source/deploy/8/001-auto.yml' to 'share/ddl/_source/deploy/9/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE projects ALTER COLUMN category_id SET DEFAULT 0;

;

COMMIT;


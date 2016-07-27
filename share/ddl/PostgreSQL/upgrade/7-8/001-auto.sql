-- Convert schema 'share/ddl/_source/deploy/7/001-auto.yml' to 'share/ddl/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE categories ALTER COLUMN name TYPE character varying(25);

;

COMMIT;


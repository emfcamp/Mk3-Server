-- Convert schema 'share/ddl/_source/deploy/9/001-auto.yml' to 'share/ddl/_source/deploy/10/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE users ALTER COLUMN password TYPE character varying(100);

;

COMMIT;


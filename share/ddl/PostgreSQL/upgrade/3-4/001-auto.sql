-- Convert schema 'share/ddl/_source/deploy/3/001-auto.yml' to 'share/ddl/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE versions ADD COLUMN status character varying(10) DEFAULT 'new' NOT NULL;

;

COMMIT;


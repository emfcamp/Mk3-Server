-- Convert schema 'share/ddl/_source/deploy/2/001-auto.yml' to 'share/ddl/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE versions ADD COLUMN tar_file text NOT NULL;

;
ALTER TABLE versions ADD COLUMN zip_file text NOT NULL;

;
ALTER TABLE versions ADD COLUMN gz_file text NOT NULL;

;

COMMIT;


-- Convert schema 'share/ddl/_source/deploy/3/001-auto.yml' to 'share/ddl/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE files ALTER COLUMN file DROP NOT NULL;

;
ALTER TABLE projects ADD COLUMN lc_name character varying(255) NOT NULL;

;
ALTER TABLE users ADD COLUMN lc_username character varying(255) NOT NULL;

;
ALTER TABLE users ADD CONSTRAINT users_lc_username UNIQUE (lc_username);

;
ALTER TABLE versions ALTER COLUMN tar_file DROP NOT NULL;

;
ALTER TABLE versions ALTER COLUMN zip_file DROP NOT NULL;

;
ALTER TABLE versions ALTER COLUMN gz_file DROP NOT NULL;

;

COMMIT;


-- Convert schema 'share/ddl/_source/deploy/3/001-auto.yml' to 'share/ddl/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE files CHANGE COLUMN file file text NULL;

;
ALTER TABLE projects ADD COLUMN lc_name varchar(255) NOT NULL;

;
ALTER TABLE users ADD COLUMN lc_username varchar(255) NOT NULL,
                  ADD UNIQUE users_lc_username (lc_username);

;
ALTER TABLE versions CHANGE COLUMN tar_file tar_file text NULL,
                     CHANGE COLUMN zip_file zip_file text NULL,
                     CHANGE COLUMN gz_file gz_file text NULL;

;

COMMIT;


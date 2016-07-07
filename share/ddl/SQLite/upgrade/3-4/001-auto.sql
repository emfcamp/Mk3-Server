-- Convert schema 'share/ddl/_source/deploy/3/001-auto.yml' to 'share/ddl/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE files_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  version_id int NOT NULL,
  filename varchar(255) NOT NULL,
  file text,
  FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO files_temp_alter( id, version_id, filename, file) SELECT id, version_id, filename, file FROM files;

;
DROP TABLE files;

;
CREATE TABLE files (
  id INTEGER PRIMARY KEY NOT NULL,
  version_id int NOT NULL,
  filename varchar(255) NOT NULL,
  file text,
  FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX files_idx_version_id02 ON files (version_id);

;
INSERT INTO files SELECT id, version_id, filename, file FROM files_temp_alter;

;
DROP TABLE files_temp_alter;

;
ALTER TABLE projects ADD COLUMN lc_name varchar(255) NOT NULL;

;
ALTER TABLE users ADD COLUMN lc_username varchar(255) NOT NULL;

;
CREATE UNIQUE INDEX users_lc_username ON users (lc_username);

;
CREATE TEMPORARY TABLE versions_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  project_id int NOT NULL,
  timestamp datetime NOT NULL,
  description text NOT NULL,
  tar_file text,
  zip_file text,
  gz_file text,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO versions_temp_alter( id, project_id, timestamp, description, tar_file, zip_file, gz_file) SELECT id, project_id, timestamp, description, tar_file, zip_file, gz_file FROM versions;

;
DROP TABLE versions;

;
CREATE TABLE versions (
  id INTEGER PRIMARY KEY NOT NULL,
  project_id int NOT NULL,
  timestamp datetime NOT NULL,
  description text NOT NULL,
  tar_file text,
  zip_file text,
  gz_file text,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX versions_idx_project_id02 ON versions (project_id);

;
INSERT INTO versions SELECT id, project_id, timestamp, description, tar_file, zip_file, gz_file FROM versions_temp_alter;

;
DROP TABLE versions_temp_alter;

;

COMMIT;


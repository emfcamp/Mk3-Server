-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE files (
  id INTEGER PRIMARY KEY NOT NULL,
  version_id int NOT NULL,
  filename varchar(255) NOT NULL,
  file text NOT NULL,
  FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX files_idx_version_id ON files (version_id);

;
CREATE TABLE projects (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id int NOT NULL,
  name varchar(255) NOT NULL,
  description text NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX projects_idx_user_id ON projects (user_id);

;
CREATE TABLE versions (
  id INTEGER PRIMARY KEY NOT NULL,
  project_id int NOT NULL,
  timestamp datetime NOT NULL,
  description text NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX versions_idx_project_id ON versions (project_id);

;

COMMIT;


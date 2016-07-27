-- Convert schema 'share/ddl/_source/deploy/8/001-auto.yml' to 'share/ddl/_source/deploy/9/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE projects_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id int NOT NULL,
  name varchar(255) NOT NULL,
  lc_name varchar(255) NOT NULL,
  description text NOT NULL,
  category_id int DEFAULT 0,
  latest_allowed_version int,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO projects_temp_alter( id, user_id, name, lc_name, description, category_id, latest_allowed_version) SELECT id, user_id, name, lc_name, description, category_id, latest_allowed_version FROM projects;

;
DROP TABLE projects;

;
CREATE TABLE projects (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id int NOT NULL,
  name varchar(255) NOT NULL,
  lc_name varchar(255) NOT NULL,
  description text NOT NULL,
  category_id int DEFAULT 0,
  latest_allowed_version int,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX projects_idx_category_id02 ON projects (category_id);

;
CREATE INDEX projects_idx_user_id02 ON projects (user_id);

;
INSERT INTO projects SELECT id, user_id, name, lc_name, description, category_id, latest_allowed_version FROM projects_temp_alter;

;
DROP TABLE projects_temp_alter;

;

COMMIT;


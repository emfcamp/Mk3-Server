-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Aug  9 22:44:32 2016
-- 

;
BEGIN TRANSACTION;
--
-- Table: badges
--
CREATE TABLE badges (
  id INTEGER PRIMARY KEY NOT NULL,
  badge_id varchar(100) NOT NULL,
  secret varchar(100) NOT NULL
);
CREATE UNIQUE INDEX badges_badge_id ON badges (badge_id);
--
-- Table: categories
--
CREATE TABLE categories (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(25) NOT NULL
);
CREATE UNIQUE INDEX categories_name ON categories (name);
--
-- Table: roles
--
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL
);
CREATE UNIQUE INDEX roles_name ON roles (name);
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(255) NOT NULL,
  lc_username varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(100) NOT NULL,
  set_password_code varchar(80)
);
CREATE UNIQUE INDEX users_email ON users (email);
CREATE UNIQUE INDEX users_lc_username ON users (lc_username);
CREATE UNIQUE INDEX users_username ON users (username);
--
-- Table: projects
--
CREATE TABLE projects (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id int NOT NULL,
  name varchar(255) NOT NULL,
  lc_name varchar(255) NOT NULL,
  description text NOT NULL,
  category_id int DEFAULT 0,
  latest_allowed_version int,
  published boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX projects_idx_category_id ON projects (category_id);
CREATE INDEX projects_idx_user_id ON projects (user_id);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  user_id int NOT NULL,
  role_id int NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_roles_idx_role_id ON user_roles (role_id);
CREATE INDEX user_roles_idx_user_id ON user_roles (user_id);
--
-- Table: versions
--
CREATE TABLE versions (
  id INTEGER PRIMARY KEY NOT NULL,
  project_id int NOT NULL,
  version int NOT NULL DEFAULT 1,
  timestamp datetime NOT NULL,
  description text NOT NULL,
  tar_file text,
  zip_file text,
  gz_file text,
  status varchar(10) NOT NULL DEFAULT 'new',
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX versions_idx_project_id ON versions (project_id);
CREATE UNIQUE INDEX versions_project_id_version ON versions (project_id, version);
--
-- Table: files
--
CREATE TABLE files (
  id INTEGER PRIMARY KEY NOT NULL,
  version_id int NOT NULL,
  filename varchar(255) NOT NULL,
  file_hash varchar(70),
  file text,
  FOREIGN KEY (version_id) REFERENCES versions(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX files_idx_version_id ON files (version_id);
COMMIT;

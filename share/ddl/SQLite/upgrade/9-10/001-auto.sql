-- Convert schema 'share/ddl/_source/deploy/9/001-auto.yml' to 'share/ddl/_source/deploy/10/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(255) NOT NULL,
  lc_username varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(100) NOT NULL,
  set_password_code varchar(80)
);

;
INSERT INTO users_temp_alter( id, username, lc_username, email, password, set_password_code) SELECT id, username, lc_username, email, password, set_password_code FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(255) NOT NULL,
  lc_username varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(100) NOT NULL,
  set_password_code varchar(80)
);

;
CREATE UNIQUE INDEX users_email02 ON users (email);

;
CREATE UNIQUE INDEX users_lc_username02 ON users (lc_username);

;
CREATE UNIQUE INDEX users_username02 ON users (username);

;
INSERT INTO users SELECT id, username, lc_username, email, password, set_password_code FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;

COMMIT;


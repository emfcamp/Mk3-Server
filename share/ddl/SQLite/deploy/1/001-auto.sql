-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Wed Jun 29 18:01:13 2016
-- 

;
BEGIN TRANSACTION;
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  password varchar(50) NOT NULL,
  set_password_code varchar(80)
);
CREATE UNIQUE INDEX users_email ON users (email);
CREATE UNIQUE INDEX users_username ON users (username);
COMMIT;

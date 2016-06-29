-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Wed Jun 29 18:01:13 2016
-- 
;
--
-- Table: users
--
CREATE TABLE "users" (
  "id" serial NOT NULL,
  "username" character varying(255) NOT NULL,
  "email" character varying(255) NOT NULL,
  "password" character varying(50) NOT NULL,
  "set_password_code" character varying(80),
  PRIMARY KEY ("id"),
  CONSTRAINT "users_email" UNIQUE ("email"),
  CONSTRAINT "users_username" UNIQUE ("username")
);

;

-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Thu Jun 30 18:28:04 2016
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
--
-- Table: projects
--
CREATE TABLE "projects" (
  "id" serial NOT NULL,
  "user_id" integer NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "projects_idx_user_id" on "projects" ("user_id");

;
--
-- Table: versions
--
CREATE TABLE "versions" (
  "id" serial NOT NULL,
  "project_id" integer NOT NULL,
  "timestamp" timestamp NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "versions_idx_project_id" on "versions" ("project_id");

;
--
-- Table: files
--
CREATE TABLE "files" (
  "id" serial NOT NULL,
  "version_id" integer NOT NULL,
  "filename" character varying(255) NOT NULL,
  "file" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "files_idx_version_id" on "files" ("version_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "projects" ADD CONSTRAINT "projects_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "versions" ADD CONSTRAINT "versions_fk_project_id" FOREIGN KEY ("project_id")
  REFERENCES "projects" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "files" ADD CONSTRAINT "files_fk_version_id" FOREIGN KEY ("version_id")
  REFERENCES "versions" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

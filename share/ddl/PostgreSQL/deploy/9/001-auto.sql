-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Wed Jul 27 23:45:51 2016
-- 
;
--
-- Table: categories
--
CREATE TABLE "categories" (
  "id" serial NOT NULL,
  "name" character varying(25) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "categories_name" UNIQUE ("name")
);

;
--
-- Table: roles
--
CREATE TABLE "roles" (
  "id" serial NOT NULL,
  "name" character varying(255) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "roles_name" UNIQUE ("name")
);

;
--
-- Table: users
--
CREATE TABLE "users" (
  "id" serial NOT NULL,
  "username" character varying(255) NOT NULL,
  "lc_username" character varying(255) NOT NULL,
  "email" character varying(255) NOT NULL,
  "password" character varying(50) NOT NULL,
  "set_password_code" character varying(80),
  PRIMARY KEY ("id"),
  CONSTRAINT "users_email" UNIQUE ("email"),
  CONSTRAINT "users_lc_username" UNIQUE ("lc_username"),
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
  "lc_name" character varying(255) NOT NULL,
  "description" text NOT NULL,
  "category_id" integer DEFAULT 0,
  "latest_allowed_version" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "projects_idx_category_id" on "projects" ("category_id");
CREATE INDEX "projects_idx_user_id" on "projects" ("user_id");

;
--
-- Table: user_roles
--
CREATE TABLE "user_roles" (
  "user_id" integer NOT NULL,
  "role_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "role_id")
);
CREATE INDEX "user_roles_idx_role_id" on "user_roles" ("role_id");
CREATE INDEX "user_roles_idx_user_id" on "user_roles" ("user_id");

;
--
-- Table: versions
--
CREATE TABLE "versions" (
  "id" serial NOT NULL,
  "project_id" integer NOT NULL,
  "version" integer DEFAULT 1 NOT NULL,
  "timestamp" timestamp NOT NULL,
  "description" text NOT NULL,
  "tar_file" text,
  "zip_file" text,
  "gz_file" text,
  "status" character varying(10) DEFAULT 'new' NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "versions_project_id_version" UNIQUE ("project_id", "version")
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
  "file_hash" character varying(70),
  "file" text,
  PRIMARY KEY ("id")
);
CREATE INDEX "files_idx_version_id" on "files" ("version_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "projects" ADD CONSTRAINT "projects_fk_category_id" FOREIGN KEY ("category_id")
  REFERENCES "categories" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "projects" ADD CONSTRAINT "projects_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_fk_role_id" FOREIGN KEY ("role_id")
  REFERENCES "roles" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "versions" ADD CONSTRAINT "versions_fk_project_id" FOREIGN KEY ("project_id")
  REFERENCES "projects" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "files" ADD CONSTRAINT "files_fk_version_id" FOREIGN KEY ("version_id")
  REFERENCES "versions" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

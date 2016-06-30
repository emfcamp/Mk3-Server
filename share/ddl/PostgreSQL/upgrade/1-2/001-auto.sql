-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "files" (
  "id" serial NOT NULL,
  "version_id" integer NOT NULL,
  "filename" character varying(255) NOT NULL,
  "file" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "files_idx_version_id" on "files" ("version_id");

;
CREATE TABLE "projects" (
  "id" serial NOT NULL,
  "user_id" integer NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "projects_idx_user_id" on "projects" ("user_id");

;
CREATE TABLE "versions" (
  "id" serial NOT NULL,
  "project_id" integer NOT NULL,
  "timestamp" timestamp NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "versions_idx_project_id" on "versions" ("project_id");

;
ALTER TABLE "files" ADD CONSTRAINT "files_fk_version_id" FOREIGN KEY ("version_id")
  REFERENCES "versions" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "projects" ADD CONSTRAINT "projects_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "versions" ADD CONSTRAINT "versions_fk_project_id" FOREIGN KEY ("project_id")
  REFERENCES "projects" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;


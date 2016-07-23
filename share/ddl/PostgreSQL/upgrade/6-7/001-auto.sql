-- Convert schema 'share/ddl/_source/deploy/6/001-auto.yml' to 'share/ddl/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "categories" (
  "id" serial NOT NULL,
  "name" character varying(10) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "categories_name" UNIQUE ("name")
);

;
ALTER TABLE projects ADD COLUMN category_id integer;

;
CREATE INDEX projects_idx_category_id on projects (category_id);

;
ALTER TABLE projects ADD CONSTRAINT projects_fk_category_id FOREIGN KEY (category_id)
  REFERENCES categories (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;


-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE versions ADD COLUMN version int NOT NULL DEFAULT 1;

;
CREATE UNIQUE INDEX versions_project_id_version ON versions (project_id, version);

;

COMMIT;


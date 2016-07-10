-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE versions ADD COLUMN version integer DEFAULT 1 NOT NULL;

;
ALTER TABLE versions ADD CONSTRAINT versions_project_id_version UNIQUE (project_id, version);

;

COMMIT;


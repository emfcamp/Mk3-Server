-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE versions ADD COLUMN version integer NOT NULL DEFAULT 1,
                     ADD UNIQUE versions_project_id_version (project_id, version);

;

COMMIT;


-- Convert schema 'share/ddl/_source/deploy/10/001-auto.yml' to 'share/ddl/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE badges (
  id INTEGER PRIMARY KEY NOT NULL,
  badge_id varchar(100) NOT NULL,
  secret varchar(100) NOT NULL
);

;
CREATE UNIQUE INDEX badges_badge_id ON badges (badge_id);

;

COMMIT;


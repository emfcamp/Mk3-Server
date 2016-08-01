-- Convert schema 'share/ddl/_source/deploy/10/001-auto.yml' to 'share/ddl/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "badges" (
  "id" serial NOT NULL,
  "badge_id" character varying(100) NOT NULL,
  "secret" character varying(100) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "badges_badge_id" UNIQUE ("badge_id")
);

;

COMMIT;


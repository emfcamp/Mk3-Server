-- Convert schema 'share/ddl/_source/deploy/10/001-auto.yml' to 'share/ddl/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
SET foreign_key_checks=0;

;
CREATE TABLE `badges` (
  `id` integer NOT NULL auto_increment,
  `badge_id` varchar(100) NOT NULL,
  `secret` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `badges_badge_id` (`badge_id`)
);

;
SET foreign_key_checks=1;

;

COMMIT;


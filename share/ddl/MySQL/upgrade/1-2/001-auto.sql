-- Convert schema 'share/ddl/_source/deploy/1/001-auto.yml' to 'share/ddl/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
SET foreign_key_checks=0;

;
CREATE TABLE `files` (
  `id` integer NOT NULL auto_increment,
  `version_id` integer NOT NULL,
  `filename` varchar(255) NOT NULL,
  `file` text NOT NULL,
  INDEX `files_idx_version_id` (`version_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `files_fk_version_id` FOREIGN KEY (`version_id`) REFERENCES `versions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

;
CREATE TABLE `projects` (
  `id` integer NOT NULL auto_increment,
  `user_id` integer NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  INDEX `projects_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `projects_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

;
CREATE TABLE `versions` (
  `id` integer NOT NULL auto_increment,
  `project_id` integer NOT NULL,
  `timestamp` datetime NOT NULL,
  `description` text NOT NULL,
  INDEX `versions_idx_project_id` (`project_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `versions_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

;
SET foreign_key_checks=1;

;
ALTER TABLE users ENGINE=InnoDB;

;

COMMIT;


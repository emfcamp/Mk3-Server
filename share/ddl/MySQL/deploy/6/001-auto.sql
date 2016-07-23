-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sat Jul 23 13:02:00 2016
-- 
;
SET foreign_key_checks=0;
--
-- Table: `roles`
--
CREATE TABLE `roles` (
  `id` integer NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `roles_name` (`name`)
) ENGINE=InnoDB;
--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `lc_username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `set_password_code` varchar(80) NULL,
  PRIMARY KEY (`id`),
  UNIQUE `users_email` (`email`),
  UNIQUE `users_lc_username` (`lc_username`),
  UNIQUE `users_username` (`username`)
) ENGINE=InnoDB;
--
-- Table: `projects`
--
CREATE TABLE `projects` (
  `id` integer NOT NULL auto_increment,
  `user_id` integer NOT NULL,
  `name` varchar(255) NOT NULL,
  `lc_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `latest_allowed_version` integer NULL,
  INDEX `projects_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `projects_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `user_roles`
--
CREATE TABLE `user_roles` (
  `user_id` integer NOT NULL,
  `role_id` integer NOT NULL,
  INDEX `user_roles_idx_role_id` (`role_id`),
  INDEX `user_roles_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `user_roles_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_roles_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `versions`
--
CREATE TABLE `versions` (
  `id` integer NOT NULL auto_increment,
  `project_id` integer NOT NULL,
  `version` integer NOT NULL DEFAULT 1,
  `timestamp` datetime NOT NULL,
  `description` text NOT NULL,
  `tar_file` text NULL,
  `zip_file` text NULL,
  `gz_file` text NULL,
  `status` varchar(10) NOT NULL DEFAULT 'new',
  INDEX `versions_idx_project_id` (`project_id`),
  PRIMARY KEY (`id`),
  UNIQUE `versions_project_id_version` (`project_id`, `version`),
  CONSTRAINT `versions_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `files`
--
CREATE TABLE `files` (
  `id` integer NOT NULL auto_increment,
  `version_id` integer NOT NULL,
  `filename` varchar(255) NOT NULL,
  `file_hash` varchar(70) NULL,
  `file` text NULL,
  INDEX `files_idx_version_id` (`version_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `files_fk_version_id` FOREIGN KEY (`version_id`) REFERENCES `versions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1;

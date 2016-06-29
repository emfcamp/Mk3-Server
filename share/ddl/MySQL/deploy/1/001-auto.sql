-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Wed Jun 29 18:01:13 2016
-- 
;
SET foreign_key_checks=0;
--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `set_password_code` varchar(80) NULL,
  PRIMARY KEY (`id`),
  UNIQUE `users_email` (`email`),
  UNIQUE `users_username` (`username`)
);
SET foreign_key_checks=1;

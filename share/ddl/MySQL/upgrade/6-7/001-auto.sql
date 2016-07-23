-- Convert schema 'share/ddl/_source/deploy/6/001-auto.yml' to 'share/ddl/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
SET foreign_key_checks=0;

;
CREATE TABLE `categories` (
  `id` integer NOT NULL auto_increment,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `categories_name` (`name`)
) ENGINE=InnoDB;

;
SET foreign_key_checks=1;

;
ALTER TABLE projects ADD COLUMN category_id integer NULL,
                     ADD INDEX projects_idx_category_id (category_id),
                     ADD CONSTRAINT projects_fk_category_id FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE ON UPDATE CASCADE;

;

COMMIT;


-- Convert schema 'share/ddl/_source/deploy/2/001-auto.yml' to 'share/ddl/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL
);

;
CREATE UNIQUE INDEX roles_name ON roles (name);

;
CREATE TABLE user_roles (
  user_id int NOT NULL,
  role_id int NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX user_roles_idx_role_id ON user_roles (role_id);

;
CREATE INDEX user_roles_idx_user_id ON user_roles (user_id);

;

COMMIT;


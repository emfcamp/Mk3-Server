CREATE OR REPLACE FUNCTION "reset_sequence" (tablename text) 
RETURNS "pg_catalog"."void" AS
$body$
DECLARE
BEGIN
  EXECUTE 'SELECT setval( pg_get_serial_sequence(''' || tablename || ''', ''id''),
    (SELECT COALESCE(MAX(id)+1,1) FROM ' || tablename || '), false)';
END;
$body$  LANGUAGE 'plpgsql';

SELECT reset_sequence('categories');
SELECT reset_sequence('users');
SELECT reset_sequence('projects');
SELECT reset_sequence('versions');
SELECT reset_sequence('files');
SELECT reset_sequence('roles');

DROP FUNCTION reset_sequence(text);

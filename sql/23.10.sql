--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: irida-database-changes/changesets/23.10/all-changes.xml
--  Ran at: 10/23/23, 1:40 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset irida-database-changes/changesets/23.10/user-table-user-type.xml::user-table-user-type::jeff
ALTER TABLE irida.user ADD user_type VARCHAR(255) NOT NULL;

UPDATE irida.user SET user_type = 'TYPE_LOCAL';

ALTER TABLE irida.user_AUD ADD user_type VARCHAR(255) NOT NULL;

UPDATE irida.user_AUD SET user_type = 'TYPE_LOCAL';

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('user-table-user-type', 'jeff', 'irida-database-changes/changesets/23.10/user-table-user-type.xml', NOW(), 127, '9:b9a49d99874f475c2dc9efe020257753', 'addColumn tableName=user; update tableName=user; addColumn tableName=user_AUD; update tableName=user_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


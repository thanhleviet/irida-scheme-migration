--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 20.01/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 20.01/oauth-redirect-uri.xml::analysis-templates::tom
ALTER TABLE irida.client_details ADD redirect_uri VARCHAR(255) NULL;

ALTER TABLE irida.client_details_AUD ADD redirect_uri VARCHAR(255) NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('analysis-templates', 'tom', '20.01/oauth-redirect-uri.xml', NOW(), 120, '9:4d2f27d55ed295c1d81b89f0a28fe24c', 'addColumn tableName=client_details; addColumn tableName=client_details_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


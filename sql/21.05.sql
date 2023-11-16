--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 21.05/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 21.05/project-default-metadata-template.xml::project-default-metadata-template::deep
ALTER TABLE irida.project ADD default_metadata_template BIGINT NULL;

ALTER TABLE irida.project ADD CONSTRAINT FK_PROJECT_METADATA_TEMPLATE FOREIGN KEY (default_metadata_template) REFERENCES irida.metadata_template (id);

ALTER TABLE irida.project_AUD ADD default_metadata_template BIGINT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('project-default-metadata-template', 'deep', '21.05/project-default-metadata-template.xml', NOW(), 120, '9:6e54111a0d68f7873904100c5b47558f', 'addColumn tableName=project; addColumn tableName=project_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


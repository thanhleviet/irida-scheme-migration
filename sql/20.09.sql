--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 20.09/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 20.09/metadata-template-description.xml::metadata-template-description::josh
ALTER TABLE irida.metadata_template ADD `description` LONGTEXT NULL;

ALTER TABLE irida.metadata_template_AUD ADD `description` LONGTEXT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('metadata-template-description', 'josh', '20.09/metadata-template-description.xml', NOW(), 120, '9:64ef074fa4a607b5435be9024216bf46', 'addColumn tableName=metadata_template; addColumn tableName=metadata_template_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 20.09/assembly-sync-remote-status.xml::assembly-sync-remote-status::tom
ALTER TABLE irida.uploaded_assembly ADD remote_status BIGINT NULL;

ALTER TABLE irida.uploaded_assembly ADD CONSTRAINT FK_ASSEMBLY_REMOTE_STATUS FOREIGN KEY (remote_status) REFERENCES irida.remote_status (id);

ALTER TABLE irida.uploaded_assembly_AUD ADD remote_status BIGINT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('assembly-sync-remote-status', 'tom', '20.09/assembly-sync-remote-status.xml', NOW(), 121, '9:eb20fc5cd656b080309eabf871f631c7', 'addColumn tableName=uploaded_assembly; addColumn tableName=uploaded_assembly_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


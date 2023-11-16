--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 23.01/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 23.01/metadata-field-add-label-constraint.xml::metadata-field-add-label-constraint::katherine
ALTER TABLE irida.metadata_field ADD CONSTRAINT UK_METADATA_FIELD_LABEL UNIQUE (label);

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('metadata-field-add-label-constraint', 'katherine', '23.01/metadata-field-add-label-constraint.xml', NOW(), 120, '9:9cecbe868feabd5abd0628b4d3564141', 'addUniqueConstraint constraintName=UK_METADATA_FIELD_LABEL, tableName=metadata_field', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 23.01/add-unique-constraint-to-user-group-project.xml::add-unique-constraint-to-user-group-project::deep
DELETE ugp1 FROM user_group_project ugp1, user_group_project ugp2 WHERE ugp1.id > ugp2.id AND ugp1.project_id = ugp2.project_id AND ugp1.user_group_id = ugp2.user_group_id;

ALTER TABLE irida.user_group_project ADD CONSTRAINT UK_USERGROUP_PROJECT UNIQUE (project_id, user_group_id);

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('add-unique-constraint-to-user-group-project', 'deep', '23.01/add-unique-constraint-to-user-group-project.xml', NOW(), 121, '9:6655f743b5ddf2f35c3834fd9c7e96fb', 'sql; addUniqueConstraint constraintName=UK_USERGROUP_PROJECT, tableName=user_group_project', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


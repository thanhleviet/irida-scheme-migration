--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 22.05/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 22.05/user-account-project-subscription.xml::user-account-project-subscription::katherine
CREATE TABLE irida.project_subscription (id BIGINT AUTO_INCREMENT NOT NULL, project_id BIGINT NOT NULL, user_id BIGINT NOT NULL, email_subscription BIT(1) NOT NULL, created_date datetime NOT NULL, CONSTRAINT PK_PROJECT_SUBSCRIPTION PRIMARY KEY (id), CONSTRAINT FK_PROJECT_SUBSCRIPTION_PROJECT FOREIGN KEY (project_id) REFERENCES irida.project(id), CONSTRAINT FK_PROJECT_SUBSCRIPTION_USER FOREIGN KEY (user_id) REFERENCES irida.user(id));

ALTER TABLE irida.project_subscription ADD CONSTRAINT UK_PROJECT_SUBSCRIPTION_PROJECT_USER UNIQUE (project_id, user_id);

CREATE TABLE irida.project_subscription_AUD (id BIGINT AUTO_INCREMENT NOT NULL, REV INT NOT NULL, REVTYPE TINYINT(4) NULL, project_id BIGINT NOT NULL, user_id BIGINT NOT NULL, email_subscription BIT(1) NOT NULL, created_date datetime NOT NULL, CONSTRAINT PK_PROJECT_SUBSCRIPTION_AUD PRIMARY KEY (id, REV), CONSTRAINT FK_PROJECT_SUBSCRIPTION_REVISION FOREIGN KEY (REV) REFERENCES irida.Revisions(id));

INSERT INTO project_subscription (project_id, user_id, email_subscription, created_date)
            SELECT project_id, user_id, MAX(email_subscription), MIN(created_date) FROM
            (SELECT project_id, user_id, IF(email_subscription=b'1', 1, 0) as email_subscription, now() as created_date FROM project_user
            UNION
            SELECT p.project_id, m.user_id, 0 as email_subscription, now() as created_date from user_group_member m INNER JOIN user_group_project p ON
            m.group_id = p.user_group_id) t group by project_id, user_id;

ALTER TABLE irida.project_user DROP COLUMN email_subscription;

ALTER TABLE irida.project_user_AUD DROP COLUMN email_subscription;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('user-account-project-subscription', 'katherine', '22.05/user-account-project-subscription.xml', NOW(), 120, '9:3d130c0e711bfebef8250be48f5859f2', 'createTable tableName=project_subscription; addUniqueConstraint constraintName=UK_PROJECT_SUBSCRIPTION_PROJECT_USER, tableName=project_subscription; createTable tableName=project_subscription_AUD; sql; dropColumn columnName=email_subscription, tab...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.05/one-project-per-template.xml::one-project-per-template::tom
ALTER TABLE irida.metadata_template ADD project_id BIGINT NULL, ADD project_default BIT(1) NULL;

ALTER TABLE irida.metadata_template ADD CONSTRAINT FK_METADATA_TEMPLATE_PROJECT FOREIGN KEY (project_id) REFERENCES irida.project (id);

UPDATE irida.metadata_template SET project_default = 0;

ALTER TABLE irida.metadata_template MODIFY project_default BIT(1) NOT NULL;

ALTER TABLE irida.metadata_template_AUD ADD project_id BIGINT NULL, ADD project_default BIT(1) NULL;

UPDATE metadata_template m INNER JOIN project_metadata_template t ON m.id=t.template_ID SET
            m.project_id=t.project_id;

UPDATE metadata_template m INNER JOIN project p ON p.default_metadata_template=m.id SET m.project_default=1;

ALTER TABLE irida.metadata_template MODIFY project_id BIGINT NOT NULL;

DROP TABLE irida.project_metadata_template;

DROP TABLE irida.project_metadata_template_AUD;

ALTER TABLE irida.project DROP FOREIGN KEY FK_PROJECT_METADATA_TEMPLATE;

ALTER TABLE irida.project DROP COLUMN default_metadata_template;

ALTER TABLE irida.project_AUD DROP COLUMN default_metadata_template;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('one-project-per-template', 'tom', '22.05/one-project-per-template.xml', NOW(), 121, '9:d89301196f2e415bd4c5e300a83494f8', 'addColumn tableName=metadata_template; addColumn tableName=metadata_template_AUD; sql; sql; addNotNullConstraint columnName=project_id, tableName=metadata_template; dropTable tableName=project_metadata_template; dropTable tableName=project_metadat...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.05/metadata-restrictions.xml::metadata-restrictions::tom
CREATE TABLE irida.metadata_restriction (id BIGINT AUTO_INCREMENT NOT NULL, project_id BIGINT NOT NULL, field_id BIGINT NOT NULL, level VARCHAR(255) NOT NULL, CONSTRAINT PK_METADATA_RESTRICTION PRIMARY KEY (id), CONSTRAINT FK_METADATA_RESTRICTION_FIELD FOREIGN KEY (field_id) REFERENCES irida.metadata_field(id), CONSTRAINT FK_METADATA_RESTRICTION_PROJECT FOREIGN KEY (project_id) REFERENCES irida.project(id));

ALTER TABLE irida.metadata_restriction ADD CONSTRAINT UK_METADATA_RESTRICTION_PROJECT_FIELD UNIQUE (project_id, field_id);

CREATE TABLE irida.metadata_restriction_AUD (id BIGINT NOT NULL, REV INT NOT NULL, REVTYPE TINYINT(4) NULL, project_id BIGINT NULL, field_id BIGINT NULL, level VARCHAR(255) NULL, CONSTRAINT PK_METADATA_RESTRICTION_AUD PRIMARY KEY (id, REV), CONSTRAINT FK_METADATA_RESTRICTION_AUD FOREIGN KEY (REV) REFERENCES irida.Revisions(id));

ALTER TABLE irida.project_user ADD metadataRole VARCHAR(255) NULL;

UPDATE irida.project_user SET metadataRole = 'LEVEL_4';

ALTER TABLE irida.project_user MODIFY metadataRole VARCHAR(255) NOT NULL;

ALTER TABLE irida.project_user_AUD ADD metadataRole VARCHAR(255) NULL;

UPDATE irida.project_user_AUD SET metadataRole = 'LEVEL_4';

ALTER TABLE irida.user_group_project ADD metadata_role VARCHAR(255) NULL;

UPDATE irida.user_group_project SET metadata_role = 'LEVEL_4';

ALTER TABLE irida.user_group_project MODIFY metadata_role VARCHAR(255) NOT NULL;

ALTER TABLE irida.user_group_project_AUD ADD metadata_role VARCHAR(255) NULL;

UPDATE irida.user_group_project_AUD SET metadata_role = 'LEVEL_4';

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('metadata-restrictions', 'tom', '22.05/metadata-restrictions.xml', NOW(), 122, '9:7a55aa25c95c0fb36d2bb518dc07efae', 'createTable tableName=metadata_restriction; addUniqueConstraint constraintName=UK_METADATA_RESTRICTION_PROJECT_FIELD, tableName=metadata_restriction; createTable tableName=metadata_restriction_AUD; addColumn tableName=project_user; addColumn table...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


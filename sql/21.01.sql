--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 21.01/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 21.01/announcements_upgrade.xml::announcement_upgrade::katherine
ALTER TABLE irida.announcement ADD title VARCHAR(255) NULL;

UPDATE irida.announcement SET title = 'Announcement title not found';

ALTER TABLE irida.announcement MODIFY title VARCHAR(255) NOT NULL;

ALTER TABLE irida.announcement ADD priority TINYINT(1) NULL;

UPDATE irida.announcement SET priority = '0';

ALTER TABLE irida.announcement MODIFY priority TINYINT(1) NOT NULL;

ALTER TABLE irida.announcement_AUD ADD title VARCHAR(255) NULL;

ALTER TABLE irida.announcement_AUD ADD priority TINYINT(1) NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('announcement_upgrade', 'katherine', '21.01/announcements_upgrade.xml', NOW(), 120, '9:e74dd10d04010d8e9c3d5b8e23279966', 'addColumn tableName=announcement; addColumn tableName=announcement; addColumn tableName=announcement_AUD; addColumn tableName=announcement_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 21.01/metadata-entry-refactor.xml::metadata-entry-refactor::tom
ALTER TABLE irida.metadata_entry ADD field_id BIGINT NULL;

ALTER TABLE irida.metadata_entry ADD CONSTRAINT FK_METADATA_ENTRY_FIELD FOREIGN KEY (field_id) REFERENCES irida.metadata_field (id);

ALTER TABLE irida.metadata_entry_AUD ADD field_id BIGINT NULL;

ALTER TABLE irida.metadata_entry ADD sample_id BIGINT NULL;

ALTER TABLE irida.metadata_entry ADD CONSTRAINT FK_METADATA_ENTRY_SAMPLE FOREIGN KEY (sample_id) REFERENCES irida.sample (id);

ALTER TABLE irida.metadata_entry_AUD ADD sample_id BIGINT NULL;

update metadata_entry e INNER JOIN sample_metadata_entry s ON e.id=s.metadata_id SET
            e.field_id=s.metadata_KEY, e.sample_id=s.sample_id;

update metadata_entry_AUD e INNER JOIN sample_metadata_entry s ON e.id=s.metadata_id SET
            e.field_id=s.metadata_KEY, e.sample_id=s.sample_id;

update metadata_entry_AUD e INNER JOIN sample_metadata_entry_AUD s ON e.id=s.metadata_id AND e.REV=s.REV SET
            e.field_id=s.metadata_KEY, e.sample_id=s.sample_id;

delete p.* from pipeline_metadata_entry p INNER JOIN metadata_entry m ON p.id=m.id WHERE m.sample_id is null;

delete from metadata_entry where sample_id is null;

ALTER TABLE irida.metadata_entry MODIFY field_id BIGINT NOT NULL;

ALTER TABLE irida.metadata_entry MODIFY sample_id BIGINT NOT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('metadata-entry-refactor', 'tom', '21.01/metadata-entry-refactor.xml', NOW(), 121, '9:c0e805103dc6b731b69ebb66480484b4', 'addColumn tableName=metadata_entry; addColumn tableName=metadata_entry_AUD; addColumn tableName=metadata_entry; addColumn tableName=metadata_entry_AUD; sql; sql; sql; sql; sql; addNotNullConstraint columnName=field_id, tableName=metadata_entry; ad...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 21.01/full-project-hash.xml::full-project-hash::tom
ALTER TABLE irida.project ADD remote_project_hash INT NULL;

ALTER TABLE irida.project_AUD ADD remote_project_hash INT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('full-project-hash', 'tom', '21.01/full-project-hash.xml', NOW(), 122, '9:aff7c870092fb9955d86e649e8856ded', 'addColumn tableName=project; addColumn tableName=project_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 21.01/analysis-submission-email-pipeline-result-on-error.xml::analysis-submission-email-pipeline-result-on-error::deep
ALTER TABLE irida.analysis_submission ADD email_pipeline_result_error BIT(1) DEFAULT 0 NULL;

UPDATE irida.analysis_submission SET email_pipeline_result_error = 0;

ALTER TABLE irida.analysis_submission MODIFY email_pipeline_result_error BIT(1) NOT NULL;

ALTER TABLE irida.analysis_submission ALTER email_pipeline_result_error SET DEFAULT 0;

ALTER TABLE irida.analysis_submission_AUD ADD email_pipeline_result_error BIT(1) NULL;

ALTER TABLE irida.analysis_submission CHANGE email_pipeline_result email_pipeline_result_completed BIT(1);

UPDATE irida.analysis_submission SET email_pipeline_result_completed = 0 WHERE email_pipeline_result_completed IS NULL;

ALTER TABLE irida.analysis_submission MODIFY email_pipeline_result_completed BIT(1) NOT NULL;

ALTER TABLE irida.analysis_submission ALTER email_pipeline_result_completed SET DEFAULT 0;

ALTER TABLE irida.analysis_submission_AUD CHANGE email_pipeline_result email_pipeline_result_completed BIT(1);

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('analysis-submission-email-pipeline-result-on-error', 'deep', '21.01/analysis-submission-email-pipeline-result-on-error.xml', NOW(), 123, '9:7768e86f13b127365e5ea89bbfe0078f', 'addColumn tableName=analysis_submission; addColumn tableName=analysis_submission_AUD; renameColumn newColumnName=email_pipeline_result_completed, oldColumnName=email_pipeline_result, tableName=analysis_submission; addNotNullConstraint columnName=e...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 21.01/remove-sample-metadata-entry.xml::remove-sample-metadata-entry::tom
DROP TABLE irida.sample_metadata_entry;

DROP TABLE irida.sample_metadata_entry_AUD;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('remove-sample-metadata-entry', 'tom', '21.01/remove-sample-metadata-entry.xml', NOW(), 124, '9:968a670d17d46e86f83075447b89675b', 'dropTable tableName=sample_metadata_entry; dropTable tableName=sample_metadata_entry_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


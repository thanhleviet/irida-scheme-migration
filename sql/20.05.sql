--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 20.05/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 20.05/add-generic-sequencing-runs.xml::add-generic-sequencing-runs::tom
ALTER TABLE irida.sequencing_run ADD sequencer_type VARCHAR(255) NOT NULL;

ALTER TABLE irida.sequencing_run_AUD ADD sequencer_type VARCHAR(255) NULL;

UPDATE sequencing_run SET sequencer_type="miseq";

UPDATE sequencing_run_AUD SET sequencer_type="miseq";

CREATE TABLE irida.sequencing_run_properties (sequencing_run_id BIGINT NOT NULL, property_value VARCHAR(255) NOT NULL, property_key VARCHAR(255) NOT NULL, CONSTRAINT PK_SEQUENCING_RUN_PROPERTIES PRIMARY KEY (sequencing_run_id, property_key), CONSTRAINT FK_SEQUENCING_RUN_PROPERTIES FOREIGN KEY (sequencing_run_id) REFERENCES irida.sequencing_run(id));

CREATE TABLE irida.sequencing_run_properties_AUD (sequencing_run_id BIGINT NOT NULL, property_value VARCHAR(255) NOT NULL, property_key VARCHAR(255) NOT NULL, REV INT NOT NULL, REVTYPE TINYINT(4) NULL, CONSTRAINT PK_SEQUENCING_RUN_PROPERTIES_AUD PRIMARY KEY (sequencing_run_id, property_value, property_key, REV), CONSTRAINT FK_SEQUENCING_RUN_PROPERTY_AUD FOREIGN KEY (REV) REFERENCES irida.Revisions(id));

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'application', application FROM miseq_run WHERE application != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id, 'assay',
            assay FROM miseq_run WHERE assay != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'chemistry', chemistry FROM miseq_run WHERE chemistry != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'experimentName', experimentName FROM miseq_run WHERE experimentName != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'investigatorName', investigatorName FROM miseq_run WHERE investigatorName != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'projectName', projectName FROM miseq_run WHERE projectName != null;

INSERT INTO sequencing_run_properties (sequencing_run_id, property_key, property_value) SELECT id,
            'readLengths', read_lengths FROM miseq_run WHERE read_lengths != null;

DROP TABLE irida.miseq_run_AUD;

DROP TABLE irida.miseq_run;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('add-generic-sequencing-runs', 'tom', '20.05/add-generic-sequencing-runs.xml', NOW(), 120, '9:ead6640a2a1a023b5c91e673313ecefe', 'addColumn tableName=sequencing_run; addColumn tableName=sequencing_run_AUD; sql; sql; createTable tableName=sequencing_run_properties; createTable tableName=sequencing_run_properties_AUD; sql; sql; sql; sql; sql; sql; sql; dropTable tableName=mise...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 20.05/uploaded-assemblies.xml::uploaded-assemblies::tom
CREATE TABLE irida.genome_assembly_AUD (id BIGINT NOT NULL, created_date datetime NULL, REV INT NOT NULL, REVTYPE TINYINT NULL, CONSTRAINT PK_GENOME_ASSEMBLY_AUD PRIMARY KEY (id, REV), CONSTRAINT FK_GENOME_ASSEMBLY_AUD FOREIGN KEY (REV) REFERENCES irida.Revisions(id));

CREATE TABLE irida.genome_assembly_analysis_AUD (id BIGINT NOT NULL, analysis_submission_id BIGINT NULL, REV INT NOT NULL, REVTYPE TINYINT NULL, CONSTRAINT PK_GENOME_ASSEMBLY_ANALYSIS_AUD PRIMARY KEY (id, REV), CONSTRAINT FK_GENOME_ASSEMBLY_ANALYSIS_AUD FOREIGN KEY (REV) REFERENCES irida.Revisions(id));

ALTER TABLE irida.genome_assembly_analysis_AUD ADD CONSTRAINT FK_ASSEMBLY_ANALYSIS_AUD FOREIGN KEY (id, REV) REFERENCES irida.genome_assembly_AUD (id, REV);

CREATE TABLE irida.uploaded_assembly (id BIGINT NOT NULL, file_path VARCHAR(255) NOT NULL, file_revision_number BIGINT NULL, CONSTRAINT PK_UPLOADED_ASSEMBLY PRIMARY KEY (id), CONSTRAINT FK_UPLOADED_GENOME_ASSEMBLY FOREIGN KEY (id) REFERENCES irida.genome_assembly(id), CONSTRAINT UK_UPLOADED_ASSEMBLY_FILE_PATH UNIQUE (file_path));

CREATE TABLE irida.uploaded_assembly_AUD (id BIGINT NOT NULL, file_path VARCHAR(255) NULL, file_revision_number BIGINT NULL, REV INT NOT NULL, REVTYPE TINYINT NULL, CONSTRAINT PK_UPLOADED_ASSEMBLY_AUD PRIMARY KEY (id, REV));

ALTER TABLE irida.uploaded_assembly_AUD ADD CONSTRAINT FK_UPLOADED_ASSEMBLY_AUD FOREIGN KEY (id, REV) REFERENCES irida.genome_assembly_AUD (id, REV);

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('uploaded-assemblies', 'tom', '20.05/uploaded-assemblies.xml', NOW(), 121, '9:15d1dd5dbe94ab0c6431dece230024b9', 'createTable tableName=genome_assembly_AUD; createTable tableName=genome_assembly_analysis_AUD; addForeignKeyConstraint baseTableName=genome_assembly_analysis_AUD, constraintName=FK_ASSEMBLY_ANALYSIS_AUD, referencedTableName=genome_assembly_AUD; cr...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 20.05/fast5-file-model.xml::fast5-file-model::tom
CREATE TABLE irida.sequence_file_fast5 (id BIGINT NOT NULL, fast5_type VARCHAR(255) NOT NULL, file_id BIGINT NOT NULL, CONSTRAINT PK_SEQUENCE_FILE_FAST5 PRIMARY KEY (id), CONSTRAINT FK_SEQUENCE_FILE_FAST5_OBJECT FOREIGN KEY (id) REFERENCES irida.sequencing_object(id), CONSTRAINT FK_SEQUENCE_FILE_FAST5_FILE FOREIGN KEY (file_id) REFERENCES irida.sequence_file(id));

CREATE TABLE irida.sequence_file_fast5_AUD (id BIGINT NOT NULL, fast5_type VARCHAR(255) NULL, file_id BIGINT NULL, REV INT NOT NULL, CONSTRAINT PK_SEQUENCE_FILE_FAST5_AUD PRIMARY KEY (id, REV));

ALTER TABLE irida.sequence_file_fast5_AUD ADD CONSTRAINT FK_SEQUENCE_FILE_FAST5_AUD FOREIGN KEY (id, REV) REFERENCES irida.sequencing_object_AUD (id, REV);

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('fast5-file-model', 'tom', '20.05/fast5-file-model.xml', NOW(), 122, '9:43532c1202b1ac3d6b6d5df03b792a84', 'createTable tableName=sequence_file_fast5; createTable tableName=sequence_file_fast5_AUD; addForeignKeyConstraint baseTableName=sequence_file_fast5_AUD, constraintName=FK_SEQUENCE_FILE_FAST5_AUD, referencedTableName=sequencing_object_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


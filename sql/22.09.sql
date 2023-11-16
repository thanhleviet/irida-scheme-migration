--  Lock Database
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'v1260 (172.16.12.25)', LOCKGRANTED = NOW() WHERE ID = 1 AND `LOCKED` = 0;

--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: 22.09/all-changes.xml
--  Ran at: 10/11/23, 10:47 PM
--  Against: irida2023@127.0.0.1@jdbc:mysql://localhost:3306/irida
--  Liquibase version: 4.24.0
--  *********************************************************************

--  Changeset 22.09/user-account-drop-phone-constraint.xml::user-account-drop-phone-constraint::katherine
ALTER TABLE irida.user MODIFY phoneNumber VARCHAR(255) NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('user-account-drop-phone-constraint', 'katherine', '22.09/user-account-drop-phone-constraint.xml', NOW(), 120, '9:ef6305f36379d3ccad069cfb2c00a702', 'dropNotNullConstraint columnName=phoneNumber, tableName=user', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/oauth2-authorization-tables.xml::oauth2-authorization-tables::eric
CREATE TABLE irida.oauth2_authorization (id VARCHAR(100) NOT NULL, registered_client_id VARCHAR(100) NOT NULL, principal_name VARCHAR(200) NOT NULL, authorization_grant_type VARCHAR(100) NOT NULL, attributes VARCHAR(4000) NULL, state VARCHAR(500) NULL, authorization_code_value BLOB NULL, authorization_code_issued_at timestamp NULL, authorization_code_expires_at timestamp NULL, authorization_code_metadata VARCHAR(2000) NULL, access_token_value BLOB NULL, access_token_issued_at timestamp NULL, access_token_expires_at timestamp NULL, access_token_metadata VARCHAR(2000) NULL, access_token_type VARCHAR(100) NULL, access_token_scopes VARCHAR(1000) NULL, oidc_id_token_value BLOB NULL, oidc_id_token_issued_at timestamp NULL, oidc_id_token_expires_at timestamp NULL, oidc_id_token_metadata VARCHAR(2000) NULL, refresh_token_value BLOB NULL, refresh_token_issued_at timestamp NULL, refresh_token_expires_at timestamp NULL, refresh_token_metadata VARCHAR(2000) NULL, CONSTRAINT PK_OAUTH2_AUTHORIZATION PRIMARY KEY (id));

CREATE TABLE irida.oauth2_authorization_consent (registered_client_id VARCHAR(100) NOT NULL, principal_name VARCHAR(200) NOT NULL, authorities VARCHAR(1000) NULL, CONSTRAINT PK_OAUTH2_AUTHORIZATION_CONSENT PRIMARY KEY (registered_client_id, principal_name));

DROP TABLE irida.oauth_access_token;

DROP TABLE irida.oauth_refresh_token;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('oauth2-authorization-tables', 'eric', '22.09/oauth2-authorization-tables.xml', NOW(), 121, '9:d4b7602dc61d159861fecee817af372d', 'createTable tableName=oauth2_authorization; createTable tableName=oauth2_authorization_consent; dropTable tableName=oauth_access_token; dropTable tableName=oauth_refresh_token', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/update-remote-api-token-token-types.xml::update-remote-api-token-token-types::eric
ALTER TABLE irida.remote_api_token MODIFY tokenString TEXT;

ALTER TABLE irida.remote_api_token_AUD MODIFY tokenString TEXT;

ALTER TABLE irida.remote_api_token MODIFY refresh_token TEXT;

ALTER TABLE irida.remote_api_token_AUD MODIFY refresh_token TEXT;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('update-remote-api-token-token-types', 'eric', '22.09/update-remote-api-token-token-types.xml', NOW(), 122, '9:812359513b29913d9a0f4f8b9c6887fb', 'modifyDataType columnName=tokenString, tableName=remote_api_token; modifyDataType columnName=tokenString, tableName=remote_api_token_AUD; modifyDataType columnName=refresh_token, tableName=remote_api_token; modifyDataType columnName=refresh_token,...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/refactor-client-details.xml::refactor-client-details::eric
DROP TABLE irida.client_details_additional_information;

DROP TABLE irida.client_details_additional_information_AUD;

DROP TABLE irida.client_details_authorities;

DROP TABLE irida.client_details_authorities_AUD;

DROP TABLE irida.client_details_auto_approvable_scope;

DROP TABLE irida.client_details_auto_approvable_scope_AUD;

DROP TABLE irida.client_details_resource_ids;

DROP TABLE irida.client_details_resource_ids_AUD;

DROP TABLE irida.client_role;

DROP TABLE irida.client_role_AUD;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('refactor-client-details', 'eric', '22.09/refactor-client-details.xml', NOW(), 123, '9:fb0d1a1cee68eab76a8d6e82d74dd368', 'dropTable tableName=client_details_additional_information; dropTable tableName=client_details_additional_information_AUD; dropTable tableName=client_details_authorities; dropTable tableName=client_details_authorities_AUD; dropTable tableName=clien...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/add-default-sequencing-object-to-sample.xml::add-default-sequencing-object-to-sample::deep
ALTER TABLE irida.sample ADD default_sequencing_object BIGINT NULL;

ALTER TABLE irida.sample ADD CONSTRAINT FK_SAMPLE_SEQUENCING_OBJECT FOREIGN KEY (default_sequencing_object) REFERENCES irida.sequencing_object (id);

ALTER TABLE irida.sample_AUD ADD default_sequencing_object BIGINT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('add-default-sequencing-object-to-sample', 'deep', '22.09/add-default-sequencing-object-to-sample.xml', NOW(), 124, '9:524224b8cdbd9c6f1d2361f46274f08d', 'addColumn tableName=sample; addColumn tableName=sample_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/add-default-genome-assembly-to-sample.xml::add-default-genome-assembly-to-sample::deep
ALTER TABLE irida.sample ADD default_genome_assembly BIGINT NULL;

ALTER TABLE irida.sample ADD CONSTRAINT FK_SAMPLE_GENOME_ASSEMBLY FOREIGN KEY (default_genome_assembly) REFERENCES irida.genome_assembly (id);

ALTER TABLE irida.sample_AUD ADD default_genome_assembly BIGINT NULL;

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('add-default-genome-assembly-to-sample', 'deep', '22.09/add-default-genome-assembly-to-sample.xml', NOW(), 125, '9:fd5f0ef50cc87d91a07e2646b55150b9', 'addColumn tableName=sample; addColumn tableName=sample_AUD', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Changeset 22.09/rename-ncbi-export-instruments.xml::rename-ncbi-export-instruments::josh
UPDATE irida.ncbi_export_biosample SET instrument_model = 'HELICOS_HELISCOPE' WHERE instrument_model='HELICOSHELISCOPE';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_MI_SEQ' WHERE instrument_model='ILLUMINAMISEQ';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'NEXT_SEQ_500' WHERE instrument_model='ILLUMINANEXTSEQ500';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'NEXT_SEQ_550' WHERE instrument_model='ILLUMINANEXTSEQ550';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_GENOME_ANALYZER_II' WHERE instrument_model='ILLUMINAGAII';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_GENOME_ANALYZER_IIX' WHERE instrument_model='ILLUMINAGAIIX';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_GENOME_ANALYZER' WHERE instrument_model='ILLUMINAGA';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_1000' WHERE instrument_model='ILLUMINAHISEQ1000';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_1500' WHERE instrument_model='ILLUMINAHISEQ1500';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_2000' WHERE instrument_model='ILLUMINAHISEQ2000';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_2500' WHERE instrument_model='ILLUMINAHISEQ2500';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_3000' WHERE instrument_model='ILLUMINAHISEQ3000';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ILLUMINA_HI_SEQ_4000' WHERE instrument_model='ILLUMINAHISEQ4000';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ION_TORRENT_PGM' WHERE instrument_model='IONTORRENTPGM';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'ION_TORRENT_PROTON' WHERE instrument_model='IONTORRENTPROTON';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'LS_454_GS_20' WHERE instrument_model='ROCHE454GS20';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'LS_454_GS_FLX' WHERE instrument_model='ROCHE454GSFLX';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'LS_454_GS_FLX_TITANIUM' WHERE instrument_model='ROCHE454GSFLXTI';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'LS_454_GS' WHERE instrument_model='ROCHE454GS';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'LS_454_GS_JUNIOR' WHERE instrument_model='ROCHE454GSJR';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'PAC_BIO_RS' WHERE instrument_model='PACBIORS';

UPDATE irida.ncbi_export_biosample SET instrument_model = 'PAC_BIO_RS_II' WHERE instrument_model='PACBIORSII';

INSERT INTO irida.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, `DESCRIPTION`, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('rename-ncbi-export-instruments', 'josh', '22.09/rename-ncbi-export-instruments.xml', NOW(), 126, '9:80123a43ed7997ef0e7218a9cd4e1053', 'update tableName=ncbi_export_biosample; update tableName=ncbi_export_biosample; update tableName=ncbi_export_biosample; update tableName=ncbi_export_biosample; update tableName=ncbi_export_biosample; update tableName=ncbi_export_biosample; update ...', '', 'EXECUTED', NULL, NULL, '4.24.0', NULL);

--  Release Database Lock
UPDATE irida.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;


module "rgAdf" {
  source              = ".//modules/resource-group"
  resource_group_name = "${var.data_factory_name}-${var.environment}-${var.primary_location}-${var.resource_group_name_adf}"
  location            = var.primary_location
  tags                = merge(var.sub_tags, { environment = var.environment }, )

}
resource "azurerm_data_factory" "utr-osd-datafactory" {
  name                            = "${var.data_factory_name}-${var.environment}-${var.primary_location}"
  location                        = module.rgAdf.location
  resource_group_name             = module.rgAdf.resource_group_name
  managed_virtual_network_enabled = true
  tags                            = merge(var.sub_tags, { environment = var.environment }, )

}

resource "azurerm_data_factory_managed_private_endpoint" "adfBlobPE" {
  name               = "${var.environment}_adf_blob_pe_001"
  data_factory_id    = azurerm_data_factory.utr-osd-datafactory.id
  target_resource_id = module.primary_storage_account_001.id
  subresource_name   = "blob"
}

resource "azurerm_data_factory_managed_private_endpoint" "adfKeyVaultPE" {
  name               = "${var.environment}_adf_kv_pe_001"
  data_factory_id    = azurerm_data_factory.utr-osd-datafactory.id
  target_resource_id = module.primary_key_vault.key-vault-id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_managed_private_endpoint" "adfPrimarySqlPE" {
  name               = "${var.environment}_adf_primarySql_pe_001"
  data_factory_id    = azurerm_data_factory.utr-osd-datafactory.id
  target_resource_id = azurerm_mssql_server.primary_sqldb_server.id
  subresource_name   = "sqlServer"
}


########### Creating integration runtime self hosted #########

resource "azurerm_data_factory_integration_runtime_self_hosted" "shir-onprem-connection" {
  name            = "${var.environment}_shir_onprem_connection"
  data_factory_id = azurerm_data_factory.utr-osd-datafactory.id
}


######### Creating KEY VAULT linked service  ##########

resource "azurerm_data_factory_linked_service_key_vault" "adfKvLs" {
  name            = "${var.data_factory_name}-${var.environment}-${var.primary_location}_dflskv"
  data_factory_id = azurerm_data_factory.utr-osd-datafactory.id
  key_vault_id    = module.primary_key_vault.key-vault-id
}


#storage linked service

# resource "azurerm_data_factory_linked_custom_service" "stglink" {
#   name                 = "${var.data_factory_name}-${var.environment}-storagelinkservice"
#   data_factory_id      = azurerm_data_factory.utr-osd-datafactory.id
#   type                 = "AzureBlobStorage"
#   type_properties_json = <<JSON
# {
#   "connectionString": "${module.primary_storage_account_001.primary_connection_string}"

# }
# JSON   
# }


#link service for blob storage
resource "azurerm_data_factory_linked_service_azure_blob_storage" "blobstoragelink" {
  name              = "${var.data_factory_name}-${var.environment}-link_blob"
  data_factory_id   = azurerm_data_factory.utr-osd-datafactory.id
  connection_string = data.module.primary_storage_account_001.primary_connection_string
}

#link service for sql server database
resource "azurerm_data_factory_linked_service_sql_server" "sqldatabaselink" {
  name            = "${var.data_factory_name}-${var.environment}-link_sql"
  data_factory_id = azurerm_data_factory.utr-osd-datafactory.id
  key_vault_connection_string {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.adfKvLs.name
    secret_name         = keys(var.kv-primary-secrets)[1]
  }
}


#########  link service for filesystem   ########

resource "azurerm_data_factory_linked_custom_service" "linkedservice_onprem" {
  name                 = "${var.data_factory_name}-${var.environment}-link_onprem"
  data_factory_id      = azurerm_data_factory.utr-osd-datafactory.id
  type                 = "FileServer"
  description          = "linked service onprem filestorage"
  type_properties_json = <<JSON
    {
            "host": "D:\\New folder",
            "userId": "pmmr\\jsachdeva",
            "encryptedCredential": "eyJDcmVkZW50aWFsSWQiOiJjNjczZmY2ZS1kYzgwLTQ3ODYtODBkNS05MTU4ZjA3Yzc3MWIiLCJWZXJzaW9uIjoiMi4wIiwiQ2xhc3NUeXBlIjoiTWljcm9zb2Z0LkRhdGFQcm94eS5Db3JlLkludGVyU2VydmljZURhdGFDb250cmFjdC5DcmVkZW50aWFsU1UwNkNZMTQifQ=="
        }

    JSON
}


resource "azurerm_data_factory_linked_service_azure_file_storage" "filestoragelink" {
  name              = "${var.data_factory_name}-${var.environment}-link_file_storage"
  data_factory_id   = azurerm_data_factory.utr-osd-datafactory.id
  connection_string = data.primary_storage_account_001.primary_connection_string
}

###location pipeline script for utr-osd

resource "azurerm_data_factory_dataset_azure_blob" "blobmemberdetilas" {
  name                = "${var.data_factory_name}${var.environment}_blob_memberdetails_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blobstoragelink.name

  path     = "member-details"
  filename = "samplefile.xlsx.txt"
}

resource "azurerm_data_factory_dataset_delimited_text" "onpremmemberdetailsdata" {
  name                = "${var.data_factory_name}${var.environment}_onperm_memberdetails_dataset"
  data_factory_id     = azurerm_data_factory.adf-tripspark.id
  linked_service_name = azurerm_data_factory_linked_custom_service.linkedservice_onprem.name
  parameters = {
    FileName = "DeIdentifiedFiles"
  }
  azure_blob_fs_location {
    file_system = ""
    path        = ""
    filename    = "Dataset_Blob_files"
  }
  column_delimiter = ","
  # row_delimiter       = "\n"
  quote_character     = "\""
  escape_character    = "\\"
  first_row_as_header = true
}


resource "azurerm_data_factory_dataset_sql_server_table" "sqlallmemberdetails" {
  name                = "${var.data_factory_name}${var.environment}_sql_allmemberdetails_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.AllMemberDetails"
}

resource "azurerm_data_factory_dataset_sql_server_table" "sqlaudits" {
  name                = "${var.data_factory_name}${var.environment}_sql_audits_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.Audits"
}


resource "azurerm_data_factory_dataset_sql_server_table" "sqlmemberaddress" {
  name                = "${var.data_factory_name}${var.environment}_sql_member_address_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.MemberAddress"
}


resource "azurerm_data_factory_dataset_sql_server_table" "sqlmemberemail" {
  name                = "${var.data_factory_name}${var.environment}_sql_member_email_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.MemberEmail"
}


resource "azurerm_data_factory_dataset_sql_server_table" "sqlmemberphone" {
  name                = "${var.data_factory_name}${var.environment}_sql_member_phone_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.MemberPhone"
}

resource "azurerm_data_factory_dataset_sql_server_table" "sqlmemberprofile" {
  name                = "${var.data_factory_name}${var.environment}_sql_member_profile_dataset"
  data_factory_id     = azurerm_data_factory.utr-osd-datafactory.id
  linked_service_name = azurerm_data_factory_linked_service_sql_server.sqldatabaselink.name
  table_name          = "dbo.MemberProfile"
}



# #Creating Datasets
# resource "azurerm_data_factory_dataset_delimited_text" "locationcsvblob" {
#   name                = "${var.data_factory_name}${var.environment}location_csvCopyToBlobDS"
#   # resource_group_name = module.rgAdf.resource_group_name
#   data_factory_id   = azurerm_data_factory.utr-osd-datafactory.id
#   linked_service_name = azurerm_data_factory_linked_custom_service.stglink.name


resource "azurerm_data_factory_trigger_blob_event" "locationtrigger" {

  name               = "${var.data_factory_name}${var.environment}stgeventlocationtrigger"
  data_factory_id    = azurerm_data_factory.utr-osd-datafactory.id
  storage_account_id = module.primary_storage_account_001.id

  events = ["Microsoft.Storage.BlobCreated"]

  blob_path_ends_with = "USMD Location List.xlsx"
  ignore_empty_blobs  = true
  activated           = true


  pipeline {
    name = azurerm_data_factory_pipeline.pipelinelocation.name

  }
}

######## scrip for data flow ########

resource "azurerm_data_factory_data_flow" "locationFlow" {
  name            = "${var.data_factory_name}${var.environment}dataflowlocationtable"
  data_factory_id = azurerm_data_factory.utr-osd-datafactory.id

  source {
    name = "source1"

    dataset {
      name = azurerm_data_factory_dataset_sql_server_table.sqlmemberaddress.name
    }
  }

  source {
    name = "source2"

    dataset {
      name = azurerm_data_factory_dataset_sql_server_table.sqlallmemberdetails.name
    }
  }

  sink {
    name = "sink1"

    dataset {
      name = azurerm_data_factory_dataset_sql_server_table.sqlmemberaddress.name
    }
  }

  transformation {
    name = "join2"
  }

  transformation {
    name = "filter1"
  }

  transformation {
    name = "derivedColumn2"
  }


  script = <<EOT
source(output(
		AddressId as integer,
		GMPI as integer,
		CreatedBy as string,
		Address1 as string,
		Address2 as string,
		City as string,
		State as string,
		Zip as string,
		AddressBadFlag as boolean,
		CreatedTime as timestamp,
		UpdatedTime as timestamp,
		UpdatedBy as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	isolationLevel: 'READ_UNCOMMITTED',
	format: 'table') ~> srcSQLAddress
source(output(
		GMPI as integer,
		Gender as string,
		Source as string,
		Region as string,
		Market as string,
		{Clinic Group} as string,
		Clinic as string,
		{PCP Name} as string,
		{PCP WellMed Owned} as string,
		{First Name} as string,
		{Last Name} as string,
		DOB as timestamp,
		GAPS as integer,
		{Do Not Call} as string,
		{Do Not Visit} as string,
		{Do Not Contact} as string,
		EmailAddress as string,
		EmailBadFlag as string,
		EmailType as string,
		PhoneNumber as string,
		PhoneType as string,
		VerbalAgreementtotext as string,
		PhoneBadFlag as string,
		AttemptNotes as string,
		AttemptDate as timestamp,
		Address1 as string,
		Address2 as string,
		City as string,
		State as string,
		Zip as string,
		AddressBadFlag as string,
		rowno as long
	),
	allowSchemaDrift: true,
	validateSchema: false,
	isolationLevel: 'READ_UNCOMMITTED',
	query: 'select * from\n(\nselect *\n, ROW_NUMBER() OVER(PARTITION BY GMPI, address1, address2 ORDER BY GMPI) AS rowno\nfrom [dbo].[AllMemberDetails]\n) as uniqueGMPI\nwhere rowno = 1 and address1 is not null',
	format: 'query') ~> SrcSQLAllInput
srcSQLAddress, SrcSQLAllInput join(srcSQLAddress@GMPI == SrcSQLAllInput@GMPI
	&& srcSQLAddress@Address1 == SrcSQLAllInput@Address1
	&& srcSQLAddress@Address2 == SrcSQLAllInput@Address2,
	joinType:'right',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> join2
join2 filter(isNull(srcSQLAddress@Address1)) ~> filter1
filter1 derive(CreatedBy = Source,
		CreatedTime = currentUTC(),
		UpdatedBy = 'ADF Data Import',
		UpdatedTime = currentUTC()) ~> derivedColumn2
derivedColumn2 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		AddressId as integer,
		GMPI as integer,
		CreatedBy as string,
		Address1 as string,
		Address2 as string,
		City as string,
		State as string,
		Zip as string,
		AddressBadFlag as boolean,
		CreatedTime as timestamp,
		UpdatedTime as timestamp,
		UpdatedBy as string
	),
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 1,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		GMPI = SrcSQLAllInput@GMPI,
		CreatedBy,
		Address1 = SrcSQLAllInput@Address1,
		Address2 = SrcSQLAllInput@Address2,
		City = SrcSQLAllInput@City,
		State = SrcSQLAllInput@State,
		Zip = SrcSQLAllInput@Zip,
		AddressBadFlag = SrcSQLAllInput@AddressBadFlag,
		CreatedTime,
		UpdatedTime,
		UpdatedBy
	)) ~> sink1
EOT
}


#pipeline for location table

resource "azurerm_data_factory_pipeline" "pipelinelocation" {
  name            = "${var.data_factory_name}${var.environment}_location_pl"
  data_factory_id = azurerm_data_factory.utr-osd-datafactory.id



  activities_json = <<JSON
[
  {
    "name": "pipeline1",
    "properties": {
        "activities": [
            {
                "name": "Copy_Blob_SQL",
                "type": "Copy",
                "dependsOn": [
                    {
                        "activity": "Dataflow_Address",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "7.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "source": {
                        "type": "DelimitedTextSource",
                        "storeSettings": {
                            "type": "AzureBlobStorageReadSettings",
                            "recursive": false,
                            "wildcardFileName": "*.txt",
                            "enablePartitionDiscovery": false
                        },
                        "formatSettings": {
                            "type": "DelimitedTextReadSettings"
                        }
                    },
                    "sink": {
                        "type": "AzureSqlSink",
                        "preCopyScript": "TRUNCATE TABLE dbo.AllMemberDetails",
                        "writeBehavior": "insert",
                        "sqlWriterUseTableLock": false,
                        "disableMetricsCollection": false
                    },
                    "enableStaging": false,
                    "translator": {
                        "type": "TabularTranslator",
                        "mappings": [
                            {
                                "source": {
                                    "name": "GMPI",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "GMPI",
                                    "type": "Int32",
                                    "physicalType": "int"
                                }
                            },
                            {
                                "source": {
                                    "name": "Gender",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Gender",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Source",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Source",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Region",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Region",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Market",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Market",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Clinic Group",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Clinic Group",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Clinic",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Clinic",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "PCP Name",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "PCP Name",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "PCP WellMed Owned",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "PCP WellMed Owned",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "First Name",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "First Name",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Last Name",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Last Name",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "DOB",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "DOB",
                                    "type": "DateTime",
                                    "physicalType": "datetime"
                                }
                            },
                            {
                                "source": {
                                    "name": "GAPS",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "GAPS",
                                    "type": "Int32",
                                    "physicalType": "int"
                                }
                            },
                            {
                                "source": {
                                    "name": "Do Not Call",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Do Not Call",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Do Not Visit",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Do Not Visit",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Do Not Contact",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Do Not Contact",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "EmailAddress",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "EmailAddress",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "EmailBadFlag",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "EmailBadFlag",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "EmailType",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "EmailType",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "PhoneNumber",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "PhoneNumber",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "PhoneType",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "PhoneType",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "VerbalAgreementtotext",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "VerbalAgreementtotext",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "PhoneBadFlag",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "PhoneBadFlag",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "AttemptNotes",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "AttemptNotes",
                                    "type": "String",
                                    "physicalType": "varchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "AttemptDate",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "AttemptDate",
                                    "type": "DateTime",
                                    "physicalType": "datetime"
                                }
                            },
                            {
                                "source": {
                                    "name": "Address1",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Address1",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Address2",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Address2",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "City",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "City",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "State",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "State",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "Zip",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "Zip",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            },
                            {
                                "source": {
                                    "name": "AddressBadFlag",
                                    "type": "String",
                                    "physicalType": "String"
                                },
                                "sink": {
                                    "name": "AddressBadFlag",
                                    "type": "String",
                                    "physicalType": "nvarchar"
                                }
                            }
                        ],
                        "typeConversion": true,
                        "typeConversionSettings": {
                            "allowDataTruncation": true,
                            "treatBooleanAsNumber": false
                        }
                    }
                },
                "inputs": [
                    {
                        "referenceName": "Dataset_Blob_files",
                        "type": "DatasetReference"
                    }
                ],
                "outputs": [
                    {
                        "referenceName": "Dataset_SQL_AllMemberDetails",
                        "type": "DatasetReference"
                    }
                ]
            },
            {
                "name": "Dataflow_MemberDetails",
                "type": "ExecuteDataFlow",
                "dependsOn": [
                    {
                        "activity": "Dataflow_Email",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    },
                    {
                        "activity": "Dataflow_Phone",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "1.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "dataflow": {
                        "referenceName": "dataflow1_MemberDetails",
                        "type": "DataFlowReference"
                    },
                    "compute": {
                        "coreCount": 8,
                        "computeType": "General"
                    },
                    "traceLevel": "Fine"
                }
            },
            {
                "name": "Dataflow_Email",
                "type": "ExecuteDataFlow",
                "dependsOn": [
                    {
                        "activity": "Copy_OnPrem_Blob",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "1.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "dataflow": {
                        "referenceName": "dataflow1_Email",
                        "type": "DataFlowReference"
                    },
                    "compute": {
                        "coreCount": 8,
                        "computeType": "General"
                    },
                    "traceLevel": "Fine"
                }
            },
            {
                "name": "Dataflow_Phone",
                "type": "ExecuteDataFlow",
                "dependsOn": [
                    {
                        "activity": "Copy_OnPrem_Blob",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "1.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "dataflow": {
                        "referenceName": "dataflow1_Phone",
                        "type": "DataFlowReference"
                    },
                    "compute": {
                        "coreCount": 8,
                        "computeType": "General"
                    },
                    "traceLevel": "Fine"
                }
            },
            {
                "name": "Copy_OnPrem_Blob",
                "type": "Copy",
                "dependsOn": [
                    {
                        "activity": "Copy_Blob_SQL",
                        "dependencyConditions": [
                            "Succeeded"
                        ]
                    }
                ],
                "policy": {
                    "timeout": "7.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "source": {
                        "type": "ExcelSource",
                        "storeSettings": {
                            "type": "FileServerReadSettings",
                            "recursive": false,
                            "enablePartitionDiscovery": false
                        }
                    },
                    "sink": {
                        "type": "DelimitedTextSink",
                        "storeSettings": {
                            "type": "AzureBlobStorageWriteSettings"
                        },
                        "formatSettings": {
                            "type": "DelimitedTextWriteSettings",
                            "quoteAllText": true,
                            "fileExtension": ".txt"
                        }
                    },
                    "enableStaging": false,
                    "translator": {
                        "type": "TabularTranslator",
                        "typeConversion": true,
                        "typeConversionSettings": {
                            "allowDataTruncation": true,
                            "treatBooleanAsNumber": false
                        }
                    }
                },
                "inputs": [
                    {
                        "referenceName": "Dataset_Onprem_Excel",
                        "type": "DatasetReference"
                    }
                ],
                "outputs": [
                    {
                        "referenceName": "Dataset_Blob_files",
                        "type": "DatasetReference"
                    }
                ]
            },
            {
                "name": "Dataflow_Address",
                "type": "ExecuteDataFlow",
                "dependsOn": [],
                "policy": {
                    "timeout": "1.00:00:00",
                    "retry": 0,
                    "retryIntervalInSeconds": 30,
                    "secureOutput": false,
                    "secureInput": false
                },
                "userProperties": [],
                "typeProperties": {
                    "dataflow": {
                        "referenceName": "dataflow1_Address",
                        "type": "DataFlowReference"
                    },
                    "compute": {
                        "coreCount": 8,
                        "computeType": "General"
                    },
                    "traceLevel": "Fine"
                }
            }
        ],
        "annotations": [],
        "lastPublishTime": "2022-07-05T17:41:54Z"
    },
    "type": "Microsoft.DataFactory/factories/pipelines"
}
    ]
JSON
}








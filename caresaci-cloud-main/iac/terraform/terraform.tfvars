resource_group_name_primary = "001"
tableName = ""

pipelineId="TableSchema"

tableList=["asdasd", "asda"]
primary_location = "centralus"

virtual_network_name = "app-vnet"

app_primary_storage_account = "storage"

webapp_subnet_name = "webapp-subnet"

webapi_subnet_name = "webapi-subnet"

webapp_nsg_name = "webapp-nsg"

webapi_nsg_name = "webapi-nsg"

# environment = " "
sub_tags={
ASKID = "AIDE_0074943",
project="WELLMED UTR ONESOURCE"
owner="STEPHANIE WEBB"
terraform="TRUE"}

resource_group_name_frontdoor = "fd"

frontdoor_location = "centralus"


#ADF Region 
#SECRETS


secret_adf_onprem_sql_name = "secret-utr-osd-adf-onpremsql"

secret_adf_az_sql_name = "secret-utr-osd-sql"

shir_name = "utr-osd-shir"

azir_name = "utr-osd-azir"
kv-key-permissions-full=["Get","List"]
kv-secret-permissions-full=[ "Get",    
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge"]
kv-certificate-permissions-full=["get",
    "list"]
kv-storage-permissions-full=["get",
    "list"]
azure-tenant-id=""

kv-full-object-id =""
#kv-read-object-id =""
kv-primary-secrets = {
    primarydbspwd = {
      value = "" # setting to "" will auto-generate the password
    },
    secret-utr-osd-sqldatabaselink = {
      value = "" # setting to "" will auto-generate the password
    },
   
  }

kv-secondary-secrets = {
    secondarydbspwd = {
      value = "" # setting to "" will auto-generate the password
    }
  }

resource_group_name_adf = "adf"
front_door_name = "dev-wellmed-utr-onesource"
domain_name =".optum.com"
 
#for multiregion start

resource_group_name_secondary = "002"
secondary_location = "eastus2"
service_endpoints=["Microsoft.Web"]

data_factory_name="df-utr-osd"
resource_group_name="rg_utr_osd"
pro="utr-osd"
pro1="utr_osd"
pro2="utrosd"

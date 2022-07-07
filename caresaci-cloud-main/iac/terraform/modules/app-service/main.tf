resource "azurerm_app_service" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
     tags=var.tags
  #  min_tls_version="1.2"
  https_only          = true
  dynamic "site_config" {
    iterator = site_config
    for_each = var.site_configs
    content {
      ip_restriction            = site_config.value["ip_restriction"]
    }
  }
 identity{
   type="SystemAssigned"
 }
 // app_settings = {
// "oidcClientId": "ecb0074940N"
//"oidcClientSecret": "f1ae7a0b912a98320eb40b53093f367f43bf0f5d5b941110e1442a0eb26d8db028b271cd499853cd13b7079e6a4b86bb"
//"oidcAudience": "ecb0074940N"
//"redirectURI": "https://webapp-ecbt-dev-centralus.azurewebsites.net/signin-oidc"
  //}
//connection_string {
  //  name  = "Database"
  //  type  = "SQLServer"
  //  value = "Server=tcp:sqlserver-ecbt-dev-centralus-001.database.windows.net,1433;Initial Catalog=sqldatabase-ecbt-dev-centralus-001;Persist Security Info=False;User ID=dev_appadmin;Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30"
//}
}

# Create new resource group
module "front_door_resource_group" {
  source              = ".//modules/resource-group"
  resource_group_name = "${var.resource_group_name}_${var.environment}_${var.primary_location}_${var.resource_group_name_frontdoor}"
  location            = var.frontdoor_location
   tags = merge(var.sub_tags,{environment =var.environment},)
   }
resource "azurerm_dns_zone" "example" {
  name                = "${var.front_door_name}${var.domain_name}"
  resource_group_name =  module.front_door_resource_group.resource_group_name
}

resource "azurerm_dns_cname_record" "target" {
  name                = "dnszonetarget_${var.pro1}_${var.environment}_${var.primary_location}_${var.resource_group_name_frontdoor}"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name =  module.front_door_resource_group.resource_group_name
  ttl                 = 300
  record              = "optum.com"
}

resource "azurerm_dns_cname_record" "example" {
  name                = "cname_${var.pro1}_${var.environment}_${var.primary_location}_${var.resource_group_name_frontdoor}"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name =  module.front_door_resource_group.resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_dns_cname_record.target.id
}

resource "azurerm_frontdoor" "frontdoor" {
  name                                         = var.front_door_name
  resource_group_name                          = module.front_door_resource_group.resource_group_name
  #enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "${var.environment}-regions-routingrule"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints =  ["${var.front_door_name}1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "${var.front_door_name}-backend-pool"
    }
  }

  backend_pool_load_balancing {
    name = "${var.environment}fdLoadBalancingSettings1"
    sample_size                     = 4
    successful_samples_required     = 2
    additional_latency_milliseconds = 0
  }

  backend_pool_health_probe {
    name = "${var.environment}HealthProbeSetting1"
    enabled             = true
    path                = "/"
    protocol            = "Http"
    probe_method        = "HEAD"
    interval_in_seconds = 60
  }

  backend_pool {
    name = "${var.front_door_name}-backend-pool"
    backend {
      host_header = module.webappservice_primary_region.default_site_hostname
      address     = module.webappservice_primary_region.default_site_hostname
      http_port   = 80
      https_port  = 443
      priority = 1
    }
    

    load_balancing_name = "${var.environment}fdLoadBalancingSettings1"
    health_probe_name   = "${var.environment}HealthProbeSetting1"
  }
  frontend_endpoint {
    name      = var.front_door_name
    host_name = "${var.front_door_name}.azurefd.net"
    session_affinity_enabled="true"
  # web_application_firewall_policy_link_id="/subscriptions/ae404c79-ff8d-42f9-8553-ccb0fe9bd1fe/resourceGroups/rg_${var.pro1}_${var.environment}_${var.primary_location}_${var.resource_group_name_frontdoor}/providers/Microsoft.Network/frontdoorWebApplicationFirewallPolicies/${var.environment}allowonlyuhgtraffic"
  }
  frontend_endpoint {
    name      = "${var.front_door_name}1"
    host_name = "${var.front_door_name}${var.domain_name}"
    session_affinity_enabled="true"
 #  web_application_firewall_policy_link_id="/subscriptions/ae404c79-ff8d-42f9-8553-ccb0fe9bd1fe/resourceGroups/rg_${var.pro1}_${var.environment}_${var.primary_location}_${var.resource_group_name_frontdoor}/providers/Microsoft.Network/frontdoorWebApplicationFirewallPolicies/${var.environment}allowonlyuhgtraffic"
  }
}

    
  resource "azurerm_frontdoor_custom_https_configuration" "example_custom_https_0" {
  frontend_endpoint_id              = azurerm_frontdoor.frontdoor.frontend_endpoints[var.front_door_name]
  custom_https_provisioning_enabled = false
   
}  
     resource "azurerm_frontdoor_custom_https_configuration" "example_custom_https_1" {
  frontend_endpoint_id              = azurerm_frontdoor.frontdoor.frontend_endpoints["${var.front_door_name}1"]
  custom_https_provisioning_enabled = true
    custom_https_configuration {
    certificate_source                      = "FrontDoor"
    # azure_key_vault_certificate_secret_name = "frontdoor"
    # azure_key_vault_certificate_vault_id    = module.primary_key_vault.key-vault-secrets[0]
  }
}  
resource "azurerm_frontdoor_rules_engine" "frontdoor_rules_engine" {
  name                =  "${var.environment}-CORS"
  frontdoor_name      = azurerm_frontdoor.frontdoor.name
  resource_group_name = azurerm_frontdoor.frontdoor.resource_group_name

  rule {
    name     = "CORS"
    priority = 1

    match_condition {

      variable = "RequestHeader"
      selector = "origin"
      operator = "Equal"
      value    = [azurerm_frontdoor.frontdoor.cname]

    }

    action {

      request_header {
        header_action_type = "Overwrite"
        header_name        = "Access-Control-Allow-Origin"
        value              = azurerm_frontdoor.frontdoor.cname
      }

    }
  }
}

  
resource "azurerm_frontdoor_firewall_policy" "frontdoorfirewallpolicy" {
  name                              = "${var.environment}allowonlyuhgtraffic"
  resource_group_name               = azurerm_frontdoor.frontdoor.resource_group_name
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403

  custom_rule {
    name                           = "onlyallowuhgtraffic"
    enabled                        = true
    priority                       = 100
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = true
      match_values       = ["168.183.0.0/16", "149.111.0.0/16", "128.35.0.0/16", "161.249.0.0/16", "198.203.174.0/23", "198.203.176.0/22", "198.203.180.0/23"]
    }
  }
}

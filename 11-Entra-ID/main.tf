data "azuread_domains" "aad" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad.domains.*.domain_name
}

output "domains" {
    value = local.domain_name
  
}
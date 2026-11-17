data "azuread_domains" "aad" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad.domains.*.domain_name
  users = csvdecode(file("users.csv"))
}

resource "azuread_user" "users" {
  for_each = {for user in local.users : user.first_name => user}
  user_principal_name = format("%s%s@%s",each.value.first_name,each.value.last_name,local.domain_name[0])
  password = format("%s@%s",each.value.last_name,each.value.first_name)
  display_name = "${each.value.first_name} ${each.value.last_name}"
  force_password_change = true
  department = each.value.department
  job_title = each.value.job_title
}

output "domains" {
    value = local.domain_name
  
}
output "usersDetails" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}
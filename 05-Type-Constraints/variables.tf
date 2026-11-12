variable "environment" {
    type=string
    description = "environment"
    default = "staging"
}
variable "subnet_mask"  {
    type = number
    description = "subnet mask value"
    default = 24
}
variable "disable_pass_auth" {
    type = bool
    default = false
}
variable "allowed_regions" {
  type = list(string)
  description = "list of allowed region"
  default = [ "East Asia", "East Europe", "East US" ]
}
variable "tags" {
    type = map(string)
    description = "tags to be applied to the resources"
    default = {
      "managed_by" = "terraform"
      "department" = "devops"
    }
}
variable "networking" {
  type = tuple([ string,string,number ])
  default = [ "10.0.0.0", "10.0.2.0", 16 ]
  
}

variable "vm_config" {
    type = object({
      size = string
      publisher = string
      sku = string
      version = string
    })
    default = {
       size = "Standard_B2ats_v2"
      publisher = "Cononical"
      sku = "22_04-lts"
      version = "latest"
    }
  
}

variable "storage_acc_name" {
  type = list(string)
  default = [ "vasuantala", "vasu049" ]
}
variable "environment" {
  type = string
  default = "dev"
}
variable "location" {
  type=string
  default = "East Asia"  
}
variable "allowed_location" {
  type = list(string)
  default = ["East US", "East Asia"]
  
}

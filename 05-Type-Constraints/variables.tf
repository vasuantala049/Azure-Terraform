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
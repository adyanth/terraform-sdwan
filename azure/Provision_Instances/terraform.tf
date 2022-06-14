variable "vbond_uri" {}
variable "vbond_count" {}
variable "vmanage_uri" {}
variable "vmanage_count" {}
variable "vsmart_uri" {}
variable "vsmart_count" {}
variable "vbond_instances_type" {}
variable "vmanage_instances_type" {}
variable "vsmart_instances_type" {}
variable "username" {}
variable "password" {}
variable "org_name" {}
variable "sp_org_name" {}


data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "../Provision_VNET/terraform.tfstate"
  }
}

resource "azurerm_image" "vbond_image" {
  name                = "vbond_image"
  location            = data.terraform_remote_state.spam.outputs.region
  resource_group_name = data.terraform_remote_state.spam.outputs.resource_group_name
  hyper_v_generation  = "V1"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.vbond_uri
  }
}

module "vbond" {
  source                 = "./vbond"
  region                 = data.terraform_remote_state.spam.outputs.region
  avsetvbond             = data.terraform_remote_state.spam.outputs.avsetvbond
  Vipela_Control_Plane   = data.terraform_remote_state.spam.outputs.Vipela_Control_Plane
  vbond_image            = resource.azurerm_image.vbond_image.id
  viptela_instances_type = var.vbond_instances_type
  counter                = var.vbond_count
  subnet                 = data.terraform_remote_state.spam.outputs.subnet
  resource_group_name    = data.terraform_remote_state.spam.outputs.resource_group_name
  username               = var.username
  password               = var.password
  org_name               = ""
  sp_org_name            = ""
}

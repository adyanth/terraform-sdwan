module "vsmart" {
  source                 = "./vsmart"
  region                 = data.terraform_remote_state.spam.outputs.region
  avsetvsmart            = data.terraform_remote_state.spam.outputs.avsetvsmart
  Vipela_Control_Plane   = data.terraform_remote_state.spam.outputs.Vipela_Control_Plane
  vsmart_image           = resource.azurerm_image.vsmart_image.id
  viptela_instances_type = var.vsmart_instances_type
  counter                = var.vsmart_count
  subnet                 = data.terraform_remote_state.spam.outputs.subnet
  resource_group_name    = data.terraform_remote_state.spam.outputs.resource_group_name
  username               = var.username
  password               = var.password
  vbond                  = module.vbond.vbonds_vbondEth1Ip
  org_name               = ""
  sp_org_name            = ""
}

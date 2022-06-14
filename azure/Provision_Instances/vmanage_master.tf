module "vmanage" {
  source                 = "./vmanage"
  region                 = data.terraform_remote_state.spam.outputs.region
  avsetvmanage           = data.terraform_remote_state.spam.outputs.avsetvmanage
  Vipela_Control_Plane   = data.terraform_remote_state.spam.outputs.Vipela_Control_Plane
  vmanage_image          = resource.azurerm_image.vmanage_image.id
  viptela_instances_type = var.vmanage_instances_type
  counter                = var.vmanage_count
  subnet                 = data.terraform_remote_state.spam.outputs.subnet
  resource_group_name    = data.terraform_remote_state.spam.outputs.resource_group_name
  username               = var.username
  password               = var.password
  vbond                  = module.vbond.vbonds_vbondEth1Ip
  org_name               = ""
  sp_org_name            = ""
}

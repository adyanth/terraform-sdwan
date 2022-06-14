provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = data.terraform_remote_state.spam.outputs.region
}

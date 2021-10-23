# ------------------------------------------------------------------------------
# VPC configuration
# ------------------------------------------------------------------------------
# Remote state of VPC
data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "liquality"
    workspaces = {
      name = local.vpc_workspace_name
    }
  }
}

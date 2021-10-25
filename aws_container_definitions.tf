# ------------------------------------------------------------------------------
# Container Definitions
# ------------------------------------------------------------------------------

locals {
  # bitcoin
  bitcoin_def = templatefile("${path.module}/templates/container-definition-bitcoin.json", {
    CONTAINER_NAME = var.bitcoin_task_name
    ESSENTIAL      = var.bitcoin_is_essential
    IMAGE_URL      = var.bitcoin_image_registry_url
    IMAGE_VERSION  = var.bitcoin_image_version
    CONTAINER_PORT = var.bitcoin_container_port
    MEMORY         = var.bitcoin_container_memory_alloc
    CPU            = var.bitcoin_container_cpu_alloc
    CLUSTER_NAME   = local.cluster_name
    AWS_REGION     = var.aws_region
    VOLUME_NAME    = var.bitcoin_ebs_volume_name
    RPC_AUTH       = var.bitcoin_rpc_auth
    ENV_VARS       = ""
  })
  # bitcoin_def = templatefile("${path.module}/templates/container-definition-bitcoin.json", {
  #   CONTAINER_NAME = var.bitcoin_task_name
  #   ESSENTIAL      = var.bitcoin_is_essential
  #   IMAGE_URL      = var.bitcoin_image_registry_url
  #   IMAGE_VERSION  = var.bitcoin_image_version
  #   CONTAINER_PORT = var.bitcoin_container_port
  #   MEMORY         = var.bitcoin_container_memory_alloc
  #   CPU            = var.bitcoin_container_cpu_alloc
  #   CLUSTER_NAME   = local.cluster_name
  #   AWS_REGION     = var.aws_region
  #   VOLUME_NAME    = var.bitcoin_ebs_volume_name
  #   RPC_AUTH       = var.bitcoin_rpc_auth
  #   ENV_VARS = jsonencode(concat(
  #     [{ name = "BITCOIN_DATA", value = "${var.bitcoin_data_path}" }]
  #   ))
  # })

  # electrs
  # electrs_def = templatefile("${path.module}/templates/container-definition-electrs.json", {
  #   CONTAINER_NAME      = var.electrs_task_name
  #   ESSENTIAL           = var.electrs_is_essential
  #   IMAGE_URL           = var.electrs_image_registry_url
  #   IMAGE_VERSION       = var.electrs_image_version
  #   CONTAINER_PORT      = var.electrs_container_port
  #   MEMORY              = var.electrs_container_memory_alloc
  #   CPU                 = var.electrs_container_cpu_alloc
  #   CLUSTER_NAME        = local.cluster_name
  #   AWS_REGION          = var.aws_region
  #   BITCOIN_VOLUME_NAME = var.bitcoin_ebs_volume_name
  #   ELECTRS_VOLUME_NAME = var.electrs_ebs_volume_name
  #   ENV_VARS = jsonencode(concat(
  #     [{ name = "BITCOIN_DATA", value = "${var.electrs_data_path}" }]
  #   ))
  # })
}

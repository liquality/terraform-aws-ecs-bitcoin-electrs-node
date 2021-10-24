# ------------------------------------------------------------------------------
# Container Definitions
# ------------------------------------------------------------------------------

locals {
  # bitcoin-core
  bitcoin_def = templatefile("${path.module}/templates/container-definition-bitcoin.json", {
    CONTAINER_NAME = local.bitcoin_service_name
    ESSENTIAL      = var.bitcoin_is_essential
    IMAGE_URL      = var.bitcoin_image_registry_url
    IMAGE_VERSION  = var.bitcoin_image_version
    CONTAINER_PORT = var.bitcoin_container_port
    MEMORY         = var.bitcoin_container_memory_alloc
    CPU            = var.bitcoin_container_cpu_alloc
    CLUSTER_NAME   = local.cluster_name
    AWS_REGION     = var.aws_region
    VOLUME_NAME    = var.chain_ebs_volume_name
    RPC_AUTH       = var.bitcoin_rpc_auth
    ENV_VARS = jsonencode(concat(
      [{ name = "BITCOIN_DATA", value = "${var.chain_data_path}" }]
    ))
  })
}

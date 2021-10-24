locals {
  cluster_name         = "node-bitcoin-electrs-${var.chain_network_name}"
  bitcoin_service_name = "${var.bitcoin_task_name}-${var.chain_network_name}"
  node_alias           = "bitcoin-electrs-${var.chain_network_name}"
  vpc_workspace_name   = "aws-networking-infra-${var.env_alias}"
}

locals {
  tags = {
    environment   = var.env_alias
    chain_service = "bitcoin-electrs-node"
    chain         = "btc"
    chain_network = var.chain_network_name
  }
}

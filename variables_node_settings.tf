# ------------------------------------------------------------------------------
# Chain settings
# ------------------------------------------------------------------------------
variable "chain_network_name" {
  type        = string
  description = "The BTC network (e.g. mainnet, testnet, regtest)."
}

variable "chain_data_path" {
  type        = string
  description = "The data path where the bitcoin chain data will be mounted (on the host)."
  default     = "/home/ec2-user/data-bitcoin-chain"
}

# variable "electrs_data_path" {
#   type        = string
#   description = "The data path where the electrs indexer will be mounted (on the host)."
#   default     = "/home/ec2-user/data-electrs-indexer"
# }

variable "bitcoin_rpc_auth" {
  type        = string
  description = "The rpc auth string for bitcoin-core."
  default     = ""
}

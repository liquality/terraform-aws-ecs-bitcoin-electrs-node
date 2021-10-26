# ------------------------------------------------------------------------------
# bitcoin-core
# ------------------------------------------------------------------------------
variable "bitcoin_instance_count" {
  type        = number
  description = "The number of instances to run."
  default     = 1 # NOTE: Can only support a single instance for now !!!
}

variable "bitcoin_image_registry_url" {
  type        = string
  description = "The full registry path to the Docker image including the image name."
  default     = "ruimarinho/bitcoin-core"
}

# ------------------------------------------------------------------------------
# Container settings
# ------------------------------------------------------------------------------
variable "bitcoin_task_name" {
  type        = string
  description = "The name to attach to the running container (the chain_network_name will be post-pended)."
  default     = "bitcoin"
}

variable "bitcoin_image_version" {
  type        = string
  description = "The Docker image version to use."
  default     = "latest"
}

variable "bitcoin_container_port" {
  type        = number
  description = "The port for the bitcoin json-rpc api"
  default     = 8332
}

variable "bitcoin_container_memory_alloc" {
  type        = number
  description = "The memory allocation to designate for the container."
  default     = 2048
}

variable "bitcoin_container_cpu_alloc" {
  type        = number
  description = "The CPU allocation to designate for the container."
  default     = 1024
}

variable "bitcoin_is_essential" {
  type        = bool
  description = "Wheteher or not to denote the container as essential."
  default     = true
}

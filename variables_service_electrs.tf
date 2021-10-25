# # ------------------------------------------------------------------------------
# # electrs
# # ------------------------------------------------------------------------------
# variable "electrs_instance_count" {
#   type        = number
#   description = "The number of instances to run."
#   default     = 1 # NOTE: Can only support a single instance for now !!!
# }
#
# variable "electrs_image_registry_url" {
#   type        = string
#   description = "The full registry path to the Docker image including the image name."
#   default     = "ghcr.io/vulpemventures/electrs"
# }
#
# # ------------------------------------------------------------------------------
# # Container settings
# # ------------------------------------------------------------------------------
# variable "electrs_task_name" {
#   type        = string
#   description = "The name to attach to the running container."
#   default     = "electrs"
# }
#
# variable "electrs_image_version" {
#   type        = string
#   description = "The Docker image version to use."
#   default     = "latest"
# }
#
# variable "electrs_container_port" {
#   type        = number
#   description = "The port for the electrs json-rpc api"
#   default     = 3000
# }
#
# variable "electrs_container_memory_alloc" {
#   type        = number
#   description = "The memory allocation to designate for the container."
#   default     = 2048
# }
#
# variable "electrs_container_cpu_alloc" {
#   type        = number
#   description = "The CPU allocation to designate for the container."
#   default     = 1024
# }
#
# variable "electrs_is_essential" {
#   type        = bool
#   description = "Wheteher or not to denote the container as essential."
#   default     = true
# }

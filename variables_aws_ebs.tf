# ------------------------------------------------------------------------------
# EBS Volumes
# ------------------------------------------------------------------------------

# ---------------------------------------------------------------- bitcoin chain
variable "chain_ebs_volume_id" {
  type        = string
  description = "The volume ID."
}

variable "chain_ebs_volume_name" {
  type        = string
  description = "The volume name."
}

variable "chain_ebs_volume_device_name" {
  type        = string
  description = "The device name of the volume."
  default     = "/dev/sdn"
}

# -------------------------------------------------------------- electrs indexer
# variable "electrs_ebs_volume_id" {
#   type        = string
#   description = "The volume ID."
# }
#
# variable "electrs_ebs_volume_name" {
#   type        = string
#   description = "The volume name."
# }
#
# variable "electrs_ebs_volume_device_name" {
#   type        = string
#   description = "The device name of the volume."
#   default     = "/dev/sdp"
# }

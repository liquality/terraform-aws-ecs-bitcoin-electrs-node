# ------------------------------------------------------------------------------
# EBS Volumes
# ------------------------------------------------------------------------------

# bitcoin
variable "bitcoin_ebs_volume_id" {
  type        = string
  description = "The volume ID."
}

variable "bitcoin_ebs_volume_name" {
  type        = string
  description = "The volume name."
}

variable "bitcoin_ebs_volume_device_name" {
  type        = string
  description = "The device name of the volume."
  default     = "/dev/sdn"
}

# electrs
variable "electrs_ebs_volume_id" {
  type        = string
  description = "The volume ID."
}

variable "electrs_ebs_volume_name" {
  type        = string
  description = "The volume name."
}

variable "electrs_ebs_volume_device_name" {
  type        = string
  description = "The device name of the volume."
  default     = "/dev/sdp"
}

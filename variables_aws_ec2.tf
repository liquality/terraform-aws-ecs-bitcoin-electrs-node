# ------------------------------------------------------------------------------
# AWS EC2 settings
# ------------------------------------------------------------------------------
variable "ec2_ami_id" {
  type        = string
  description = "An AMI ID to launch the EC2 instance."
}

variable "ec2_instance_type" {
  type        = string
  description = "The instance type for the EC2 instance."
  default     = "t2.medium"
}

variable "ec2_ssh_key_pair_name" {
  type        = string
  description = "The logical name of the SSH key pair for auth, whether an existing pair or when adding a new public key (optional)."
  default     = ""
}

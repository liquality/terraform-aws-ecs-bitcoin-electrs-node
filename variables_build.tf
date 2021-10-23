# ------------------------------------------------------------------------------
# Build settings
# ------------------------------------------------------------------------------
variable "env_alias" {
  type        = string
  description = "The target environment alias."
}

variable "aws_region" {
  type        = string
  description = "The target AWS region."
}

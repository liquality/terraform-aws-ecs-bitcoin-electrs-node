# ------------------------------------------------------------------------------
# Data Storage (EBS Volumes)
# ------------------------------------------------------------------------------

# bitcoin chain
resource "aws_volume_attachment" "chain" {
  device_name = var.chain_ebs_volume_device_name
  volume_id   = var.chain_ebs_volume_id
  instance_id = aws_instance.main.id

  skip_destroy = true
}

# electrs indexer
# resource "aws_volume_attachment" "electrs" {
#   device_name = var.electrs_ebs_volume_device_name
#   volume_id   = var.electrs_ebs_volume_id
#   instance_id = aws_instance.main.id
#
#   skip_destroy = true
# }

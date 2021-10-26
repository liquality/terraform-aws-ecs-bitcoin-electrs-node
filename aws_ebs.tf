# ------------------------------------------------------------------------------
# Data Storage (EBS Volumes)
# ------------------------------------------------------------------------------

# bitcoin
resource "aws_volume_attachment" "bitcoin" {
  device_name = var.bitcoin_ebs_volume_device_name
  volume_id   = var.bitcoin_ebs_volume_id
  instance_id = aws_instance.main.id

  skip_destroy = true
}

# # electrs
resource "aws_volume_attachment" "electrs" {
  device_name = var.electrs_ebs_volume_device_name
  volume_id   = var.electrs_ebs_volume_id
  instance_id = aws_instance.main.id

  skip_destroy = true
}

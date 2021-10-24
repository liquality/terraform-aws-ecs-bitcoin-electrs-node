# ------------------------------------------------------------------------------
# EC2 configuration
# ------------------------------------------------------------------------------
resource "aws_instance" "main" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type

  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnets[0] # availability zone: a

  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.sg_ssh_id,       # SSH access
    data.terraform_remote_state.vpc.outputs.sg_btc_8332_id,  # BTC rpc (mainnet)
    data.terraform_remote_state.vpc.outputs.sg_btc_18332_id, # BTC rpc (testnet)
    data.terraform_remote_state.vpc.outputs.sg_http_3000_id, # electrs rpc
    data.terraform_remote_state.vpc.outputs.sg_http_9090_id  # electrs batch api
  ]

  iam_instance_profile = aws_iam_instance_profile.default.id

  user_data = templatefile("${path.module}/templates/init-ec2.sh", {
    CLUSTER_NAME      = local.cluster_name
    REGION            = var.aws_region
    CHAIN_DEVICE_NAME = "${var.chain_ebs_volume_device_name}"
    CHAIN_MOUNT_POINT = "${var.chain_data_path}"
  })

  # user_data = templatefile("${path.module}/templates/init-ec2.sh", {
  #   CLUSTER_NAME        = local.cluster_name
  #   REGION              = var.aws_region
  #   CHAIN_DEVICE_NAME   = "${var.chain_ebs_volume_device_name}"
  #   ELECTRS_DEVICE_NAME = "${var.electrs_ebs_volume_device_name}"
  #   CHAIN_MOUNT_POINT   = "${var.chain_data_path}"
  #   ELECTRS_MOUNT_POINT = "${var.electrs_data_path}"
  # })

  key_name = var.ec2_ssh_key_pair_name

  root_block_device {
    tags = merge(
      local.tags,
      {
        Name = "${local.node_alias}-root-disk"
      }
    )
  }

  tags = merge(
    local.tags,
    {
      Name = local.node_alias
    }
  )
}

# ------------------------------------------------------------------------------
# ECS Service (bitcoin-core)
# ------------------------------------------------------------------------------
resource "aws_ecs_service" "bitcoin" {
  name            = local.bitcoin_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.bitcoin.arn
  launch_type     = "EC2"

  desired_count = var.bitcoin_instance_count

  network_configuration {
    subnets = [data.terraform_remote_state.vpc.outputs.private_subnets[0]] # us-east-1a (NAT Gateway is here)
    security_groups = [
      data.terraform_remote_state.vpc.outputs.sg_http_80_id,  # port 80
      data.terraform_remote_state.vpc.outputs.sg_btc_8332_id, # BTC rpc (mainnet)
      data.terraform_remote_state.vpc.outputs.sg_btc_18332_id # BTC rpc (testnet)
    ]
    assign_public_ip = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Task Definition
# ------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "bitcoin" {
  family = local.bitcoin_service_name

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  memory = var.bitcoin_container_memory_alloc
  cpu    = var.bitcoin_container_cpu_alloc

  tags = local.tags

  volume {
    name      = var.chain_ebs_volume_name
    host_path = var.chain_data_path
  }

  container_definitions = format("[%s]", join(",", [
    "${local.bitcoin_def}"
  ]))
}

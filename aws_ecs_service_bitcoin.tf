# ------------------------------------------------------------------------------
# ECS Service (bitcoin)
# ------------------------------------------------------------------------------
resource "aws_ecs_service" "bitcoin" {
  name            = local.bitcoin_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.bitcoin.arn
  launch_type     = "EC2"

  desired_count = var.bitcoin_instance_count

  network_configuration {
    subnets = data.terraform_remote_state.vpc.outputs.private_subnets
    security_groups = [
      data.terraform_remote_state.vpc.outputs.sg_http_80_id,  # port 80
      data.terraform_remote_state.vpc.outputs.sg_btc_19001_id # bitcoin rpc
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
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  memory = var.bitcoin_container_memory_alloc
  cpu    = var.bitcoin_container_cpu_alloc

  tags = local.tags

  volume {
    name      = var.bitcoin_ebs_volume_name
    host_path = var.bitcoin_data_path
  }

  container_definitions = format("[%s]", join(",", [
    "${local.bitcoin_def}"
  ]))
}

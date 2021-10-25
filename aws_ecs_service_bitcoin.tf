# ------------------------------------------------------------------------------
# ECS Service (bitcoin)
# ------------------------------------------------------------------------------
resource "aws_ecs_service" "bitcoin" {
  name            = local.bitcoin_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.bitcoin.arn
  launch_type     = "EC2"

  desired_count = var.bitcoin_instance_count

  health_check_grace_period_seconds = 120

  load_balancer {
    target_group_arn = aws_lb_target_group.bitcoin.arn
    container_name   = var.bitcoin_task_name
    container_port   = var.bitcoin_container_port
  }

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

# ------------------------------------------------------------------------------
# Load Balancer
# ------------------------------------------------------------------------------
resource "aws_alb" "bitcoin" {
  name               = local.bitcoin_service_name
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnets

  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_http_80_id # port 80
  ]

  internal = false

  # enable_cross_zone_load_balancing = "true"

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Listener / Target Group
# ------------------------------------------------------------------------------
resource "aws_lb_listener" "bitcoin" {
  load_balancer_arn = aws_alb.bitcoin.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bitcoin.arn
  }
}

resource "aws_lb_target_group" "bitcoin" {
  name        = var.bitcoin_task_name
  port        = var.bitcoin_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "ip"

  depends_on = [aws_alb.bitcoin]

  # health_check {
  #   enabled             = true
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   interval            = 30 # seconds
  #   timeout             = 10 # seconds
  #   matcher             = "200"
  #   path                = ""
  #   port                = var.bitcoin_container_port
  # }

  tags = local.tags
}

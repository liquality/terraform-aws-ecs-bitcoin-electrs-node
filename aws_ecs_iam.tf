# ------------------------------------------------------------------------------
# IAM Role
# ------------------------------------------------------------------------------
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${local.cluster_name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ------------------------------------------------------------------------------
# Cloudwatch logging
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/${local.cluster_name}"

  retention_in_days = 3

  tags = local.tags
}

data "aws_iam_policy_document" "log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:/ecs/${local.cluster_name}:*"]
  }
}

resource "aws_iam_policy" "log_publishing" {
  name        = "${local.cluster_name}-log"
  path        = "/"
  description = "Allow ${local.cluster_name} to log to cloudwach"

  policy = data.aws_iam_policy_document.log_publishing.json
}

resource "aws_iam_role_policy_attachment" "log_publishing" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.log_publishing.arn
}

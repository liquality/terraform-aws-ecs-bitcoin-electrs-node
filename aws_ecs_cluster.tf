# ------------------------------------------------------------------------------
# Container Cluster (ECS)
# ------------------------------------------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = local.cluster_name

  tags = local.tags
}

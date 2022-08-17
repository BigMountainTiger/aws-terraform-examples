resource "aws_ecs_cluster" "basic-empty-cluster" {
  name = local.cluster-name
}

resource "aws_ecs_cluster_capacity_providers" "basic-empty-cluster" {
  cluster_name = aws_ecs_cluster.basic-empty-cluster.name
  capacity_providers = [
    aws_ecs_capacity_provider.basic-empty-cluster.name
  ]
}

resource "aws_iam_instance_profile" "ecs_node" {
  name = local.cluster-name
  role = aws_iam_role.ecs_instance_role.name
}

locals {
  user-data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${local.cluster-name} >> /etc/ecs/ecs.config
  EOF
}

resource "aws_launch_template" "basic-empty-cluster" {
  name_prefix   = "ECS"
  instance_type = "t2.micro"
  image_id      = data.aws_ami.ecs_ami.id
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_node.arn
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [local.security-group-id]
  }
  user_data = base64encode(local.user-data)

}

resource "aws_autoscaling_group" "basic-empty-cluster" {
  name = local.cluster-name
  launch_template {
    id      = aws_launch_template.basic-empty-cluster.id
    version = "$Latest"
  }
  min_size = 1
  max_size = 1

  vpc_zone_identifier = [local.private-1, local.private-2]
}

resource "aws_ecs_capacity_provider" "basic-empty-cluster" {
  name = local.cluster-name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.basic-empty-cluster.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status = "DISABLED"
    }
  }
}

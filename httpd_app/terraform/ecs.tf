resource "aws_ecs_task_definition" "task" {
    family                   = "httpd-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions    = file("../container_definitions.json")
}

# クラスター
resource "aws_ecs_cluster" "cluster" {
    name = "httpd-cluster"
}

# サービス
resource "aws_ecs_service" "service" {
    name                              = "httpd-service"
    cluster                           = aws_ecs_cluster.cluster.arn
    task_definition                   = aws_ecs_task_definition.task.arn
    desired_count                     = 1
    launch_type                       = "FARGATE"
    platform_version                  = "1.4.0"

    network_configuration {
        assign_public_ip = true
        security_groups  = [aws_security_group.service.id]
        subnets = module.vpc.public_subnets
    }

    lifecycle {
        ignore_changes = [task_definition]
    }
}

variable "nr_lisence_key" {}

resource "aws_ecs_task_definition" "task" {
    family                   = "ecs-newrelic-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    container_definitions    = jsonencode(
        [
            {
                "name": "httpd-container",
                "image": "httpd:latest",
                "essential": true,
                "memory": 128,
                "portMappings": [
                    {
                        "protocol": "tcp",
                        "containerPort": 80
                    }
                ]
            },
            {
                "name": "newrelic-flex",
                "image": "${aws_ecr_repository.newrelic_flex.repository_url}",
                "cpu": 256,
                "memoryReservation": 512,
                "environment": [
                    {
                        "name": "NRIA_LICENSE_KEY",
                        "value": "${var.nr_lisence_key}"
                    },
                    {
                        "name": "NRIA_OVERRIDE_HOST_ROOT",
                        "value": ""
                    },
                    {
                        "name": "NRIA_IS_SECURE_FORWARD_ONLY",
                        "value": "true"
                    },
                    {
                        "name": "FARGATE",
                        "value": "true"
                    },
                    {
                        "name": "ENABLE_NRI_ECS",
                        "value": "true"
                    },
                    {
                        "name": "NRIA_PASSTHROUGH_ENVIRONMENT",
                        "value": "ECS_CONTAINER_METADATA_URI,ENABLE_NRI_ECS,FARGATE"
                    }
                ],
                "essential": true,
                "linuxParameters": {
                    "initProcessEnabled": true
                },
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "${aws_cloudwatch_log_group.newrelic_flex.name}",
                        "awslogs-stream-prefix": "nrflex",
                        "awslogs-region": "ap-northeast-1"
                    }
                }
            }
        ]


    )
}

resource "aws_ecs_cluster" "cluster" {
    name = "ecs-newrelic-cluster"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

    configuration {
        execute_command_configuration {
            logging = "OVERRIDE"
            log_configuration {
                cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_exec.name
            }
        }
    }
}

resource "aws_ecs_cluster_capacity_providers" "newrelic" {
    cluster_name       = aws_ecs_cluster.cluster.name
    capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_service" "service" {
    name                              = "ecs-newrelic-service"
    cluster                           = aws_ecs_cluster.cluster.arn
    task_definition                   = aws_ecs_task_definition.task.arn
    desired_count                     = 1
    platform_version                  = "1.4.0"
    enable_execute_command = true

    network_configuration {
        assign_public_ip = true
        security_groups  = [aws_security_group.service.id]
        subnets = module.vpc.public_subnets
    }

    capacity_provider_strategy {
        capacity_provider = "FARGATE"
        weight            = 1
    }



}

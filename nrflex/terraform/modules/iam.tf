resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs-newrelic-cluster-ecs-task-execution-role"
    path = "/"
    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Action" : "sts:AssumeRole",
            "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
            },
            "Effect" : "Allow"
        }
        ]
    })
}

resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
    name = "ecs-newrelic-cluster-ecs-task-execution-role-policy"
    role = aws_iam_role.ecs_task_execution_role.name

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Effect" : "Allow",
            "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
            ],
            "Resource" : "*"
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "ssm:GetParameters"
            ],
            "Resource" : "*"
        }
        ]
    })
}

resource "aws_iam_role" "ecs_task_role" {
    name = "ecs-newrelic-cluster-ecs-task-role"
    path = "/"
    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Action" : "sts:AssumeRole",
            "Principal" : {
                "Service" : "ecs-tasks.amazonaws.com"
            },
            "Effect" : "Allow"
        }
        ]
    })
}

resource "aws_iam_role_policy" "ecs_task_role-polocy" {
    name = "ecs-newrelic-cluster-ecs-task-role-policy"
    role = aws_iam_role.ecs_task_role.name

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Effect" : "Allow",
            "Action" : [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
            ],
            "Resource" : "*"
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource" : "*"
        }
        ]
    })
}

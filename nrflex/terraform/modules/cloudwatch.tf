resource "aws_cloudwatch_log_group" "ecs_exec" {
    name              = "/aws/ecs/newrelic-cluster/ecs-exec"
    retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "newrelic_flex" {
    name              = "/aws/ecs/newrelic-cluster/newrelic-flex"
    retention_in_days = 14
}

resource "aws_ecr_repository" "newrelic_flex" {
    name                 = "nrflex-ecs"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

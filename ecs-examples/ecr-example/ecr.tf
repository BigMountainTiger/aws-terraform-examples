resource "aws_ecr_repository" "example_ecr_repository" {
  name = "example_ecr_repository"

  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "expire_policy" {
  repository = aws_ecr_repository.example_ecr_repository.name

  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "Expire untagged images older than 1 days",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 1
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
  })
}

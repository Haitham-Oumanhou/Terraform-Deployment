resource "aws_ecr_repository" "my_repository" {
  name = "my_repository"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}

resource "aws_lambda_function" "addtodo_lambda" {
  function_name     = "addTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:addtodo-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}

resource "aws_lambda_function" "completodo_lambda" {
  function_name     = "completeTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:completetodo-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}

resource "aws_lambda_function" "deletetodo_lambda" {
  function_name     = "deleteTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:deletetodo-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}

resource "aws_lambda_function" "updatetodo_lambda" {
  function_name     = "updateTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:updatetodo-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}

resource "aws_lambda_function" "getalltodos_lambda" {
  function_name     = "getallTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:getalltodos-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}


resource "aws_lambda_function" "gettodo_lambda" {
  function_name     = "gettodoTodoTF"
  role              = "arn:aws:iam::628875698193:role/LabRole"
  package_type      = "Image"
  image_uri         = "${aws_ecr_repository.my_repository.repository_url}:gettodo-lambda"
  timeout           = 15
  memory_size       = 128

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}


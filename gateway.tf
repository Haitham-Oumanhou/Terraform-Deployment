resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "TodoAPI"
  description = "API for managing todos"
}

resource "aws_api_gateway_resource" "todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todos"
}

resource "aws_api_gateway_resource" "todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_resource.todos.id
  path_part   = "{id}"
}

# ----- getAllTodosConfiguration -----

# GET Method for /todos
resource "aws_api_gateway_method" "todos_get" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integration for GET method
resource "aws_api_gateway_integration" "todos_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todos.id
  http_method             = aws_api_gateway_method.todos_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.getalltodos_lambda.invoke_arn
}

# Integration response for GET method
resource "aws_api_gateway_integration_response" "todos_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.todos_get.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot"
  }
}

# Method response for GET method
resource "aws_api_gateway_method_response" "todos_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.todos_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Lambda permissions for GET
resource "aws_lambda_permission" "getalltodos_permission" {
  statement_id  = "AllowAPIGatewayInvokeGetAllTodos"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getalltodos_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/GET/todos"
}

# ----- AddTodosConfiguration -----

# POST Method for /todos
resource "aws_api_gateway_method" "todos_post" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integration for POST method
resource "aws_api_gateway_integration" "todos_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todos.id
  http_method             = aws_api_gateway_method.todos_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.addtodo_lambda.invoke_arn
}

# Integration response for POST method
resource "aws_api_gateway_integration_response" "todos_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = "POST"
  status_code = "200"

  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot"
  }
}

# Method response for POST method
resource "aws_api_gateway_method_response" "todos_post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.todos_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Lambda permissions for POST
resource "aws_lambda_permission" "create_todo_permission" {
  statement_id  = "AllowAPIGatewayInvokeCreateTodo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.addtodo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/POST/todos"
}

# ----- DeleteTodosConfiguration -----

# DELETE Method for /todos/{id}
resource "aws_api_gateway_method" "todos_delete" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "DELETE"
  authorization = "NONE"

  # Enable path parameter
  request_parameters = {
    "method.request.path.id" = true
  }
}

# Integration for DELETE method
resource "aws_api_gateway_integration" "todos_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.todos_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.deletetodo_lambda.invoke_arn
}

# Integration response for DELETE method
resource "aws_api_gateway_integration_response" "todos_delete_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = "DELETE"
  status_code = "200"

  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot"
  }
}

# Method response for DELETE method
resource "aws_api_gateway_method_response" "todos_delete_method_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.todos_delete.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Lambda permissions for DELETE
resource "aws_lambda_permission" "delete_todo_permission" {
  statement_id  = "AllowAPIGatewayInvokeDeleteTodo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deletetodo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/DELETE/todos/{id}"
}


# ----- CompleteTodoConfiguration -----

# PATCH Method for /todos/{id}
resource "aws_api_gateway_method" "todos_patch" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "PATCH"
  authorization = "NONE"

  # Enable path parameter
  request_parameters = {
    "method.request.path.id" = true
  }
}

# Integration for PATCH method
resource "aws_api_gateway_integration" "todos_patch_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.todos_patch.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.completodo_lambda.invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

# Integration response for PATCH method
resource "aws_api_gateway_integration_response" "todos_patch_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.todos_patch.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot"
  }
}

# Method response for PATCH method
resource "aws_api_gateway_method_response" "todos_patch_method_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.todos_patch.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Lambda permissions for PATCH
resource "aws_lambda_permission" "completetodo_permission" {
  statement_id  = "AllowAPIGatewayInvokeCompleteTodo"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.completodo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/PATCH/todos/{id}"
}


# ----- UpdateTodoConfiguration -----

# Define the API Gateway Method for PUT
resource "aws_api_gateway_method" "todos_put" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "PUT"
  authorization = "NONE"

  # Enable path parameter
  request_parameters = {
    "method.request.path.id" = true
  }
}

# Define the Integration for PUT
resource "aws_api_gateway_integration" "todos_put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todo_id.id
  http_method             = aws_api_gateway_method.todos_put.http_method
  integration_http_method = "POST" # Matches the Lambda trigger type
  type                    = "AWS_PROXY" # Proxy integration for Lambda
  uri                     = aws_lambda_function.updatetodo_lambda.invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

# Define the Integration Response for PUT
resource "aws_api_gateway_integration_response" "todos_put_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.todos_put.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "$input.path('$')"
  }
}


# Define the Method Response for PUT
resource "aws_api_gateway_method_response" "todos_put_method_response" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.todos_put.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Lambda Permission for PUT
resource "aws_lambda_permission" "update_todo_permission" {
  statement_id  = "AllowAPIGatewayInvokeUpdateTodo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updatetodo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/PUT/todos/{id}"
}


resource "aws_api_gateway_deployment" "todo_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id

  depends_on = [
    aws_api_gateway_integration.todos_get_integration,
    aws_api_gateway_integration.todos_post_integration,
    aws_api_gateway_integration.todos_delete_integration
  ]
}

resource "aws_api_gateway_stage" "todo_api_stage" {
  deployment_id = aws_api_gateway_deployment.todo_api_deployment.id
  rest_api_id  = aws_api_gateway_rest_api.todo_api.id
  stage_name   = "dev"
}
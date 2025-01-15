resource "aws_dynamodb_table" "todo_table" {
  name           = "Todo_table"
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "Id"             

  attribute {
    name = "Id"
    type = "S"  
  }

  attribute {
    name = "Status"
    type = "S"  
  }

  attribute {
    name = "Task"
    type = "S" 
  }

  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "Status"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "TaskIndex"
    hash_key        = "Task"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
    Project     = "TodoApp"
  }
}
resource "aws_dynamodb_table" "Employees" {
  name = "Employees"
  billing_mode     = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }
  hash_key = "id"
}
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "state-table"
  billing_mode   = "PAY_AS_PER_REQUEST"
  hash_key       = "lockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  

  tags = {
    Name        = "dynamodb-table"
    Environment = "production"
  }
}
resource "aws_dynamodb_table" "basic-dynamodb-table" {
                    name           = "${var.en}-infra-app-table"
  billing_mode   = "PAY_AS_PER_REQUEST"
  hash_key       = "var.hash.key"

  attribute {
    name = "LockId"
    type = "S"
  }

  

  tags = {
                Name        = "${var.env}-infra-app-table"
    Environment = var.env
  }
}
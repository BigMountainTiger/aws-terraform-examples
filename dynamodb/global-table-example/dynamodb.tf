resource "aws_dynamodb_table" "us-east-1" {
  provider = aws.us-east-1

  name             = var.dynamo_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "us-east-2" {
  provider = aws.us-east-2

  name             = var.dynamo_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "us-west-2" {
  provider = aws.us-west-2

  name             = var.dynamo_table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_global_table" "global_table" {
  provider = aws.us-east-1

  depends_on = [
    aws_dynamodb_table.us-east-1,
    aws_dynamodb_table.us-east-2,
    aws_dynamodb_table.us-west-2,
  ]

  name = var.dynamo_table_name

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-east-2"
  }

  replica {
    region_name = "us-west-2"
  }
}

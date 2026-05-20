resource "aws_s3_object" "first_json" {
  bucket = aws_s3_bucket.s3.id
  key    = "data/sample_json.json"
  source = "${path.module}/data/sample_json.txt"

  etag = filemd5("${path.module}/data/sample_json.txt")
}

resource "aws_s3_object" "second_json" {
  bucket = aws_s3_bucket.s3.id
  key    = "data/text/sample_json.json"
  source = "${path.module}/data/sample_json.txt"

  etag = filemd5("${path.module}/data/sample_json.txt")
}
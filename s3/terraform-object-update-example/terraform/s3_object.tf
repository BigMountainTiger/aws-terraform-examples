# 1. Terraform only upload the file once
# 2. If we want the terraform to upload the file when it changes, we need to add the "etag" property
# 3. It is better to use "source_hash" because it does not have the limitations on the "etag"

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.s3.bucket
  key    = "files/example.txt"
  source = "${path.module}/files/example.txt"

  source_hash = filesha512("${path.module}/files/example.txt")

  depends_on = [
    aws_s3_bucket.s3
  ]
}

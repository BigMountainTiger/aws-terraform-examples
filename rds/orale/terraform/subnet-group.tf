resource "aws_db_subnet_group" "oracle" {
  name = "oracle-subnect-group"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "oracle-subnect-group"
  }
}
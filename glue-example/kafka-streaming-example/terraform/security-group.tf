resource "aws_security_group" "kafka_instance" {
  name        = "kafka_instance"
  description = "Allow traffic to the kafka_instance"
  vpc_id      = data.aws_vpc.default_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh/22"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "zoo-keeper"
    protocol    = "tcp"
    from_port   = 2181
    to_port     = 2181
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "kafka"
    protocol    = "tcp"
    from_port   = 9092
    to_port     = 9092
    cidr_blocks = ["0.0.0.0/0"]
  }

}

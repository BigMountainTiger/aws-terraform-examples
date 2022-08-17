data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_instance" "kafka_instance" {
  ami                         = local.ami_id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.kafka_instance.name]
  key_name                    = local.key_pair_name

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "kafka_instance"
  }

  depends_on = [
    aws_security_group.kafka_instance
  ]
}



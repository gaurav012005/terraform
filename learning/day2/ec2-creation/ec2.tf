resource aws_key_pair my-key {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

resource aws_default_vpc default {

}

resource aws_security_group my_security_group {
  name        = "automate-sg"
  description = "This will add tf generated security group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "automate_sg"
  }
  
}

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my-key.key_name
    security_groups = [aws_security_group.my_security_group.name]  
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id
    user_data = file("install_nginx.sh")

    root_block_device {
        volume_size = var.ec2_root_storage_size
        volume_type = "gp3"
    }
    tags = {
      Name = "ec2-instance"
    } 
}

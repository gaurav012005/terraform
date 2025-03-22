# Specify the provider
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "var.ec2_ami_id"  # Change to a valid AMI ID for your region
  instance_type = "var.ec2_instance_type"               # Change to your desired instance type

  # Associate the security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Optional: Add a key pair for SSH access
  key_name = "your-key-pair-name"  # Change to your key pair name

  tags = {
    Name = "MyEC2Instance"
  }
}
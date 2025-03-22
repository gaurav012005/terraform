variable "ec2_root_storage_size" {
  description = "size of storage"
  default     = "15"
  type = number

}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-085f9c64a9b75eed5"
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
  type = string 
}

variable "ec2_ami_id" {
  description = "Instance type for the EC2 instance"
  default     = "ami-084568db4383264d4"
  type = string
}
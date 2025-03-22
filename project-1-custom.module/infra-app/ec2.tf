resource "aws_key_pair" "my_key_new"{
    key_name = "${var.env}-infra-app-key"
    public_key = file {"terra-key-ec2.pub"}

    tags= {
        Environment = var.env
    }
 }

 resource "aws_default_vpc" "default"{

 }

 resource "aws_security_group" "my_security_group"{
    name = "${var.env}-infra_app-sg"
   vpc_id = aws_default_vpc.default.vpc_id

 }

ingress{
    from_port =22
    to_port =22
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="ssh open"
}


ingress{
    from_port =80
    to_port =80
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="htto open"
}


ingress{
    from_port =8000
    to_port =8000
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="flask app"
}


 gress{
    from_port =0
    to_port =0
    protoco; = "-1"
    cidr_blocks =["0.0.0.0/0"]
    description ="all access 
}

#ec2
resource "aws_instance" "my_instance"{
    count = var.instance_count
    depends_on [aws_security_group.my_security_group,aws_key_pair.my_key_new]
    key_name = aws_key_pair.my_key_new.key_name
    security_group =[aws_security_group.my_security_group.name]
    instance_type = var.instance_type
    ami = var.ami_id
    root_block_device{
        volume_size =var.env =="prd" ? 20 :10
    }

    tags +{
        Name = "${var.env}-infra_app-ec2"
        Environment =var.env
    }




     }








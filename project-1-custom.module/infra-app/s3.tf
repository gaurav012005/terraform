resource "aws_s3_bucket" "remote-s3" {
  bucket = "${var.env}-${var.bucket_name}"
  filename             = "${path.module}/files/outputfile"
  
  tags ={
    Name = "my-bucket"
    Environment = var.env

  }
  
}

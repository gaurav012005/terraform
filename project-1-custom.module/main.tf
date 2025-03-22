module "dev-infra" {
  source = "./infra-app"
  env ="dev"
  bucket_name = "infra-app-bucket"
  instance_count = 1
  instance_type = "t2.micro"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

module "prd-infra"{
  source = "./infra-app"
  env ="prd"
  bucket_name = "infra-app-bucket"
  instance_count = 2
  instance_type = "t2.micro"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

module "stg-infra" {
  source = "./infra-app"
  env ="stg"
  bucket_name = "infra-app-bucket"
  instance_count = 1
  instance_type = "t2.small"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

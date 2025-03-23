Got it! If you want to set up the infrastructure with only **Terraform** and without **Ansible**, you can follow these steps to create the infrastructure in AWS. The focus will be on provisioning resources using Terraform, such as EC2 instances, S3 buckets, and DynamoDB tables, across different environments (dev, staging, production).

### **Terraform Setup for Multi-Environment Infrastructure**

Here is how you can set up the infrastructure using **Terraform** alone.

---

## **1. Installing Terraform**

If you have not already installed Terraform, follow these instructions:

1. **Update the Package List:**
    ```bash
    sudo apt-get update
    ```

2. **Install Dependencies:**
    ```bash
    sudo apt-get install -y gnupg software-properties-common
    ```

3. **Add HashiCorp's GPG Key:**
    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    ```

4. **Add the HashiCorp Repository:**
    ```bash
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    ```

5. **Install Terraform:**
    ```bash
    sudo apt-get update && sudo apt-get install terraform
    ```

6. **Verify the Installation:**
    ```bash
    terraform --version
    ```

---

## **2. Setting Up the Project Directory**

To keep everything organized, you will need to set up the project structure for **Terraform**.

1. **Create the main project directory**:
    ```bash
    mkdir terraform-infra && cd terraform-infra
    ```

2. **Create the subdirectories for environments**:
    ```bash
    mkdir -p terraform/dev terraform/staging terraform/prod
    ```

Now you have the following directory structure:
```
terraform-infra/
├── terraform/
│   ├── dev/
│   ├── staging/
│   └── prod/
```

---

## **3. Define Terraform Configuration Files**

For each environment (dev, staging, and prod), you will define the necessary resources like EC2, S3, and DynamoDB.

### **3.1. Providers and Backend Configuration (`providers.tf`)**

In the root of your `terraform` directory, create the `providers.tf` file to configure AWS provider settings and specify the region.

```hcl
provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
```

This configuration sets up AWS as the provider and uses an S3 bucket to store the state files.

### **3.2. EC2 Instance Configuration (`ec2.tf`)**

In each environment folder (`dev`, `staging`, `prod`), create a file named `ec2.tf` to configure EC2 instances.

Here’s an example of the content of `ec2.tf`:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Use an appropriate AMI ID for your region
  instance_type = "t2.micro"                # Change based on your requirement

  tags = {
    Name = "Example Instance"
  }
}
```

### **3.3. S3 Bucket Configuration (`s3.tf`)**

In the same environment folders (`dev`, `staging`, `prod`), create a file `s3.tf` to create an S3 bucket.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket-123456"  # Replace with a unique bucket name
  acl    = "private"
}
```

### **3.4. DynamoDB Table Configuration (`dynamodb.tf`)**

For DynamoDB, create `dynamodb.tf` in each environment folder to define the table.

```hcl
resource "aws_dynamodb_table" "example" {
  name         = "example-table"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
  
  attribute {
    name = "id"
    type = "S"
  }
}
```

### **3.5. Outputs (`output.tf`)**

In each environment folder, create an `output.tf` file to output useful information such as the public IP of the EC2 instance.

```hcl
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
```

### **3.6. Variables (`variables.tf`)**

Create a `variables.tf` file in the environment folders to define any variables (like instance type, AMI, etc.) you want to reuse.

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Use the appropriate AMI ID
}
```

### **Directory Structure After Adding Terraform Files:**

Your `terraform` directory structure should now look like this:

```
terraform-infra/
├── terraform/
│   ├── dev/
│   │   ├── ec2.tf
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── staging/
│   │   ├── ec2.tf
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── prod/
│       ├── ec2.tf
│       ├── s3.tf
│       ├── dynamodb.tf
│       ├── output.tf
│       └── variables.tf
└── providers.tf
```

---

## **4. Running Terraform**

Now you are ready to apply the Terraform configuration to provision your infrastructure.

1. **Navigate to the environment directory (e.g., `dev`)**:
    ```bash
    cd terraform/dev
    ```

2. **Initialize Terraform** (this installs necessary plugins and providers):
    ```bash
    terraform init
    ```

3. **Review the Execution Plan**:
    ```bash
    terraform plan
    ```

4. **Apply the Changes** to provision resources:
    ```bash
    terraform apply
    ```

5. **Confirm the Action** when prompted (or use `-auto-approve` to skip the prompt):
    ```bash
    terraform apply -auto-approve
    ```

Terraform will create the resources (EC2 instances, S3 buckets, and DynamoDB tables) for the specified environment.

---

## **5. Final Project Structure**

After completing these steps, your project structure will look like this:

```
terraform-infra/
├── terraform/
│   ├── dev/
│   │   ├── ec2.tf
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── staging/
│   │   ├── ec2.tf
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── prod/
│       ├── ec2.tf
│       ├── s3.tf
│       ├── dynamodb.tf
│       ├── output.tf
│       └── variables.tf
├── providers.tf
└── terraform.tfstate      # Terraform state file
```

---

## **6. Clean Up the Infrastructure**

When you're done, you can destroy the infrastructure to avoid incurring costs.

Navigate to the environment folder (`dev`, `staging`, `prod`), and run:

```bash
terraform destroy
```

---

### **Conclusion**

In this approach, you've used **Terraform** to provision AWS resources across multiple environments (dev, staging, and production). Terraform is responsible for creating and managing your EC2 instances, S3 buckets, and DynamoDB tables, but no configuration management tools like Ansible were used in this process.

Let me know if you need further assistance with any step!
#!/bin/bash
sudo apt update -y
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Hello from Terraform on Ubuntu!" | sudo tee /var/www/html/index.html

# Navigate to the Terraform directory
cd /home/gauravvv/terraform

# Initialize a Git repository
git init

# Add all files to the staging area
git add .

# Commit the changes
git commit -m "Initial commit of Terraform files"

# Push to GitHub
git remote add origin https://github.com/gaurav012005/Terraform
git push -u origin main

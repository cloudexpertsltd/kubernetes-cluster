# platform/backend.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "platform/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
terraform {
  required_version = "~> 1.5.7"

  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "eks/dev/terraform.tfstate"  # temporarily hardcoded
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
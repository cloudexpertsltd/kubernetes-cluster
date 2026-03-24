terraform {
  required_version = "~> 1.5.7"

  backend "s3" {
    bucket         = "cloudex-terraform-state-bucket"
    key            = "eks/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-lock"
  }
}
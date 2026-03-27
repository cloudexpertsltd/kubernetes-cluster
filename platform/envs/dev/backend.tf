terraform {
  backend "s3" {
    bucket         = "cloudex-terraform-state-bucket"
    key            = "platform/dev/argocd/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
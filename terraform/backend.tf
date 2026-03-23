terraform {
  backend "s3" {
    bucket         = "cloudex-terraform-state-bucket"
    key            = "eks/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-lock"

    # Force path style to avoid region redirect issues
    s3_force_path_style = true
  }
}
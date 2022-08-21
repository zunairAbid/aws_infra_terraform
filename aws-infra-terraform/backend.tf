terraform {
  backend "s3" {
    bucket  = "zunair-devops"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "us-east-1"
  }
}
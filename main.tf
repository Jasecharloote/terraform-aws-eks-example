terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #     # for prod bucket (Check before tf apply)
  #     bucket         = "example-prod-tf-state"
  #     key            = "example-prod-tf-state/terraform.tfstate"
  #     region         = "cn-north-1"
  # }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region_name
  access_key = var.access_key
  secret_key = var.secret_key
}
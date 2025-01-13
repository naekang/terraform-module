terraform {
  required_version = ">= 1.3.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.57.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "simple_s3_bucket" {
  source = "../../"

  bucket_name = "simple-s3-bucket-example"
}
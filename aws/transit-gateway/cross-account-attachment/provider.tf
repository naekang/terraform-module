terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.57.0"
      configuration_aliases = [aws.cp, aws.dp]
    }
  }
}
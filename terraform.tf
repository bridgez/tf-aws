terraform {

  cloud {
    organization = "aws2025-org"

    workspaces {
      project = "Default Project"
      name = "tf-aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92.0"
    }
  }

  required_version = ">= 1.2"
}

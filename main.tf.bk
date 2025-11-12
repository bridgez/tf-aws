terraform {

# for local
  required_version = ">= 0.14.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

#for cloud
  cloud {
    organization = "bridgez"
    workspaces {
      name = "example-workspace"      
    }
  }

}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    # Name = "ExampleAppServerInstance"
    Name = var.instance_name
  }
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS DEFAULT REGION"
}

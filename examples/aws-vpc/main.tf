terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/aws-vpc"

  name       = "platform-dev"
  cidr_block = "10.20.0.0/16"

  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.20.10.0/24", "10.20.11.0/24"]
  private_subnet_cidrs = ["10.20.20.0/24", "10.20.21.0/24"]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Owner       = "platform"
  }
}

output "vpc_id" {
  value = module.network.vpc_id
}

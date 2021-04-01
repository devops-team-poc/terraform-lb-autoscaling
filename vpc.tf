terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  access_key = "AKIATABAMMHMTMZ32C5Q"
  secret_key = "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"
} 


resource "aws_vpc" "demo_vpc" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "terraformDemo"
  }
}

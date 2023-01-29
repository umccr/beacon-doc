terraform {
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Service     = "Beacon"
      Stack       = local.stack_name_us
      Creator     = "terraform"
      Environment = terraform.workspace == "default" ? "demo" : terraform.workspace
    }
  }
}

locals {
  stack_name_dash = "jBeacon"
  stack_name_us   = "jBeacon"
}

data "aws_route53_zone" "selected" {
  name = "${var.base_domain}."
}

data "aws_acm_certificate" "domain_cert" {
  domain   = var.base_domain
  statuses = ["ISSUED"]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    # pinned AMI
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230112"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

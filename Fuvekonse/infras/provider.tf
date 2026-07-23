terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.0"
    }
  }

  cloud {
    organization = "Soltune-Montepre"

    workspaces {
      name = "fuvekon"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "doppler" {
}

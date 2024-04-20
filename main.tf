# ---------------------------------------------
#  AWS 設定
# ---------------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
  # skip_requesting_account_id = true
  access_key = var.access_key
  secret_key = var.secret_key
}

# ---------------------------------------------
# terraform 設定
# ---------------------------------------------
terraform {
  required_version = ">=1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



# ---------------------------------------------
# Variables　input変数
# ---------------------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}


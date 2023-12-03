terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = "my-key"
  tags = {
    "Name" = "${local.mytag}-tf-instance"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  for_each = toset(var.users)
  bucket   = "${var.s3_bucket_name}-${each.value}"
  # bucket = "${var.s3_bucket_name}-${count.index}"
  # # count = var.num_of_s3_buckets
  # count = var.num_of_s3_buckets != 0 ? var.num_of_s3_buckets : 1
  #   tags = {
  #   "Name" = "${local.mytag}-${count.index}-tf-bucket"
  # }
}

output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

# output "tf_example_s3_meta" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}

locals {
  mytag = "zafis"
}


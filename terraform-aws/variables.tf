variable "ec2_name" {
  default = "created-by-tf"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-0c02fb55956c7d316"
}

variable "s3_bucket_name" {
   default = "zafis-tf-s3-bucket"
}

variable "num_of_s3_buckets" {
  default = 2
}

variable "users" {
  default = ["santino", "michael", "fredo"]
}
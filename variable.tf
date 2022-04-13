#--variable/main--

variable "bucket" {
  default = "workload-vpc-prod-bucket" # USE A UNIQUE BUCKET NAME
}

variable "region_c" {
  default = "us-east-1c"
}

variable "subnet_one_block" {
  default = "10.16.160.0/20"
}

variable "region_b" {
  default = "us-east-1b"
}

variable "subnet_two_block" {
  default = "10.16.96.0/20"
}

variable "vpc_block" {
  default = "10.16.0.0/16"
}

variable "vpc_name" {
  default = "my-endpoint-vpc"
}

variable "subnet_one_name" {
  default = "subnet-one"
}

variable "subnet_two_name" {
  default = "subnet-two"
}
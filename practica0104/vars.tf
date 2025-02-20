variable "region_name" {
  type = string
  default = "eu-west-3"
}

variable "path_key" {
  type = string
}

variable "count_value" {
  type = string
  default = "2"
}

variable "availability_zone" {
  type = string
}

variable "vpc_id" {
    type = string
    default = "vpc-c2df3aaa"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}
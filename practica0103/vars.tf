variable "ruta_key" {
    type = string
}

variable "availability_zone" {
  type = string
  default = "eu-west-3a"
}

variable "vpc_id" {
  type = string
  default = "vpc-c2df3aaa"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "region_name" {
  type = string
  default = "eu-west-3"
}

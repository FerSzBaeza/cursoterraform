variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "bucket_name" {
  type = string
  default = "var.project_name"
}

variable "client_name" {
  type = string
}

variable "acl_value" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "vpc_id" {
  type = string
}
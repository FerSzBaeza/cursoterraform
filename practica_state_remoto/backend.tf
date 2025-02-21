terraform {
  backend "s3" {
    bucket = "fsanzbae05"
    key = "backend/terraform.state"
    region = "eu-west-3"
    dynamodb_table = "fsanzbae05-cdd-up-and-running-locks"
    encrypt = true
  }
}
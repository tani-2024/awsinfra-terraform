terraform {
  backend "s3" {
    bucket = "terra-state-buckt"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}

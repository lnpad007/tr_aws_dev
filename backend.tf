terraform {
  backend "s3" {
    bucket = "tr-dev-challenge-tf-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
terraform {
  backend "s3" {
    bucket = "lambdaexe-state-bucket"
    key    = "terrastate"
    region = "eu-central-1"
  }
}


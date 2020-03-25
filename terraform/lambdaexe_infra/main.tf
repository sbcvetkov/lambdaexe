provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "eu-central-1"
}

variable "lambdaexe_db_user" {
  type = string
}

variable "lambdaexe_db_pass" {
  type = string
}

data "http" "myPublicIP" {
  url = "http://icanhazip.com"
}

module "networking" {
  source       = "../networking-module"
  aws_vpc_cidr = "10.0.0.0/16"                                                            # Required
  subnet1_cidr = "10.0.7.0/24"                                                                  # Required
  subnet2_cidr = "10.0.8.0/24"                                                                         # Default value
  aws_region   = "eu-central-1"                                                                      # Default value
  my_ip        = "${chomp(data.http.myPublicIP.body)}/32"                                                                           # Default value
}

resource "aws_ecr_repository" "lambdaexe_ecr" {
  name                 = "lambdaexe_ecr"
  image_tag_mutability = "MUTABLE"
}

resource "aws_s3_bucket_public_access_block" "lambdaexe_staticpyapp_security" {
  depends_on = [module.cicd]
  bucket = module.cicd.artifact_bucket

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_db_instance" "lambdaexe_db" {
  depends_on = [module.networking]
  allocated_storage      = 5
  max_allocated_storage  = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.9"
  instance_class         = "db.t2.micro"
  name                   = "lambdaexedb"
  identifier             = "lambdaexedb"
  skip_final_snapshot    = true
  publicly_accessible    = true
  port                   = 5432
  username               = var.lambdaexe_db_user
  password               = var.lambdaexe_db_pass
  vpc_security_group_ids = [module.networking.postgres_sg]
  db_subnet_group_name   = module.networking.lambdaexe_db_subnet_group
}

resource "aws_ssm_parameter" "lambdaexe_db_user" {
  name        = "/lambdaexe/vars/lambdaexe_db_user"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.lambdaexe_db_user
}

resource "aws_ssm_parameter" "lambdaexe_db_pass" {
  name        = "/lambdaexe/vars/lambdaexe_db_pass"
  description = "Pass for the lambdaexe Postgres DB instance"
  type        = "SecureString"
  value       = var.lambdaexe_db_pass
}

resource "aws_ssm_parameter" "lambdaexe_db_instance" {
  name        = "/lambdaexe/vars/lambdaexe_db_instance"
  description = "Pass for the lambdaexe Postgres DB instance"
  type        = "SecureString"
  value       = var.lambdaexe_db_pass
}

resource "aws_ssm_parameter" "lambdaexe_db_codecommit_url" {
  name        = "/lambdaexe/vars/lambdaexe_db_codecommit_url"
  description = "Clone URL for CodeCommit repo"
  type        = "SecureString"
  value       = aws_db_instance.lambdaexe_db.address
}

module "cicd" {
  source                    = "../cicd-module"
  repo_name                 = "lambdaexe-docker-image-build"                                                             # Required
  organization_name         = "sbcvetkov"                                                                  # Required
  repo_default_branch       = "master"                                                                         # Default value
  aws_region                = "eu-central-1"                                                                      # Default value
  char_delimiter            = "-"                                                                              # Default value
  build_timeout             = "5"                                                                              # Default value
  build_compute_type        = "BUILD_GENERAL1_SMALL"                                                           # Default value
  build_image               = "aws/codebuild/standard:2.0"                                                   # Default value
  build_privileged_override = "true"                                                                           # Default value
  package_buildspec         = "buildspec.yml"                                                                  # Default value
  force_artifact_destroy    = "true"                                                                           # Default value
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "serverless-codebuild-automation-policy"
  role = module.cicd.codebuild_role_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
POLICY
}

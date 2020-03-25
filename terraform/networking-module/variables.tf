variable "aws_region" {
  description = "The AWS region to deploy into (default: us-west-2)."
  default     = "eu-central-1"
}

variable "aws_vpc_cidr" {
  description = "CIDR of deafault VPC."
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR of first subnet."
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR of second subnet."
  default     = "10.0.2.0/24"
}

variable "my_ip" {
  description = "Public IP of Terraform initiator. Default is worldwide open."
  default     = "0.0.0.0/0"
}
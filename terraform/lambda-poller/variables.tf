locals {
  local_resource_prefix = "lambda-poller"
  local_resource_suffix = terraform.workspace
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile"
}

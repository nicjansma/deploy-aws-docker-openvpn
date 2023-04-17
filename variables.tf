variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "host_name" {
  description = "DNS name to register (Route 53)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "base_image" {
  description = "AWS AMI name (use scripts/get_latest_aws_ami_id)"
  type        = string
}

variable "instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t3.nano"
}

variable "ssh_key" {
  description = "AWS SSH key file"
  type        = string
}

variable "ssh_key_name" {
  description = "AWS SSH key name"
  type        = string
}

variable "ssh_user_name" {
  description = "AWS EC2 user name"
  type        = string
}

variable "host_route_53_zone_id" {
  description = "AWS Route 53 Zone ID"
  type        = string
}

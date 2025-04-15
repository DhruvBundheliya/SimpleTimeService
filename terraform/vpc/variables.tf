variable "project" {
  type        = string
  default     = ""
  description = "Project name is used to identify resources"
}

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "A list of availability zones in the region"
}

variable "vpc_cidr" {
  default     = "0.0.0.0/16"
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
}

variable "private_subnet" {
  type        = list(string)
  default     = []
  description = "A list of private subnets for ECS inside the VPC"
}

variable "public_subnet" {
  type        = list(string)
  default     = []
  description = "A list of public subnets for LB inside the VPC"
}

variable "region" {
  default = ""
}
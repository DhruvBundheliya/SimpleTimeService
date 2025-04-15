terraform {
  backend "s3" {
    key = "vpc/vpc.tfstate"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name = "${var.project}-dev"
  cidr = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet
  enable_nat_gateway = true
  single_nat_gateway = true
  flow_log_destination_arn = "arn:aws:s3:::${var.project}-dev-vpc-flow-logs"
  flow_log_destination_type = "s3"
  flow_log_file_format = "plain-text"
  flow_log_log_format = ""
  flow_log_max_aggregation_interval = 600
  flow_log_traffic_type = "ALL"
  enable_flow_log = true
}
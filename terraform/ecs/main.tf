terraform {
  backend "s3" {
    key = "ecs/ecs.tfstate"
  }
}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  cluster_name = var.cluster_name
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 0
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = var.project
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket               = ""
    key                  = "vpc/vpc.tfstate"
    region               = ""
  }
}

data "terraform_remote_state" "aws_security_group" {
  backend = "s3"
  config = {
    bucket               = ""
    key                  = "alb/alb.tfstate"
    region               = ""
  }
}

locals {
  private_subnet_a_id = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  private_subnet_b_id = data.terraform_remote_state.vpc.outputs.private_subnets[1]
  security_group_id = data.terraform_remote_state.aws_security_group.alb_sg.security_group_id
  target_group = data.terraform_remote_state.aws_security_group.target_groups
}

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"
  name        = var.ecs_service_name
  cluster_arn = module.ecs_cluster.arn
  cpu    = var.cpu
  memory = var.memory
  container_definitions = {
    simpletimeservice = {
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      image     = var.docker_image
      port_mappings = [
        {
          name          = var.project
          containerPort = var.docker_image_port
          protocol      = "tcp"
        }
      ]
      readonly_root_filesystem = true
      enable_cloudwatch_logging = true
      memory_reservation = 100
    }
  }

  load_balancer = {
    service = {
      target_group_arn = local.target_group
      container_name   = var.project
      container_port   = var.docker_image_port
    }
  }

  subnet_ids = [local.private_subnet_a_id, local.private_subnet_b_id]
  security_group_rules = {
    alb_ingress_5000 = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = var.docker_image_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = local.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
terraform {
  backend "s3" {
    key = "alb/alb.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = ""
    key    = ""
    region = ""
  }
}

locals {
  public_subnet_a_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  public_subnet_b_id = data.terraform_remote_state.vpc.outputs.public_subnets[1]
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = var.loadbalancer_name
  vpc_id             = local.vpc_id
  subnets            = [local.public_subnet_a_id, local.public_subnet_b_id]
  security_groups    = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
  internal           = false

  tags = {
    Environment = "dev"
    Project     = var.project
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-tg"
  port        = var.docker_image_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.lb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
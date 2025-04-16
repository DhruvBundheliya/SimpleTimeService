variable "project" {
  type = string
  default = ""
  description = "The name of the project"
}

variable "docker_image_port" {
  type = string
  default = ""
  description = "Docker Image Port Number"
}

variable "loadbalancer_name" {
  type = string
  default = ""
  description = "The name of ALB"
}

variable "region" {
  default = ""
}
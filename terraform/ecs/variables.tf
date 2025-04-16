variable "project" {
  type = string
  default = ""
  description = "The name of the project"
}

variable "cluster_name" {
  type = string
  default = ""
  description = "The name of the ECS cluster"
}

variable "ecs_service_name" {
  type = string
  default = ""
  description = "The name of the ECS Service"
}

variable "cpu" {
  type = string
  default = ""
  description = "CPU of the task"
}

variable "memory" {
  type = string
  default = ""
  description = "Memory of the task"
}

variable "docker_image" {
  type = string
  default = ""
  description = "Docker image"
}

variable "docker_image_port" {
  type = string
  default = ""
  description = "Docker Image Port Number"
}

variable "region" {
  default = ""
}
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

variable "name" {
  description = "The name for Task Definition"
  type        = string
}

variable "container_name" {
  description = "The name of the Container for frontend specified in the Task definition"
  type        = string
}

variable "container_name2" {
  description = "The name of the Container for backend specified in the Task definition"
  type        = string
}

variable "execution_role_arn" {
  description = "The IAM ARN role that the ECS task will use to call other AWS services"
  type        = string
}

variable "task_role_arn" {
  description = "The IAM ARN role that the ECS task will use to call other AWS services"
  type        = string
  default     = null
}

variable "cpu" {
  description = "The CPU value to assign to the container, read AWS documentation for available values"
  type        = string
}

variable "memory" {
  description = "The MEMORY value to assign to the container, read AWS documentation to available values"
  type        = string
}

variable "frontend_image" {
  description = "The docker registry URL in which ecs will get the Docker image for frontend"
  type        = string
}

variable "backend_image" {
  description = "The docker registry URL in which ecs will get the Docker image for backend"
  type        = string
}

variable "region" {
  description = "AWS Region in which the resources will be deployed"
  type        = string
}

variable "container_port" {
  description = "The port that the container will use to listen to requests"
  type        = number
}


variable "secret_arn" {
  description = "The port that the container will use to listen to requests"
  type        = string
}
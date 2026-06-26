# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

variable "name" {
  description = "The name for the ecs service"
  type        = string
}

variable "desired_tasks" {
  description = "The minumum number of tasks to run in the service"
  type        = string
}

variable "arn_security_group" {
  description = "ARN of the security group for the tasks"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ECS cluster ID in which the resources will be created"
  type        = string
}

variable "https_front" {
  description = "The ARN of the AWS Target Group to put the ECS task"
  type        = string
}

variable "https_back" {
  description = "The ARN of the AWS Target Group to put the ECS task"
  type        = string
}

variable "arn_task_definition_back" {
  description = "The ARN of the Task Definition to use to deploy the tasks"
  type        = string
}

variable "arn_task_definition_front" {
  description = "The ARN of the Task Definition to use to deploy the tasks"
  type        = string
}

variable "subnets_id" {
  description = "Subnet ID in which ecs will deploy the tasks"
  type        = list(string)
}


variable "iam_role_ecs" {
  description = "The name of the container"
  type        = string
}

variable "frontsg" {
  type = string
}

variable "backsg" {
  type = string
}
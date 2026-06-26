# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

output "arn_task_definition_front" {
  value = aws_ecs_task_definition.frontend.arn
}

output "arn_task_definition_back" {
  value = aws_ecs_task_definition.backend.arn
}

output "task_definition_family_front" {
  value = aws_ecs_task_definition.frontend.family
}
output "task_definition_family_back" {
  value = aws_ecs_task_definition.backend.family
}
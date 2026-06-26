# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

output "front_service_name" {
  value = aws_ecs_service.frontend.name
}


output "back_service_name" {
  value = aws_ecs_service.backend.name
}
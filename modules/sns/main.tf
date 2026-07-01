# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

/*====================================================
      AWS SNS topic for deployment notifications
=====================================================*/

resource "aws_sns_topic" "deployment_alerts" {
  name = var.sns_name
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            # "token.actions.githubusercontent.com:sub" = "repo:YOUR_GITHUB_USERNAME/YOUR_REPOSITORY:*"
            "token.actions.githubusercontent.com:sub" = "repo:Level-p/Support-ticketing-app:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_deploy" {
  name = "github-actions-deploy-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.deployment_alerts.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_deploy_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_deploy.arn
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.deployment_alerts.arn
  protocol  = "email"
  endpoint  = "onojasteven13@gmail.com"
}
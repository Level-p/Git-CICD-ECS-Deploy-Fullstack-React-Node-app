locals {
  name = "practice-ecs"
}

resource "aws_secretsmanager_secret" "app_secrets" {
  name = "prac6-secrets"
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id

  secret_string = jsonencode({
    MONGO_URI  = var.MONGO_URI
    JWT_SECRET = var.JWT_SECRET
  })
}

data "aws_route53_zone" "zone" {
  name         = var.domain_name
  private_zone = false

}
#calling acm certificate

resource "aws_acm_certificate" "varsitix-acm-cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.name}-acm-cert"
  }
}

data "aws_route53_zone" "varsitix-acp-zone" {
  name         = var.domain_name
  private_zone = false
}

# Fetch DNS Validation Records for ACM Certificate
resource "aws_route53_record" "acm_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.varsitix-acm-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  # Create DNS Validation Record for ACM Certificate
  zone_id         = data.aws_route53_zone.varsitix-acp-zone.zone_id
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  depends_on      = [aws_acm_certificate.varsitix-acm-cert]
}

# Validate the ACM Certificate after DNS Record Creation
resource "aws_acm_certificate_validation" "varsitix_cert_validation" {
  certificate_arn         = aws_acm_certificate.varsitix-acm-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation_record : record.fqdn]
  depends_on              = [aws_acm_certificate.varsitix-acm-cert]
}

module "vpc" {
  source              = "./modules/vpc"
  name                = local.name
  acm_certificate_arn = aws_acm_certificate.varsitix-acm-cert.arn
}

module "alb" {
  source       = "./modules/alb"
  key_name     = module.vpc.private_key
  name         = local.name
  acm_cert_arn = aws_acm_certificate.varsitix-acm-cert.arn
  public_subnets = [
    module.vpc.public_subnet_ids["pub2"],
    module.vpc.public_subnet_ids["pub3"]
  ]
  domain = var.domain_name
  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source = "./modules/ecr"
}

module "autoscale" {
  source       = "./modules/ecs/Autoscaling"
  max_capacity = 5
  min_capacity = 1
  cluster_name = module.cluster.ecs_cluster_name
  frontend_service_name = module.service.front_service_name
  backend_service_name = module.service.back_service_name
}

module "cluster" {
  source = "./modules/ecs/Cluster"
  name   = "${local.name}-cluster"
}

module "service" {
  source = "./modules/ecs/Service"
  subnets_id = [
    module.vpc.private_subnet_ids["pri3"],
    module.vpc.private_subnet_ids["pri3"]
  ]
  ecs_cluster_id      = module.cluster.ecs_cluster_id
  https_back = module.alb.back_arn_target_group
  https_front = module.alb.front_arn_target_group
  name                = "${local.name}-service"
  iam_role_ecs = module.iam.ecs_task_role_arn
  desired_tasks       = 1
  arn_security_group  = module.vpc.sgout
  arn_task_definition_back = module.task_definition.arn_task_definition_back
  arn_task_definition_front = module.task_definition.arn_task_definition_front
  frontsg = module.alb.front_sg_id
  backsg = module.alb.back_sg_id
}

module "task_definition" {
  source             = "./modules/ecs/TaskDefinition"
  cpu                = 2048
  memory             = 4096
  region             = "eu-west-2"
  frontend_image =   module.ecr.ecr_repository_url_frontend
  container_port     = 3000
  container_name     = "appContainer1"
  name               = "${local.name}-task-def"
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  backend_image = module.ecr.ecr_repository_url_backend
  container_name2 = "appContainer2"
  secret_arn = aws_secretsmanager_secret.app_secrets.arn
}

module "iam" {
  source = "./modules/iam"
  secrets_arn = aws_secretsmanager_secret.app_secrets.arn
}


variable "domain_name" {
  default = "mfon21.space"
}

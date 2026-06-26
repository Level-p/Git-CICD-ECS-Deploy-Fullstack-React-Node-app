output "ecr_repository_url_front" {
  value = module.ecr.ecr_repository_url_frontend
}

output "ecr_repository_url_back" {
  value = module.ecr.ecr_repository_url_backend
}

output "ecs_cluster_name" {
 value = module.cluster.ecs_cluster_name
}

output "ecs_service_front" {
    value = module.service.front_service_name
}
output "ecs_service_back" {
    value = module.service.back_service_name
}
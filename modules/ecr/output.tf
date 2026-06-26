output "ecr_repository_url_frontend" {
    value = aws_ecr_repository.frontend.repository_url
}

output "ecr_repository_arn_frontend" {
    value = aws_ecr_repository.frontend.arn
}

output "ecr_repository_url_backend" {
    value = aws_ecr_repository.backend.repository_url
}

output "ecr_repository_arn_backend" {
    value = aws_ecr_repository.backend.arn
}
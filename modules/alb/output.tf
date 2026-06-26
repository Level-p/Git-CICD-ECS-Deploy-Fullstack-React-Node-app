output "prod-sg" {
  value       = aws_security_group.alb_sg.id
  description = "Security group ID for the prod environment"
}

output "laravel_dns" {
  value = aws_lb.app_lb.dns_name
}

output "front_arn_target_group" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "back_arn_target_group" {
  value = aws_lb_target_group.backend_tg.arn
}

output "front_sg_id" {
  value = aws_security_group.frontend_sg.id
}

output "back_sg_id" {
  value = aws_security_group.backend_sg.id
}
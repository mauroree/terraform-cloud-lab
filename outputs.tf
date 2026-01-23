output "alb_dns_name" {
  description = "DNS público do Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

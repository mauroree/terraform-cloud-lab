resource "aws_cloudwatch_log_group" "cloud_init" {
  name              = "/ec2/cloud-init-${var.environment}"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "syslog" {
  name              = "/ec2/syslog-${var.environment}"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "/ec2/docker-${var.environment}"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ec2/app-${var.environment}"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "cloud_init" {
  name              = "/ec2/cloud-init"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "syslog" {
  name              = "/ec2/syslog"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "/ec2/docker"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ec2/app"
  retention_in_days = 3
}

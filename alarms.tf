resource "aws_cloudwatch_metric_alarm" "tg_unhealthy_hosts" {
  alarm_name          = "tg-unhealthy-hosts-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    TargetGroup  = aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "Dispara quando existe pelo menos um target unhealthy no ALB"
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "asg-cpu-high-${var.environment}"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "Dispara quando CPU média do ASG fica acima de 80% por 10 minutos"
}

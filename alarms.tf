resource "aws_cloudwatch_metric_alarm" "tg_unhealthy_hosts" {
  alarm_name          = "tg-unhealthy-hosts-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    TargetGroup  = aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "Dispara quando pelo menos um target do ALB fica unhealthy. Verificar health check, containers Docker e logs em /ec2/app."

}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "asg-cpu-high-${var.environment}"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "Dispara quando CPU média do ASG fica acima de 80% por 10 minutos"
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "alb-5xx-errors-${var.environment}"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "Dispara quando o backend retorna erro 5xx. Impacto direto ao usuário. Verificar logs em /ec2/app e status dos containers."
}

resource "aws_cloudwatch_metric_alarm" "alb_elb_5xx" {
  alarm_name          = "alb-elb-5xx-${var.environment}"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "Erro 5xx gerado pelo ALB. Indica ausência de targets healthy ou falha grave de infraestrutura."
}



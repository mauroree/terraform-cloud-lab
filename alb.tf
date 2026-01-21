resource "aws_security_group" "alb_sg" {
  name = "alb-sg-${var.environment}"
  description = "Security Group do Application Load Balancer"

  ingress {
    description = "HTTP Publico"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_alb" {
  name               = "app-alb-${var.environment}"
  load_balancer_type = "application"
  internal           = false

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = data.aws_subnets.default.ids
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

    default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

}

data "aws_vpc" "default" {
  default = true
}

resource "aws_lb_target_group" "app_tg" {
  name = "app-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id  = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_lb" "webapp_lb" {
  name               = "webapp-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = [for subnet in module.public_subnet.public_subnets : subnet.id]
  security_groups    = [aws_security_group.load_balancer_sg.id]

  tags = {
    Name = "webapp-lb"
  }
}

resource "aws_lb_target_group" "webapp_lb_tg" {
  name = "webapp-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200-299"
    path                = "/healthz"
    port                = 3000
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.webapp_lb.arn
  port              = "80"

  default_action {
    target_group_arn = aws_lb_target_group.webapp_lb_tg.arn
    type             = "forward"
  }
}
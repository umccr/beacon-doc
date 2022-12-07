#######
# Application Load Balancer / Reverse Proxy

resource "aws_lb" "beacon_compose_alb" {
  name               = "${local.stack_name_dash}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.beacon_compose_alb_sg.id]
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.beacon_compose_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.beacon_compose_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.domain_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [aws_lb_target_group.app]
}

resource "aws_lb_target_group" "app" {
  name        = "${local.stack_name_dash}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "beacon_compose_instance_attachment" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = module.beacon_compose_instance.private_ip  # using Private IP for hibernation support
  port             = 8080
}

resource "aws_security_group" "beacon_compose_alb_sg" {
  name        = "${local.stack_name_dash}-alb-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_lb_target_group" "app_tg" {
  name        = "demo-tg"
  port        = 80
  vpc_id      = var.vpc
  protocol    = "HTTP"

  health_check {
    path = "/"
  }
}

resource "aws_lb" "app_elb" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.subnet_list

  tags = {
    Name = "demo-lb"
  }
}

resource "aws_autoscaling_attachment" "app_ag_attach" {
  autoscaling_group_name = var.auto_scaling_group_name
  lb_target_group_arn = aws_lb_target_group.app_tg.arn
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
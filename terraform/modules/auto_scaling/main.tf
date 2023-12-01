resource "aws_key_pair" "test_key_pair" {
  key_name   = "demo1-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_launch_template" "amazon_linux" {
  name_prefix          = "demo1-tpl"
  image_id             = var.linux_ami_id
  instance_type        = "t2.micro"
  key_name = aws_key_pair.test_key_pair.key_name
  # security_group_names = [aws_security_group.public_sg.id]

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group]
  }

  iam_instance_profile {
    arn = "arn:aws:iam::932782693588:instance-profile/CodeDeployDemo-EC2-Instance-Profile"
  }

  user_data = filebase64(var.userdata_path)
}

resource "aws_autoscaling_group" "demo1_ag" {
  name                 = "demo1-ag"
  desired_capacity     = 1
  min_size             = 1
  max_size             = 1
  health_check_type    = "EC2"
  vpc_zone_identifier  = [var.subnet_1,var.subnet_2]
  termination_policies = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.amazon_linux.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "test_policy" {
  name                   = "test-policy"
  autoscaling_group_name = aws_autoscaling_group.demo1_ag.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.test_policy.arn]
  alarm_name          = "test_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo1_ag.id
  }
}
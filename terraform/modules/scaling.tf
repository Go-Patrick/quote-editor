resource "aws_key_pair" "test_key_pair" {
  key_name   = "demo1-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_launch_template" "amazon_linux" {
  name_prefix          = "demo1-tpl"
  image_id             = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  key_name = aws_key_pair.test_key_pair.key_name
  # security_group_names = [aws_security_group.public_sg.id]

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.public_sg.id]
  }

  user_data = filebase64("modules/userdata.tpl")
}

resource "aws_autoscaling_group" "demo1_ag" {
  name                 = "demo1-ag"
  desired_capacity     = 1
  min_size             = 1
  max_size             = 1
  health_check_type    = "EC2"
  vpc_zone_identifier  = [aws_subnet.public_1.id, aws_subnet.public_2.id]
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
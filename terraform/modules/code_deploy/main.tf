resource "aws_codedeploy_app" "deploy" {
  name = "quote-editor"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name              = aws_codedeploy_app.deploy.name
  deployment_group_name = "quote-group"
  service_role_arn      = var.code_deploy_role_arn

  autoscaling_groups = [var.auto_scaling_group_id]

  deployment_config_name = "CodeDeployDefault.OneAtATime"
}

# Define SNS Topic
resource "aws_sns_topic" "deployment_notifications" {
  name = "DeploymentNotifications"
}

# Define CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "deployment_alarm" {
  alarm_name          = "DeploymentStatusAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DeploymentStatus"
  namespace           = "AWS/CodeDeploy"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Alarm for AWS CodeDeploy deployment status"

  dimensions = {
    DeploymentGroupName = aws_codedeploy_deployment_group.example.deployment_group_name
    ApplicationName     = aws_codedeploy_app.deploy.name
  }

  alarm_actions = [aws_sns_topic.deployment_notifications.arn]
}


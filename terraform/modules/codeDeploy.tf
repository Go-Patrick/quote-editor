resource "aws_codedeploy_app" "deploy" {
  name = "quote-editor"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name              = aws_codedeploy_app.deploy.name
  deployment_group_name = "quote-group"
  service_role_arn      = var.code_deploy_role_arn

  autoscaling_groups = [aws_autoscaling_group.demo1_ag.id]

  deployment_config_name = "CodeDeployDefault.OneAtATime"
}
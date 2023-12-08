resource "aws_codedeploy_app" "deploy" {
  name = "quote-editor-${terraform.workspace}"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name              = aws_codedeploy_app.deploy.name
  deployment_group_name = "quote-group-${terraform.workspace}"
  service_role_arn      = var.code_deploy_role_arn

  autoscaling_groups = [var.auto_scaling_group_id]

  deployment_config_name = "CodeDeployDefault.OneAtATime"
}


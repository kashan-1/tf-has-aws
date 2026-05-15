data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "this" {}


data "aws_ami" "amazon_linux" {

  most_recent = true
  name_regex  = "^amzn2*"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_secretsmanager_secret" "ms_secrets" {
  arn = module.db.db_instance_master_user_secret_arn
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.ms_secrets.id
}


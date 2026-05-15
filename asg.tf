module "wp-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 9.2.1"

  name                      = "${var.prefix}-${var.environment}-asg"
  instance_name             = "${var.prefix}-${var.environment}-web"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = 0

  health_check_type   = "ELB"
  vpc_zone_identifier = module.vpc.public_subnets

  # Launch Template
  launch_template_name        = "${var.prefix}-${var.environment}-lt"
  launch_template_description = var.asg_launch_template_description
  update_default_version      = true

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.asg_instance_type
  key_name      = module.key_pair.key_pair_name

  # Correct way to attach ALB target group in v9+
  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = module.alb.target_groups["app"].arn
      traffic_source_type       = "elbv2"
    }
  }

  user_data = base64encode(
    templatefile("${path.module}/wp-init8.sh", {
      vars = {
        rds_endpoint = module.db.db_instance_endpoint
        rds_password = data.aws_secretsmanager_secret_version.secret_version.secret_string
      }
    })
  )

  network_interfaces = [
    {
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups             = [module.ssh_sg.security_group_id]
      associate_public_ip_address = true
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = var.tags
    }
  ]

  tags = var.tags
}
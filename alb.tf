# #|<----------------------------------------------------------------------------------
### ALB Module code
# #|---------------------------------------------------------------------------------->

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 10.5.0"

  name               = "${var.prefix}-${var.environment}-alb"
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.http_sg.security_group_id]
  internal        = false

  # ----------------------------
  # Target Groups
  # ----------------------------
  target_groups = {
    app = {
      name_prefix      = "h1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"

      health_check = {
        enabled             = true
        interval            = 120
        path                = "/"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 20
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  # ----------------------------
  # Listeners 
  # ----------------------------
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      default_action = {
        type = "redirect"

        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
    }

    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.certificate_arn

      default_action = {
        type             = "forward"
        target_group_key = "app"
      }
    }
  }

  tags = var.tags
}
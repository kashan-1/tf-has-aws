module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = ">= 3.0.0"

  key_name           = "key_pair"
  create_private_key = true
}


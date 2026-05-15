variable "tags" {
  description = "AWS Tags to add to all resources created"
  type        = map(any)
  default = {
    app         = "wordpress",
    created-by  = "terraform"
    environment = "dev"
    name        = "kashan-ali"
    project     = ""
    owner       = "kashan1dev@gmail.com"
    creator     = "kashan1dev@gmail.com"
    team        = "devops"
  }
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

variable "prefix" {
  description = "Prefix for all the resources to be created. Please note thst 2 allows only lowercase alphanumeric characters and hyphen"
  type        = string
  default     = "wordpress"
}

variable "environment" {
  description = "Name of the application environment. Current is dev (other are(for easiness): e.g. dev, prod, test, staging)"
  type        = string
  default     = "dev"
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "database_subnets_cidrs" {
  description = "List of CIDR blocks for db subnets"
  type        = list(string)
  default     = ["10.0.200.0/24", "10.0.201.0/24"]
}

# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|

#|<----------------------------------------------------------------------------------
# ASG Variables Portion
#|---------------------------------------------------------------------------------->

variable "asg_instance_type" {
  description = "AutoScaling Group Instance type"
  type        = string
  default     = "t3.micro"
}
variable "asg_launch_template_description" {
  description = "AutoScaling Group launch template description"
  type        = string
  default     = "Wordpress Launch Template"
}

variable "asg_min_size" {
  description = "AutoScaling Group Min Size "
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "AutoScaling Group Max Size "
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "AutoScaling Group Desired Capacity"
  type        = number
  default     = 1
}

#|<----------------------------------------------------------------------------------
# RDS Variables Portion
#|---------------------------------------------------------------------------------->
variable "rds_engine" { //variable for RDS engine name -> my case -> mysql(others are mariadb etc)
  description = "RDS engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" { //variable for RDS engine version 
  description = "RDS engine version"
  type        = string
  default     = "8.0.32"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
variable "rds_username" { //variable for RDS username
  description = "RDS Username"
  type        = string
  default     = "admin"
}

variable "rds_db_name" { //variable for RDS database name
  description = "RDS Database Name"
  default     = "wpdb"
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|


variable "certificate_arn" {
  description = "This variable is use to store arn of cerficate used for HTTPS"
  type        = string
  default     = "wp-cer"
}


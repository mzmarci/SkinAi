# ALB variables
variable "alb_name" {
  description = "The name of the ALB"
  default = "skinai-alb"
  type        = string
}

variable "alb_security_group_ids" {
  description = "Security group IDs for the ALB"
  type        = list(string)
}

variable "public_subnets_id" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

# Target group variables
variable "target_group_name" {
  description = "The name of the ALB target group"
  type        = string
}

variable "target_group_port" {
  description = "Port on which the target group listens"
  type        = number
  default     = 80
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of successful health checks before considering an instance healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of failed health checks before considering an instance unhealthy"
  type        = number
  default     = 3
}

# Listener variables
variable "listener_port" {
  description = "Port on which ALB listener listens"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for ALB listener"
  type        = string
  default     = "HTTP"
}

# EC2 variables
variable "ec2_ami" {
  description = "AMI for EC2 instances"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "ec2_key_name" {
  description = "EC2 key name"
  type        = string
}

variable "ec2_security_group_ids" {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}

# Auto Scaling variables
variable "private_subnets_id" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of instances in ASG"
  type        = number
  default     = 2
}

variable "health_check_grace_period" {
  description = "Grace period for ASG health checks (seconds)"
  type        = number
  default     = 300
}

variable "instance_tag_name" {
  description = "Tag for instances created by the ASG"
  type        = string
}

# Auto Scaling scaling policies
variable "scale_up_adjustment" {
  description = "Scaling adjustment for scaling up"
  type        = number
  default     = 1
}

variable "scale_down_adjustment" {
  description = "Scaling adjustment for scaling down"
  type        = number
  default     = -1
}

variable "scale_cooldown" {
  description = "Cooldown period between scaling actions (seconds)"
  type        = number
  default     = 300
}

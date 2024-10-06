# Create the Application Load Balancer
resource "aws_lb" "skinai-app_lb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_group_ids
  subnets            = var.public_subnets_id

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

# Create a target group for the EC2 instances
resource "aws_lb_target_group" "skinai-app_tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Name = var.target_group_name
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.skinai-app_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.skinai-app_tg.arn
  }
}

# Create a launch configuration for the Auto Scaling Group
resource "aws_launch_configuration" "skinai-app_launch_config" {
  name          = "${var.alb_name}-launch-configuration"
  image_id      = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_key_name

  security_groups = var.ec2_security_group_ids
  //user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }


}

# Create the Auto Scaling Group
resource "aws_autoscaling_group" "skinai-app_asg" {
  launch_configuration = aws_launch_configuration.skinai-app_launch_config.id
  vpc_zone_identifier  = var.private_subnets_id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  target_group_arns    = [aws_lb_target_group.skinai-app_tg.arn]

  health_check_type         = "EC2"
  health_check_grace_period = var.health_check_grace_period

  tag {
    key                 = "Name"
    value               = var.instance_tag_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scaling policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_cooldown
  autoscaling_group_name = aws_autoscaling_group.skinai-app_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_cooldown
  autoscaling_group_name = aws_autoscaling_group.skinai-app_asg.name
}

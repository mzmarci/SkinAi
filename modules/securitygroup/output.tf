output "skinai_security_group_id" {
  value =  aws_security_group.skinai_security_group.id
}

output "alb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}
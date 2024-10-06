output "SkinAi_ip" {
  value = [for instance in aws_instance.skinai : instance.public_ip]
}
resource "aws_instance" "skinai" {
  count                       = var.instance_count
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = element(var.public_subnets_id, count.index)
  associate_public_ip_address = true
  user_data                   = var.user_data

  tags = {
    Name = "Skinscan"
    Unit = "PROD"
  }
}

  # Create an Elastic IP and associate it with the corresponding EC2 instance
resource "aws_eip" "ec2_eip" {
  count = var.instance_count

  vpc = true

  instance = aws_instance.skinai[count.index].id

  tags = {
    Name = "EIP-${count.index + 1}"
  }

}

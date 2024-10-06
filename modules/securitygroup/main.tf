locals {
  ports = [443, 80, 5000, 22, 8080]
}

resource "aws_security_group" "skinai_security_group" {
  name        = "skinai_security_group"
  description = "Allow SSH, HTTP, and other connections"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "Allow traffic on port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allowing traffic from anywhere
    }
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to any IP
  }

  tags = {
    Name = "skinai"
  }
}

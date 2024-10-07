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

resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  description = "Allow SSH and HTTP Connection"
  vpc_id      = var.vpc_id
  tags = {
    Name = "skin-test"
  }
}

resource "aws_security_group_rule" "lb-igress-rule" {
  security_group_id        = aws_security_group.lb_security_group.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_security_group.id
}

resource "aws_security_group_rule" "lb-igress-rule1" {
  security_group_id        = aws_security_group.lb_security_group.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_security_group.id

}

resource "aws_security_group_rule" "lb-egress-rule" {
  security_group_id = aws_security_group.lb_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "web_security_group" {
  name        = "web_security_group"
  description = "Allow SSH and HTTP Connection"
  vpc_id      = var.vpc_id

  tags = {
    Name = "skin-Web"
  }
}
// source_security_group_id =   aws_security_group.baston.id
resource "aws_security_group_rule" "web-igress-rule" {
  security_group_id        = aws_security_group.web_security_group.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  self                     = true # Allows traffic from instances with the same security group
}

resource "aws_security_group_rule" "web-egress-rule" {
  security_group_id = aws_security_group.web_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

}
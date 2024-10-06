variable "ec2_ami" {
  description = "this is a variable to manage ec2_ami type"
  type        = string
  default     = "ami-0a7abae115fc0f825"
}

variable "ec2_instance_type" {
  description = "this is a variable to manage ec2_instance_type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_key_name" {
  description = "this is a variable to manage ec2_key_name"
  type        = string
  default     = "test100"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}
variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR values"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "instance_count" {
  description = "The number of EC2 instances to create"
  type        = number
  default     = 2
}
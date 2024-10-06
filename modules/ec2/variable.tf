variable "ec2_ami" {
  description = "this is a variable to manage ec2_ami type"
  type        = string
  //default     = "ami-0a7abae115fc0f825"
}

variable "ec2_key_name" {
  description = "this is a variable to manage ec2_key_name"
  type        = string
  //default     = "test100"
}

variable "ec2_instance_type" {
  description = "this is a variable to manage ec2_instance_type"
  type        = string
 // default     = "t2.micro"

}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = ""
}


variable "public_subnets_id" {}

variable "vpc_security_group_ids" {
  type = list(string)  
  description = "List of security group IDs to assign to the instance"
}


variable "instance_count" {
  description = "The number of EC2 instances to create"
  type        = number
  default     = 2
}

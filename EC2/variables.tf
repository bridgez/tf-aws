variable "AWS_ACCESS_KEY_ID" {
  description = "Value of the AWS_ACCESS_KEY_ID."
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Value of the AWS_SECRET_ACCESS_KEY."
  type        = string
}

variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "AppServer"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t3.micro"
}

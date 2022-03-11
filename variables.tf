variable "environment" {
  description = "in which environment resources are created"
  type        = string
  default = "production"
}

variable "number_of_instances" {
  description = "number of instances"
  type        = number
  default     = 1
}

variable "number_of_nics" {
  description = "number of network interfaces"
  type        = number
  default     = 1
}


variable "ami" {
  
  type        = string
  default     = "ami-07fb45b963bedd1e1" # Suse linux distro // eu-west-3 - Paris DC
}

#variable "ami" {
#    type = "map"
#    description = "Amazon machine image to use for ec2 instance, free-tier only"
#    default {
#        amazon = "ami-08cfb7b19d5cd546d"
#        suse = "ami-07fb45b963bedd1e1"
#        redhat = "ami-08755c4342fb5aede"
#        debian = "ami-04e905a52ec8010b2"
#    }
#}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "home_ip" {
    description = "my own home ip address"
    type        = string
    default     = "51.154.203.242/32"
}


variable "public_key" {
    description = "public key to ssh into ec2 web server instance"
    type = string
}
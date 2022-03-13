variable "environment" {
  description = "in which environment resources are created"
  type        = string
  default     = "production"
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

  type    = string
  default = "ami-08cfb7b19d5cd546d" # LUNX 2
}

# variable "ami" {
#    type = "map"
#    description = "Amazon machine image to use for ec2 instance, free-tier only"
#    default {
#        amazon = "ami-08cfb7b19d5cd546d"
#        suse = "ami-07fb45b963bedd1e1"
#        redhat = "ami-08755c4342fb5aede"
#        debian = "ami-04e905a52ec8010b2"
#    }
# }

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

variable "key_name" {
  type    = string
  default = "ec2-bastion-key"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = ""
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAqDuWPf0vXTnfiVfnH4LRSy0SAHLlTs1l63/CUpwvOZmZ85cFSIwANZc1gJuIWFz8b8ldhS+z9D+9Q8h+cZcbPL8gdmYZ407TkjLIvdfsWaf9yglJHCxZOYBTPK/0fTdhQOvELaZMqlagfHoYW0n3S/aTIB7+MQKfHFsLoWLPzdHBTcnRTX0DtvFyhvoex7xqfBYaMIPL+HUCgwjvt8HxM32giQz/ZcIuu3OvBCCMVajvuAFRZa7G+Nx+LefHXlZJxj+z2rq1u6a8UsfDmeOUWHGZblaAJHBfWtWEgRtC+0kVBVJFD8c8WdXlYUDFz2ZsdrVd5Bb5SUDcLo4sGQCXEvdT9dFP0KUaQiEDPzkB0QgYCBV2+O9ld8LpD6Fwewdorz+j4NlZAq0AUsDrDUMUO9UwCCCUBUnONwYvXToljs0DZekRC7Lr1sRseMlZRQUSYufUwoFXrzrNdbLAtf4ii4bPPvoHWdRLaVHpEk/pwmUa7Ts888GNmNP5nYnqod5+dpS3p4kkOqazoBa7Tc6lNlMjKmx9R6ehf578Fl1vtOy4GTp4Bf/6/qR6DCGZJLiDs5xhpHEs1a9LuGFsgEXjaru5oSSaY23p5FUa7LOxxi66ajhhCrB/Gt0Z6gq6WtSRdQkBwmq/Npbos3TNK7qtoKonTPlNlTtqvwXF2xgycQ== utilisateur@DESKTOP-LLABBE"
}

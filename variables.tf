variable "instance_type" {
    description = "Webserver EC2 instance type"
    type = string
    default = "t2.micro"
}

variable "ami_id" {
    description = "AMI ID for webserver EC2 instances"
    type = string
    default = "ami-0230bd60aa48260c6"
}

variable "key_pair" {
    description = "Key pair for webserver EC2 instances"
    type = string
    default = "IaCLabKP"
}

variable "instance1_name" {
    description = "Webserver instance 1"
    type = string
}

variable "instance2_name" {
    description = "Webserver instance 2"
    type = string
}

variable "db_username" {
    description = "Database admin user"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "Database admin user password"
    type = string
    sensitive = true
}
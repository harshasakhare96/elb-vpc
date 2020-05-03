variable "vpc_cidr" {
default = "10.0.0.0/16"
}


variable "public_cidr_1" {
default = "10.0.2.0/24"
}

variable "public_cidr_2" {
default = "10.0.4.0/24"
}

variable "private_cidr_1" {
default = "10.0.1.0/24"
}

variable "private_cidr_2" {
default = "10.0.3.0/24"
}

variable "accessip" {
default = "0.0.0.0/0"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}


variable "vpc_cidr" {
default = "10.0.0.0/16"
}


variable "public_cidr_1" {
default = "10.0.2.0/24"
}

variable "public_cidr_2" {
default = "10.0.4.0/24"
}

variable "private_cidr_1" {
default = "10.0.1.0/24"
}

variable "private_cidr_2" {
default = "10.0.3.0/24"
}

variable "accessip" {
default = "0.0.0.0/0"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}
  
  
  variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
  }
}


variable "identifier" {
  default     = "mydb-rds"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "mysql"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.22"
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "mydb"
  description = "db name"
}


variable "username" {
  default     = "myuser"
  description = "User name"
}

variable "password" {
  default = "hellothereworld!"
  description = "password"
}


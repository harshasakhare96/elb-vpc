data "aws_availability_zones" "available" {
state = "available"
}

resource "aws_vpc" "tf_vpc" {
cidr_block = "${var.vpc_cidr}"
enable_dns_hostnames = true
enable_dns_support   = true
tags = {
    Name = "tf_vpc"
  }
}


resource "aws_internet_gateway" "tf_gw" {
vpc_id = "${aws_vpc.tf_vpc.id}"
tags = {
Name = "tf_igw"
 }

}



resource "aws_route_table" "tf_public_rt" {
vpc_id = "${aws_vpc.tf_vpc.id}"
route {
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.tf_gw.id}"
}
tags =  {
Name = "tf_public_rt"
}

}


resource "aws_eip" "tf_eip" {
vpc =true

}




resource "aws_subnet" "tf_public_subnet_1" {
    vpc_id = "${ aws_vpc.tf_vpc.id }"
    cidr_block = "${ var.public_cidr_1}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {

  Name = "tf_public_1"

   }

}



resource "aws_subnet" "tf_public_subnet_2" {
vpc_id = "${ aws_vpc.tf_vpc.id }"
cidr_block = "${ var.public_cidr_2}"
map_public_ip_on_launch = true
availability_zone = "${data.aws_availability_zones.available.names[1]}"
tags = {
Name = "tf_public_2"

 }
}

resource "aws_subnet" "tf_private_subnet_1" {
vpc_id = "${ aws_vpc.tf_vpc.id }"
cidr_block = "${ var.private_cidr_1}"
map_public_ip_on_launch = false
availability_zone = "${data.aws_availability_zones.available.names[0]}"
tags = {
Name = "tf_private_1"

}

}



resource "aws_subnet" "tf_private_subnet_2" {
vpc_id = "${ aws_vpc.tf_vpc.id }"
cidr_block = "${ var.private_cidr_2}"
map_public_ip_on_launch = false
availability_zone = "${data.aws_availability_zones.available.names[1]}"
tags = {
Name = "tf_private_2"
}

}



resource "aws_route_table_association" "tf_public_assoc_1" {
subnet_id = "${ aws_subnet.tf_public_subnet_1.id}"
route_table_id = "${ aws_route_table.tf_public_rt.id}"

}

resource "aws_route_table_association" "tf_public_assoc_2" {
subnet_id = "${ aws_subnet.tf_public_subnet_2.id}"
route_table_id = "${ aws_route_table.tf_public_rt.id}"

}



resource "aws_nat_gateway" "tf_nat_gateway" {
allocation_id = "${ aws_eip.tf_eip.id }"
subnet_id = "${ aws_subnet.tf_public_subnet_1.id }"
tags = {
Name = "gw NAT"

}

}


resource "aws_default_route_table" "tf_private_rt" {
default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"

route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = "${ aws_nat_gateway.tf_nat_gateway.id}"
}
tags = {
Name = "tf_private_rt"
}

}





resource "aws_route_table_association" "tf_private_assoc_1" {
subnet_id = "${ aws_subnet.tf_private_subnet_1.id }"
route_table_id = "${ aws_default_route_table.tf_private_rt.id }"
}



resource "aws_route_table_association" "tf_private_assoc_2" {
subnet_id = "${ aws_subnet.tf_private_subnet_2.id }"
route_table_id = "${ aws_default_route_table.tf_private_rt.id }"
}



resource "aws_security_group" "tf_public_sg" {
name = "tf_public_sg"
description = " used for access for the public instance"
vpc_id = "${aws_vpc.tf_vpc.id}"

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["${var.accessip}"]
}

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["${var.accessip}"]

}


ingress {
from_port = 3306
to_port = 3306
protocol = "tcp"
cidr_blocks = ["${var.accessip}"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks =  ["0.0.0.0/0"]
}
}





resource "aws_elb" "web" {
  name = "example-elb"


  subnets = ["${aws_subnet.tf_public_subnet_1.id}"]

  security_groups = ["${aws_security_group.tf_public_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }



  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}



resource "aws_instance" "web" {
  instance_type = "t2.micro"

  ami = "${lookup(var.aws_amis, var.aws_region)}"

  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.tf_public_sg.id}"]
  subnet_id              = "${aws_subnet.tf_public_subnet_1.id}"
  user_data              = "${file("userdata.sh")}"

  tags= {
    Name = "elb-example"
  }
}

resource "aws_db_instance" "default" {
  depends_on             = ["aws_security_group.tf_public_sg"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.tf_public_sg.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
}

resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${aws_subnet.tf_private_subnet_1.id}", "${aws_subnet.tf_private_subnet_2.id}"]
}

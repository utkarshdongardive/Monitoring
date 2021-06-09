provider "aws" {
	region = "ap-south-1"
}

#creating a security group and allowing ssh & http

resource "aws_security_group" "terraform-ssh-http" {
	name = "terraform-ssh-http"
	description = "allowing ssh and http traffic"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#creating aws ec2 instance

resource "aws_instance" "terraform-instance" {
	ami = "ami-5b673c34"
	instance_type = "t2.micro"
	availability_zone = "ap-south-1b"
	security_groups = ["${aws_security_group.terraform-ssh-http.name}"]
	key_name = ""
	user_data = <<-EOF
		#! /bin/bash
		sudo yum install httpd -y
		sudo systemctl start httpd
		sudo systemctl enable httpd
		echo "<h1>DHIP web server deployed through TERRAFORM<br>L&T Infotech</h1>" >> /var/www/html/index.html
	EOF

	tags = {
		Name = "webserver"
	}
}

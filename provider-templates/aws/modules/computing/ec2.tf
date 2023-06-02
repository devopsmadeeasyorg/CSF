################################################  Computing components  #########################
resource "aws_instance" "bastionhost" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${var.lb-subnet1}"
associate_public_ip_address = true
vpc_security_group_ids = ["${var.bastion-sg}"]
key_name = "${var.mykp}"
user_data = "${var.userdata}"
#key_name = "mikp"
#root_block_device {
#  volume_type = "standard"
#  volume_size = "9"
#  delete_on_termination = "true"
#  }
tags = {
Name = "bastionhost"
}
}

################################################  Computing components  #########################
resource "aws_instance" "webapp-server-1" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${var.webapp-subnet1}"
vpc_security_group_ids = ["${var.webapp-sg}"]
key_name = "${var.mykp}"
tags = {
Name = "webapp-server-1"
}
}

resource "aws_instance" "webapp-server-2" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${var.webapp-subnet2}"
vpc_security_group_ids = ["${var.webapp-sg}"]
key_name = "${var.mykp}"
ebs_block_device {
  device_name = "/dev/xvde"
  volume_type = "gp2"
  volume_size = "10"
  }
tags = {
Name = "webapp-server-2"
}
}

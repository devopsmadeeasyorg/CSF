################################################  Computing components  #########################
resource "aws_instance" "bastionhost" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${aws_subnet.public_subnet2.id}"
associate_public_ip_address = true
vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
key_name = aws_key_pair.mykp.id
# user_data = "${var.userdata}"
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
resource "aws_instance" "webapp_server_1" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${aws_subnet.private_subnet1.id}"
vpc_security_group_ids = ["${aws_security_group.webapp_sg.id}"]
key_name = aws_key_pair.mykp.id
tags = {
Name = "webapp-server-1"
}
}

resource "aws_instance" "webapp_server_2" {
ami = "${var.myami}"
instance_type = "t2.medium"
subnet_id = "${aws_subnet.private_subnet1.id}"
vpc_security_group_ids = ["${aws_security_group.webapp_sg.id}"]
key_name = aws_key_pair.mykp.id
ebs_block_device {
  device_name = "/dev/xvde"
  volume_type = "gp2"
  volume_size = "10"
  }
tags = {
Name = "webapp-server-2"
}
}

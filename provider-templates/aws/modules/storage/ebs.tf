################################################  Storage modules #####################################
resource "aws_ebs_volume" "myebs" {
availability_zone = "us-east-1a"
size = "11"
}

resource "aws_volume_attachment" "vattach"{
device_name = "/dev/xvdf"
volume_id = "${aws_ebs_volume.myebs.id}"
instance_id = "${var.webapp-server-1}"
}
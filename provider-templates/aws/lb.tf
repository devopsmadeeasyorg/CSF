resource "aws_elb" "elb_server" {
  name               = "ELB"
 # availability_zones = ["us-east-1a", "us-east-1b"]
  subnets = ["${aws_subnet.public_subnet1.id}", "${aws_subnet.public_subnet2.id}"]
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 4
    target              = "TCP:8000"
    interval            = 5
  }
security_groups = ["${aws_security_group.elb_sg.id}"]
  instances                   = ["${aws_instance.webapp_server_1.id}","${aws_instance.webapp_server_2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "ELB"
  }
}
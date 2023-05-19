resource "aws_lb" "elb-server" {
  name               = "elb-server"
  internal           = false
  load_balancer_type = "application"
  #availability_zones = ["us-east-1a", "us-east-1b"]
  subnets = ["${var.lb-subnet1}", "${var.lb-subnet2}"]
  security_groups = ["${var.bastion-sg}"]
  # instances       = ["${aws_instance.webapp-server-1.id}","${aws_instance.webapp-server-2.id}"]
  # listener {
  #   instance_port     = 5001
  #   instance_protocol = "http"
  #   lb_port           = 80
  #   lb_protocol       = "http"
  # }

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 3
  #   timeout             = 4
  #   target              = "TCP:5001"
  #   interval            = 5
  # }
  # cross_zone_load_balancing   = true
  # idle_timeout                = 400
  # connection_draining         = true
  # connection_draining_timeout = 400
  tags = {
    Name = "elb-server"
  }
}

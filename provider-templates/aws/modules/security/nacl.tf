
############################################## NACL rules ########################
resource "aws_network_acl" "bastion-nacl" {
  vpc_id = "${var.myvpc}"
  subnet_ids = ["${var.lb-subnet1}"]

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
   
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    
  }
  tags = {
    Name = "bastion-nacl"
  }
}


resource "aws_network_acl" "webapp-nacl" {
  vpc_id = "${var.myvpc}"
  subnet_ids = ["${var.webapp-subnet1}"]

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
   
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    
  }
  tags = {
    Name = "webapp-nacl"
  }
}


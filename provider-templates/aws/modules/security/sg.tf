
##############################################  Security Groups ########################
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Allow only for 22 port"
  vpc_id = "${var.myvpc}"
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["183.83.37.44/32"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["183.83.37.44/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-sg"
  }
}




resource "aws_security_group" "webapp-sg" {
  name        = "webapp-sg"
  description = "Allow only for 22 port"
  vpc_id = "${var.myvpc}"
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion-sg.id}"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion-sg.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "webapp-sg"
  }
}

##############################################  Security group for rds instance ########################
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow all traffic"
  vpc_id ="${var.myvpc}"
  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db-sg"
  }
}
##############################################  kay pair ########################
resource "aws_key_pair" "mykp" {
  key_name   = "mykpair"
  public_key = "${var.mypublickey}"
}

##############################################  Security Groups ########################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow only for 22 port"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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




resource "aws_security_group" "webapp_sg" {
  name        = "webapp-sg"
  description = "Allow only for 22 port"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = ["${aws_security_group.bastion-sg.id}"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    # security_groups = ["${aws_security_group.bastion-sg.id}"]
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

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow only for 22 port"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
############### VPC creation ##############
resource "aws_vpc" "myvpc"{
cidr_block = "${var.mycidr}"
tags ={
Name = "myvpc"
}
}

resource "aws_internet_gateway" "myigw"{
vpc_id = "${aws_vpc.myvpc.id}"
tags={
Name = "myigw"
}
}

resource "aws_eip" "ngweip"{
vpc = true
}

resource "aws_nat_gateway" "myngw" {
  allocation_id = "${aws_eip.ngweip.id}"
  subnet_id     = "${aws_subnet.lb-subnet2.id}"
  tags = {
    Name = "myngw"
  }
}
############################################ LB Subnets ###############################
resource "aws_subnet" "lb-subnet1"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.10.0/24"
availability_zone = "us-east-1a"
tags={
Name = "lb-subnet1"
}
}

resource "aws_subnet" "lb-subnet2"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.20.0/24"
availability_zone = "us-east-1b"
tags={
Name = "lb-subnet2"
}
}

resource "aws_route_table" "lb-rtb"{
vpc_id = "${aws_vpc.myvpc.id}"
tags = {
Name = "lb-rtb"
}
}

resource "aws_route" "publicrt"{
route_table_id = "${aws_route_table.lb-rtb.id}"
destination_cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.myigw.id}"
}
 
resource "aws_route_table_association" "lbrtba1"{
route_table_id = "${aws_route_table.lb-rtb.id}"
subnet_id = "${aws_subnet.lb-subnet1.id}"
}

resource "aws_route_table_association" "lbrtba2"{
route_table_id = "${aws_route_table.lb-rtb.id}"
subnet_id = "${aws_subnet.lb-subnet2.id}"
}

############################################ webapp Subnets ###############################3
resource "aws_subnet" "webapp-subnet1"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.30.0/24"
availability_zone = "us-east-1a"
tags={
Name = "webapp-subnet1"
}
}

resource "aws_subnet" "webapp-subnet2"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.40.0/24"
availability_zone = "us-east-1b"
tags={
Name = "webapp-subnet2"
}
}

resource "aws_route_table" "webapp-rtb"{
vpc_id = "${aws_vpc.myvpc.id}"
tags = {
Name = "webapp-rtb"
}
}

resource "aws_route" "webapp-rt"{
route_table_id = "${aws_route_table.webapp-rtb.id}"
destination_cidr_block = "0.0.0.0/0"
nat_gateway_id = "${aws_nat_gateway.myngw.id}"
}

resource "aws_route_table_association" "webapp-rtba1"{
route_table_id = "${aws_route_table.webapp-rtb.id}"
subnet_id = "${aws_subnet.webapp-subnet1.id}"
}

resource "aws_route_table_association" "webapp-rtba2"{
route_table_id = "${aws_route_table.webapp-rtb.id}"
subnet_id = "${aws_subnet.webapp-subnet2.id}"
}


####################################### AWS RDS DB subnet group ##############################


resource "aws_subnet" "db-subnet1" {
  vpc_id       = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.50.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "db-subnet1"
  }
}

resource "aws_subnet" "db-subnet2" {
  vpc_id       = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.60.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "db-subnet2"
  }
}

resource "aws_route_table" "db-rtb"{
vpc_id = "${aws_vpc.myvpc.id}"
tags = {
Name = "db-rtb"
}
}

resource "aws_route" "dbcrt"{
route_table_id = "${aws_route_table.db-rtb.id}"
destination_cidr_block = "0.0.0.0/0"
nat_gateway_id = "${aws_nat_gateway.myngw.id}"
}
 
resource "aws_route_table_association" "dbrtba1"{
route_table_id = "${aws_route_table.db-rtb.id}"
subnet_id = "${aws_subnet.db-subnet1.id}"
}

resource "aws_route_table_association" "dbrtba2"{
route_table_id = "${aws_route_table.db-rtb.id}"
subnet_id = "${aws_subnet.db-subnet2.id}"
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = ["${aws_subnet.db-subnet1.id}","${aws_subnet.db-subnet2.id}"]
  tags = {
    Name = "My DB subnet group"
  }
}

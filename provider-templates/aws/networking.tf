############### VPC creation ##############
resource "aws_vpc" "myvpc"{
cidr_block = "${var.mycidr}"
tags ={
Name = "myvpc"
}
}

####### IGW ################3
resource "aws_internet_gateway" "myigw"{
vpc_id = "${aws_vpc.myvpc.id}"
tags={
Name = "myigw"
}
}

###### NAT Gateway ###############
resource "aws_eip" "ngweip"{
vpc = true
}

resource "aws_nat_gateway" "myngw" {
  allocation_id = "${aws_eip.ngweip.id}"
  subnet_id     = "${aws_subnet.public_subnet1.id}"
  tags = {
    Name = "myngw"
  }
}
############################################ public Subnets ###############################
resource "aws_subnet" "public_subnet1"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.10.0/24"
availability_zone = "us-east-1a"
tags={
Name = "public-subnet1"
}
}

resource "aws_subnet" "public_subnet2"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.20.0/24"
availability_zone = "us-east-1b"
tags={
Name = "public-subnet2"
}
}

resource "aws_route_table" "public_rtb"{
vpc_id = "${aws_vpc.myvpc.id}"
tags = {
Name = "public-rtb"
}
}

resource "aws_route" "publicrt"{
route_table_id = "${aws_route_table.public_rtb.id}"
destination_cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.myigw.id}"
}
 
resource "aws_route_table_association" "publicrtba1"{
route_table_id = "${aws_route_table.public_rtb.id}"
subnet_id = "${aws_subnet.public_subnet1.id}"
}

resource "aws_route_table_association" "publicrtba2"{
route_table_id = "${aws_route_table.public_rtb.id}"
subnet_id = "${aws_subnet.public_subnet2.id}"
}

############################################ Private Subnets ###############################3
resource "aws_subnet" "private_subnet1"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.30.0/24"
availability_zone = "us-east-1a"
tags={
Name = "private-subnet1"
}
}

resource "aws_subnet" "private_subnet2"{
vpc_id = "${aws_vpc.myvpc.id}"
cidr_block = "10.0.40.0/24"
availability_zone = "us-east-1b"
tags={
Name = "private-subnet2"
}
}

resource "aws_route_table" "private_rtb"{
vpc_id = "${aws_vpc.myvpc.id}"
tags = {
Name = "private-rtb"
}
}

resource "aws_route" "private_rt"{
route_table_id = "${aws_route_table.private_rtb.id}"
destination_cidr_block = "0.0.0.0/0"
nat_gateway_id = "${aws_nat_gateway.myngw.id}"
}

resource "aws_route_table_association" "private_rtba1"{
route_table_id = "${aws_route_table.private_rtb.id}"
subnet_id = "${aws_subnet.private_subnet1.id}"
}

resource "aws_route_table_association" "private_rtba2"{
route_table_id = "${aws_route_table.private_rtb.id}"
subnet_id = "${aws_subnet.private_subnet2.id}"
}



output "myaccount" {
  value = "${aws_vpc.myvpc.owner_id}"
}

output "myvpc" {
  value = "${aws_vpc.myvpc.id}"
}

output "public-subnet2" {
  value = "${aws_subnet.public-subnet2.id}"
}

output "public-subnet1" {
  value = "${aws_subnet.public-subnet1.id}"
}

output "private-subnet1" {
  value = "${aws_subnet.private-subnet1.id}"
}

output "private-subnet2" {
  value = "${aws_subnet.private-subnet2.id}"
}

output "db-subnet-group" {
value = "${aws_db_subnet_group.db-subnet-group.id}"
}

output "myaccount" {
  value = "${aws_vpc.myvpc.owner_id}"
}

output "myvpc" {
  value = "${aws_vpc.myvpc.id}"
}

output "lb-subnet2" {
  value = "${aws_subnet.lb-subnet2.id}"
}

output "lb-subnet1" {
  value = "${aws_subnet.lb-subnet1.id}"
}

output "webapp-subnet1" {
  value = "${aws_subnet.webapp-subnet1.id}"
}

output "webapp-subnet2" {
  value = "${aws_subnet.webapp-subnet2.id}"
}

output "db-subnet-group" {
value = "${aws_db_subnet_group.db-subnet-group.id}"
}

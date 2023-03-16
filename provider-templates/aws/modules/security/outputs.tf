output "mykp" {
  value = "${aws_key_pair.mykp.id}"
}

output "bastion-sg" {
  value = "${aws_security_group.bastion-sg.id}"
}

output "webapp-sg" {
  value = "${aws_security_group.webapp-sg.id}"
}

output "db-sg" {
value = "${aws_security_group.db-sg.id}"
}

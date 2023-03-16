output "bastionhostnic" {
  value = "${aws_instance.bastionhost.primary_network_interface_id}"
}

output "bastionhost_public_ip" {
  value = "${aws_instance.bastionhost.public_ip}"
}

output "webapp-server-1" {
value = "${aws_instance.webapp-server-1.id}"
}

output "elb_dns_name" {
value = "${aws_elb.elb-server.dns_name}"
}

output "lambdaarn" {
value = "${aws_lambda_function.test_lambda.arn}"
}
output "elb_dns_name" {
value = "${aws_elb.elb_server.dns_name}"
}

output "bastionhost_public_ip" {
  value = "ssh -A centos@${aws_instance.bastionhost.public_ip}"
}

output "bastionhost_public_ip" {
  value = "ssh -A centos@${aws_instance.bastionhost.public_ip}"
}



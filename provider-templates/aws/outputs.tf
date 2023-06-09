output "elb_dns_name" {
value = "${aws_elb.elb_server.dns_name}"
}

output "bastionhost_public_ip" {
  value = "eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A centos@${aws_instance.bastionhost.public_ip}"
}

output "login_to_webapp-server-1" {
  value = "ssh centos${aws_instance.webapp_server_1.private_ip}"
}




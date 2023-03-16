
##############################################  kay pair ########################
resource "aws_key_pair" "mykp" {
  key_name   = "mykp"
  public_key = "${var.mypublickey}"
}


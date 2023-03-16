################################################  Cloud init module  ####################################
provider "template"{

}
data "template_file" "mysqlscript" {
  template = "${file("${path.module}/userdata.tpl")}"
}
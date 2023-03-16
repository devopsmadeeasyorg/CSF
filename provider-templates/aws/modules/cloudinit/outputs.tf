output "userdata" {
value = "${data.template_file.mysqlscript.rendered}"
}
# resource "google_sql_database_instance" "master" {
# deletion_protection = false
# name = "mydb4"
# database_version = "MYSQL_5_7"
# region = "us-west2"
# settings {
# tier = "db-n1-standard-2"
#  ip_configuration {
#     dynamic authorized_networks {
#         for_each = google_compute_instance.appservers
#         iterator = appservers
#             content {
#                 name = "myinternet"
#                 value = "0.0.0.0/0"
#             }
# }
#     }
# }
# }
# resource "google_sql_database" "database" {
# name = "cloudstones"
# instance = "${google_sql_database_instance.master.name}"
# charset = "utf8"
# collation = "utf8_general_ci"
# }
# resource "google_sql_user" "users" {
# name = "cloud"
# instance = "${google_sql_database_instance.master.name}"
# host = "%"
# password = "Stones_123"
# } 

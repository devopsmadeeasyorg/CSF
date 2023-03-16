resource "aws_db_instance" "mysqldb" {
#  count = "${var.rds_mysql_db["recover"] ? 0 : 1}"
  identifier           = "mysqldb9"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name                 = "cloudstones"
  username             = "cloud"
  password             = "Stones_123"
  db_subnet_group_name = "${var.db-subnet-group}"
  vpc_security_group_ids = ["${var.db-sg}"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
#  tags={
#  Name = "mydb"
#  }
}

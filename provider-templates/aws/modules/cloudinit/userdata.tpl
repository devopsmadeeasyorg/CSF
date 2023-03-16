#cloud-config
repo_update: true
repo_upgrade: all
write_files:
- path: /home/centos/hardening.sh
  permissions: '0777'
  owner: centos:centos
  content: |
    #!/bin/sh
    touch /home/centos/testing.txt
    mkdir python
    sudo yum install python3-pip -y
    sudo pip3 install pymysql -t python
write_files:
- path: /home/centos/mysql.py
  permissions: '0777'
  owner: centos:centos
  content: |
  import pymysql
  host = 'mysqldb9.c07sujkvnfl6.us-east-1.rds.amazonaws.com'
  user = 'cloud'
  password = ''
  database = 'cloudstones'
  connection = pymysql.connect(host=host, user=user, password = password, database = database)
  with connection:
      cur = connection.cursor()
      query1 = "CREATE TABLE student ( id int NOT NULL AUTO_INCREMENT, first_name varchar(255) DEFAULT NULL, last_name varchar(255) DEFAULT NULL, email_id varchar(255) DEFAULT NULL, PRIMARY KEY (id) ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
      query2 = "INSERT INTO student VALUES (1,'krishna','maram','krishnamaram2@gmail.com');"
      query3 = "INSERT INTO student VALUES (10,'krishna','maram','krishnamaram2@gmail.com');"
      cur.execute(query1)
      cur.execute(query2)
      cur.execute(query3)
      cur.connection.commit()
      cur.execute("SELECT * FROM student")
      version = cur.fetchall()
      print(version)   
runcmd:
 #- [ sh, /home/centos/testing.sh ]
 #- [ python, /home/centos/mysql.py ]
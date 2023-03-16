# !/usr/bin/env python
# -*- coding: utf-8 -*-
import pymysql

host = ''
user = ''
password = ''
database = ''

connection = pymysql.connect(host=host, user=user, password = password, database = database)
with connection:
    cur = connection.cursor()
    query1 = "CREATE TABLE student ( id int NOT NULL AUTO_INCREMENT, first_name varchar(255) DEFAULT NULL, last_name varchar(255) DEFAULT NULL, email_id varchar(255) DEFAULT NULL, PRIMARY KEY (id) ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    query2 = "INSERT INTO student VALUES (1,'krishna','maram','krishnamaram2@gmail.com');"
    query3 = "INSERT INTO student VALUES (10,'krishna','maram','krishnamaram2@gmail.com');"
    l = cur.execute("SELECT * FROM student")
    print(l)
    if l:
        cur.execute("drop table student")
    cur.execute(query1)
    cur.execute(query2)
    cur.execute(query3)
    cur.connection.commit()
    cur.execute("SELECT * FROM student")
    version = cur.fetchall()
    print(version)
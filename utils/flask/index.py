from flask import Flask, request, render_template
from flask_mysqldb import MySQL
application = Flask(__name__)

#configure db
application.config['MYSQL_HOST'] = 'mysqldb.c07sujkvnfl6.us-east-1.rds.amazonaws.com'
application.config['MYSQL_USER'] = 'cloud'
application.config['MYSQL_PASSWORD'] = 'Stones_123'
application.config['MYSQL_DB'] = 'cloudstones'
mysql = MySQL(application)

@application.route('/')
def selectdata():
       cur = mysql.connection.cursor()
       cur.execute('select * from student')
       data = cur.fetchall()
       return render_template('index.html', msg=data)
if __name__ == '__main__':
    application.run(port=5001)



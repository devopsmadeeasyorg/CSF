import mysql.connector
import datetime
import time

def mysql_connect():
    # Establish a connection to the MySQL database
    db_con = mysql.connector.connect(
        host="localhost",
        user="ot39",
        password="NT27",
        database="bible"
    )
    return db_con

def create_table():
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    # Execute a SELECT query
    query = '''CREATE TABLE csit_clusters(
                cluster_id VARCHAR(255) PRIMARY KEY,
                cluster_status VARCHAR(255),
                cloud_provider VARCHAR(50)
                );
                '''
    table = db_session.execute(query)
    print("Table created successfully", table)

def alter_table():
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    # Execute a SELECT query
    alter_table_query = '''ALTER TABLE csit_clusters
                ADD COLUMN start_datetime TIMESTAMP(0),
                ADD COLUMN completion_datetime TIMESTAMP(0)
                ;
                '''
    alter_table = db_session.execute(alter_table_query)
    print("Table altered successfully", alter_table)

def insert_cluster_info(cluster_data):
    payload = {
        "cluster_id": cluster_data['cluster_id'],
        "cluster_status": "PROVISIONING",
        "cloud_provider": "aws"
    }
    fields = list(payload.keys())
    values = list(payload.values())
    fields = ",".join(item for item in fields)
    values = ",".join("\'" + str(item) + "\'" if type(item) == str else str(item) for item in values)
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    insert_query = f"insert into bible.csit_clusters({fields}) values ({values});"
    print(insert_query)
    db_session.execute(insert_query)
    db_con.commit()

def update_cluster_status_before_provision(cluster_data):
    start_provision_datetime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    update_query = f"update bible.csit_clusters set cluster_status='PROVISIONING', start_datetime= '{start_provision_datetime}' where cluster_id='{cluster_data['cluster_id']}'"
    print(update_query)
    db_session.execute(update_query)
    db_con.commit()

def update_cluster_status_after_provision(cluster_data):
    completion_provision_datetime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    update_query = f"update bible.csit_clusters set cluster_status='PROVISIONED', completion_datetime= '{completion_provision_datetime}' where cluster_id='{cluster_data['cluster_id']}'"
    print(update_query)
    db_session.execute(update_query)
    db_con.commit()

def update_cluster_status_before_deprovision(cluster_data):
    
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    update_query = f"update bible.csit_clusters set cluster_status='DEPROVISIONING' where cluster_id='csit-linux-001'"
    print(update_query)
    db_session.execute(update_query)
    db_con.commit()

def update_cluster_status_after_deprovision(cluster_data):
    
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    update_query = f"update bible.csit_clusters set cluster_status='DEPROVISIONED' where cluster_id='csit-linux-001'"
    print(update_query)
    db_session.execute(update_query)
    db_con.commit()

def retrieve_clusters_info():
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    # Execute a SELECT query
    query = "SELECT * FROM csit_clusters"
    db_session.execute(query)

    # Fetch all records from the result set
    records = db_session.fetchall()
    import time
    print("records", records)
    print("type(records)", type(records))
    print("\n \n ")
    time.sleep(5)
    # Process the fetched records
    i = 1
    for record in records:
        # Access individual columns using indexing or column names
        print(f"record{i}", record)
        print("type(record)", type(record))
        print("\n")
        i += 1
        time.sleep(5)
        column1 = record[0]
        column2 = record[1]
        # ... continue accessing other columns as needed
        # print(column1, column2)

def mysql_close():
    db_con = mysql_connect()
    # Create a cursor to interact with the database
    db_session = db_con.cursor()
    # Close the cursor and database connection
    db_session.close()
    db_con.close()

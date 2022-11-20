import psycopg2
# Update connection string information

#[!INCLUDE [!INCLUDE [applies-to-postgresql-flexible-server](../includes/applies-to-postgresql-flexible-server.md)]
host = "shamboo.postgres.database.azure.com"
dbname = "postgres"
user = "kremowka"
password = "Shamboo-2137"
sslmode = "require"
# Construct connection string

#[!INCLUDE [!INCLUDE [applies-to-postgresql-flexible-server](../includes/applies-to-postgresql-flexible-server.md)]
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
print("Connection established")
cursor = conn.cursor()
# Fetch all rows from table

#[!INCLUDE [!INCLUDE [applies-to-postgresql-flexible-server](../includes/applies-to-postgresql-flexible-server.md)]
cursor.execute("SELECT * FROM inventory;")
rows = cursor.fetchall()
# Print all rows

#[!INCLUDE [!INCLUDE [applies-to-postgresql-flexible-server](../includes/applies-to-postgresql-flexible-server.md)]
for row in rows:
    print("Data row = (%s, %s, %s)" %(str(row[0]), str(row[1]), str(row[2])))
# Cleanup

#[!INCLUDE [!INCLUDE [applies-to-postgresql-flexible-server](../includes/applies-to-postgresql-flexible-server.md)]
conn.commit()
cursor.close()
conn.close()
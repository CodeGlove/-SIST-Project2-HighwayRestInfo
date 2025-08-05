import mysql.connector

#Mysql 연결
conn = mysql.connector.connect(
    host = "restinfo-db-instance.c50u4mqy2h6b.ap-northeast-2.rds.amazonaws.com",
    user = "admin",
    password = "gbrpthwjdqh",
    database = "my_app_db",
    charset = "utf8"
    )

cursor = conn.cursor()

#휴게소 이름 조회

cursor.execute("select SAname from ServiceArea")

ServiceArea = [row[0] for row in cursor.fetchall()]

print(ServiceArea)
for name in ServiceArea:
    print("-", name)

cursor.close()
conn.close()

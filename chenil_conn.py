import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(
    database="chenil_v4",
    host=os.getenv("HOST"),
    user=os.getenv("POSTGRES_USER"),
    password=os.getenv("POSTGRES_PASSWORD"),
    port=os.getenv("PORT")
)

cur = conn.cursor()
cur.execute("SELECT * FROM Chiens LIMIT 10;")

rows = cur.fetchall()
for row in rows:
    print(row)

cur.close()
conn.close()
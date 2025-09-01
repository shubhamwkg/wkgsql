import pandas as pd
from sqlalchemy import create_engine

user = "postgres"
password = "Bull%40123"
host = "localhost"  # Use 'localhost' if connecting from your Mac, or the container name if connecting from another container
port = "54661"       # Default PostgreSQL port, change if mapped differently
dbname = "pan_numbers"

conn_string = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"
engine = create_engine(conn_string)

db = create_engine(conn_string)
conn = db.connect()

files = ['pan_numbers']

for file in files:
    df = pd.read_csv(f"/Users/shubhamwkg/Desktop/wkg/data/projects/wkgsql/datasets/pan_numbers/dataset/{file}.csv")
    df.to_sql(file, con=conn, if_exists="replace", index=False)
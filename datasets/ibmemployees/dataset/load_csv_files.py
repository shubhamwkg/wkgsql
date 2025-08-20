import pandas as pd
from sqlalchemy import create_engine

user = "postgres"
password = "Bull%40123"
host = "localhost"  
port = "54661"       
dbname = "postgres"

conn_string = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"
engine = create_engine(conn_string)

db = create_engine(conn_string)
conn = db.connect()

files = ['attrition']

for file in files:
    df = pd.read_csv(f"/Users/shubhamwkg/Desktop/wkg/data/projects/wkgsql/datasets/ibmemployees/dataset/{file}.csv")
    df.to_sql(file, con=conn, if_exists="replace", index=False)
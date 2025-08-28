import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import os

# Database connection parameters
user = "postgres"
password = "Bull@123"
host = "localhost"
port = "54661"
dbname = "adventurework"

# URL encode password (handles @, etc.)
encoded_password = quote_plus(password)

# Create connection string
conn_string = f"postgresql://{user}:{encoded_password}@{host}:{port}/{dbname}"
engine = create_engine(conn_string)

# Folder where CSVs are stored
base_path = "/Users/shubhamwkg/Desktop/wkg/data/projects/wkgsql/datasets/adventureworks/dataset"

# All tables to load (table_name : csv_filename)
files = {
    "product": "product.csv",
    "region": "region.csv",
    "reseller": "reseller.csv",
    "sales": "sales.csv",
    "salesperson": "salesperson.csv",
    "salespersonregion": "salespersonregion.csv",
    "targets": "targets.csv",
    "employee": "employee.csv",
    "employee_dept_hist": "employee_dept_hist.csv",
    "department": "department.csv",
    "specialoffer": "specialoffer.csv",
    "specialofferproduct": "specialofferproduct.csv",
    "salesorderdetail": "salesorderdetail.csv",
    "billofmaterials": "billofmaterials.csv",
}

# Load CSVs into Postgres
for table, filename in files.items():
    filepath = os.path.join(base_path, filename)
    try:
        print(f"Loading {filename} into table {table}...")
        df = pd.read_csv(filepath)
        df.to_sql(table, con=engine, if_exists="replace", index=False)
        print(f"✓ Successfully loaded {table} ({len(df)} rows)")
    except Exception as e:
        print(f"✗ Error loading {filename}: {e}")

print("✅ Database loading complete!")

engine.dispose()


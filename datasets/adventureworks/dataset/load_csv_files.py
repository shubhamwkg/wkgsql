import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import os

# Database connection parameters
user = "postgres"
password = "Bull@123"   # Original password
host = "localhost"
port = "54661"
dbname = "adventurework"

# URL encode the password (important for @ or special chars)
encoded_password = quote_plus(password)

# Create connection string
conn_string = f"postgresql://{user}:{encoded_password}@{host}:{port}/{dbname}"
engine = create_engine(conn_string)

# Folder where your clean CSVs are stored
base_path = "/Users/shubhamwkg/Desktop/wkg/data/projects/wkgsql/datasets/adventureworks/dataset"

# File list (matching the cleaned names we generated)
files = {
    "product": "product.csv",
    "region": "region.csv",
    "reseller": "reseller.csv",
    "sales": "sales.csv",
    "salesperson": "salesperson.csv",
    "salespersonregion": "salespersonregion.csv",
    "targets": "targets.csv"
}

# Load CSV files into database
for table, filename in files.items():
    filepath = os.path.join(base_path, filename)
    try:
        print(f"Loading {filename} into table {table}...")
        df = pd.read_csv(filepath)
        
        # Write into Postgres (replace if exists)
        df.to_sql(table, con=engine, if_exists="replace", index=False)
        
        print(f"✓ Successfully loaded {table} ({len(df)} rows)")
    except FileNotFoundError:
        print(f"✗ File {filename} not found at {filepath}")
    except pd.errors.ParserError as e:
        print(f"✗ Error parsing {filename}: {e}")
    except Exception as e:
        print(f"✗ Unexpected error for {filename}: {e}")

print("✅ Database loading complete!")

# Close connection
engine.dispose()

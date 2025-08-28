import pandas as pd
import os

base_path = "/Users/shubhamwkg/Desktop/wkg/data/projects/wkgsql/datasets/adventureworks/dataset"

files = {
    "employee": "employee.csv",
    "employee_dept_hist": "employee_dept_hist.csv",
    "department": "department.csv",
    "specialoffer": "specialoffer.csv",
    "specialofferproduct": "specialofferproduct.csv",
    "salesorderdetail": "salesorderdetail.csv",
    "billofmaterials": "billofmaterials.csv",
}

headers_map = {
    "employee": [
        "businessentityid", "nationalidnumber", "loginid", "organizationnode", "organizationlevel",
        "jobtitle", "birthdate", "maritalstatus", "gender", "hiredate", "salariedflag",
        "vacationhours", "sickleavehours", "currentflag", "rowguid", "modifieddate"
    ],
    "employee_dept_hist": [
        "businessentityid", "departmentid", "shiftid", "startdate", "enddate", "modifieddate"
    ],
    "department": [
        "departmentid", "name", "groupname", "modifieddate"
    ],
    "specialoffer": [
        "specialofferid", "description", "discountpct", "type", "category",
        "startdate", "enddate", "minqty", "maxqty", "rowguid", "modifieddate"
    ],
    "specialofferproduct": [
        "specialofferid", "productid", "rowguid", "modifieddate"
    ],
    "salesorderdetail": [
        "salesorderid", "salesorderdetailid", "carriertrackingnumber", "orderqty",
        "productid", "specialofferid", "unitprice", "unitpricediscount",
        "linetotal", "rowguid", "modifieddate"
    ],
    "billofmaterials": [
        "billofmaterialsid", "productassemblyid", "componentid",
        "startdate", "enddate", "unitmeasurecode",
        "bomlevel", "perassemblyqty", "modifieddate"
    ],
}

for table, filename in files.items():
    try:
        filepath = os.path.join(base_path, filename)

        # Employee may contain BOM or odd encoding
        if table == "employee":
            df = pd.read_csv(filepath, sep=",", header=None, encoding="utf-8-sig")
        else:
            df = pd.read_csv(filepath, sep=",", header=None, encoding="utf-8")

        # Assign correct headers
        df.columns = headers_map[table]

        # Overwrite the same file
        df.to_csv(filepath, index=False)

        print(f"✓ Fixed headers in {filename}")

    except Exception as e:
        print(f"✗ Error processing {filename}: {e}")

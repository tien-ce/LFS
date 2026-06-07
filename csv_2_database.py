import os
import csv
import pymysql
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Establish database connection
try:
    mydb = pymysql.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USR"),
        password=os.getenv("DB_PWD"),
        database=os.getenv("DB_NAME")  # Ensure your DB name is defined
    )
    cursor = mydb.cursor()
except pymysql.Error as err:
    print(sys.exit(f"Database connection failed: {err}"))

# SQL query for inserting data
insert_query = """
INSERT INTO packages (name, version, url, MD5, downloaded, installed)
VALUES (%s, %s, %s, %s, %s, %s)
"""

csv_file_path = "packages.csv"

if not os.path.exists(csv_file_path):
    print(f"Error: {csv_file_path} not found.")
    cursor.close()
    mydb.close()
    exit(1)

try:
    with open(csv_file_path, mode='r', encoding='utf-8') as file:
        csv_reader = csv.reader(file)
        
        # Prepare list for batch insertion
        data_to_insert = []
        for row in csv_reader:
            if len(row) < 4:
                continue  # Skip malformed rows
            
            name = row[0]
            version = row[1]
            url = row[2]
            md5 = row[3]
            
            # Append row data along with 'NO', 'NO' for downloaded and installed
            data_to_insert.append((name, version, url, md5, "NO", "NO"))
        
        # Execute batch insertion for efficiency
        if data_to_insert:
            cursor.executemany(insert_query, data_to_insert)
            mydb.commit()
            print(f"Successfully inserted {cursor.rowcount} packages into the database.")
        else:
            print("No valid data found in CSV file.")

except Exception as e:
    mydb.rollback()
    print(f"An error occurred during insertion: {e}")

finally:
    cursor.close()
    mydb.close()

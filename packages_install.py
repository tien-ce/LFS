import pymysql
import os
import sys
import subprocess
from dotenv import load_dotenv

def install_package(chapter, package_name):
    try:
        subprocess.run(["./packages_install.sh", chapter,package_name], check = True)
        return True
    except subprocess.CalledProcessError as e:
        print (f"Script failed with exit code {e.returncode}")
        return False

# sys.argv[0] is always the script name itself
script_name		= sys.argv[0]
chapter			= sys.argv[1]	
package_name	= sys.argv[2]

load_dotenv()
mydb = pymysql.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USR"),
    password=os.getenv("DB_PWD"),
    database=os.getenv("DB_NAME")  
)

# Read download and install state
my_cursor = mydb.cursor()
chapter_table = f"Chapter{chapter}"

# Use f-string for table names/identifiers, but %s for values
sql = f"SELECT packages.downloaded, {chapter_table}.installed \
       FROM packages \
       JOIN {chapter_table} \
       ON packages.name = {chapter_table}.package_name \
       WHERE packages.name = %s"

my_cursor.execute(sql, (package_name,))
result = my_cursor.fetchone()
if result == None:
    print (f"Package {package_name} is not appear in data base, please check again package name")
else:
    downloaded,installed = result 
    print (f"Downloaded {downloaded}, Installed {installed}")
    if downloaded == "NO":
        print (f"Package {package_name} still haven't downloaded")
    elif installed == "YES":
        print (f"Package {package_name} is already installed, ignore")
    else:
        # Call to download script
        if install_package(chapter,package_name):
            sql = f"UPDATE {chapter_table} SET installed = 'YES' WHERE package_name = %s"
            my_cursor.execute(sql, (package_name,))
            mydb.commit()
            print (f"Updated {chapter_table}, package {package_name} to installed")
        else:
            print (f"Install package {package_name} in {chapter_table} failed")

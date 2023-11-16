import os
import mysql.connector
from dotenv import load_dotenv
import argparse
import subprocess
import re
import time

# Function to print all existing MySQL databases
def list_mysql_databases(host, user, password):
    try:
        conn = mysql.connector.connect(
            host=host,
            user=user,
            password=password
        )

        cursor = conn.cursor()

        # Get a list of all existing databases
        cursor.execute("SHOW DATABASES")
        databases = cursor.fetchall()

        print("Existing MySQL databases:")
        for db in databases:
            print(db[0])
        print("=========================")
    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            
# Function to create the MySQL database if it doesn't exist
def create_mysql_database(host, user, password, db_name, drop_existing):
    try:
        conn = mysql.connector.connect(
            host=host,
            user=user,
            password=password
        )

        cursor = conn.cursor()

        # Check if the database already exists
        cursor.execute(f"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{db_name}'")
        database_exists = cursor.fetchone()

        if database_exists:
            if drop_existing:
                # Drop the existing database if drop_existing is True
                cursor.execute(f"DROP DATABASE {db_name}")
                print(f"Database '{db_name}' dropped.")
            else:
                print(f"Database '{db_name}' already exists.")
                return

        # Create the database
        cursor.execute(f"CREATE DATABASE {db_name}")
        print(f"Database '{db_name}' created successfully.")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def execute_mysql_restore(sql_file, host, db_name, user, password):
    # Compose the command
    command = f'gunzip -c {sql_file} | mysql -h{host} -u{user} -p{password} {db_name}'
    try:
        # Execute the command
        subprocess.run(command, shell=True, check=True)
        print(f"Restored SQL file {sql_file} to database {db_name} successfully!")

    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")


# Function to run SQL files listed in a text file on the specified database
def run_sql_files_from_list(host, user, password, db_name, sql_list_file):
    def run_mysql(host, user, password, sql_file):
        command = f"mysql -h{host} -u{user} -p{password} {db_name} < {sql_file}"
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")
        
    try:
        # Get the directory path of the sql_list_file
        sql_list_dir = os.path.dirname(sql_list_file)
        # Read the list of SQL files from the text file
        with open(sql_list_file, "r") as list_file:
            sql_files = list_file.read().splitlines()

        if not sql_files:
            print(f"No SQL files found in the list file: {sql_list_file}")
            return

        # Iterate through the SQL files and execute them
        for sql_file_name in sql_files:
            sql_file_path = os.path.join(sql_list_dir,sql_file_name)
            if not os.path.isfile(sql_file_path):
                print(f"SQL file not found: {sql_file_path}")
                continue

            with open(sql_file_path, "r") as sql_file_content:
                print(f"Executing file: {sql_file_path}")
                sql_script = sql_file_content.read()
                # Replace "irida" with the new database name
                sql_script = re.sub(r'\birida\b', db_name, sql_script, flags=re.IGNORECASE)
                sql_tmp = "sql.tmp"
                with open(sql_tmp, "w") as sql_file:
                    sql_file.writelines(sql_script)
                
                # Execute migration
                run_mysql(host, user, password, sql_tmp)
                os.remove(sql_tmp)

                print(f"Executed SQL file: {sql_file_path}")
                # Consume and close the cursor to avoid "Commands out of sync" error
            
    except mysql.connector.Error as err:
        print(f"Error: {err}")
     
def main():
    # Load environment variables from .env file
    load_dotenv()

    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Migrate IRIDA database")
    parser.add_argument("--db", required=True, help="Name of the database to create")
    parser.add_argument("--sql_file", required=False, help="SQL file to be restored")
    parser.add_argument("--drop", action="store_true", help="Drop the existing database before creating")
    parser.add_argument("--sql_list_file", required=False, help="Path to the text file containing a list of SQL files")
    args = parser.parse_args()

    # Get MySQL credentials from environment variables loaded via dotenv
    host = os.getenv("MYSQL_HOST")
    user = os.getenv("MYSQL_USER")
    password = os.getenv("MYSQL_PASSWORD")
    
    # Call the function to list existing databases
    list_mysql_databases(host, user, password)
    
    # Call the function to create the database
    create_mysql_database(host, user, password, args.db, args.drop)
    
    if (args.sql_file is not None):
        start_time = time.time()  # Record the start time
        execute_mysql_restore(args.sql_file, host, args.db, user, password)
        end_time = time.time()
        elapsed_time = end_time - start_time
        elapsed_time_minutes = elapsed_time / 60.0
        print(f"Execution time: {elapsed_time_minutes:.2f} minutes")
    else:
        print("No sql backup was provided so restore process is skipped.")
        
    # Call the function to run SQL files from the specified list file
    if (args.sql_list_file is not None):
        run_sql_files_from_list(host, user, password, args.db, args.sql_list_file)
    else:
        print("No changeset file list was provided. Skip updating the changeset of IRIDA!")
    
if __name__ == "__main__":
    # Execute the main function
    main()

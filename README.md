## What?
Upgrading [IRIDA](https://irida.ca/) version by version is a straightforward process. However, if you happen to have a rather old version, let's say 19.09, and you now wish to upgrade to 23.10, it can become quite tedious to follow these steps: stop Tomcat, replace the WAR file, start Tomcat, and wait for IRIDA to execute the database schema update. Alternatively, if you prefer to avoid this lengthy process, you can directly migrate the database schema between two significantly different versions by simply running a few SQL files. This straightforward script will assist you in accomplishing this task.

## Requirements

See `requirements.txt` for python and the below

```
sudo dnf install mysql mysql-common
```

## Usage
```
python mirage.py --help
usage: migrate.py [-h] --db DB [--sql_file SQL_FILE] [--drop] [--sql_list_file SQL_LIST_FILE]

Migrate IRIDA database

optional arguments:
  -h, --help            show this help message and exit
  --db DB               Name of the database to create
  --sql_file SQL_FILE   SQL file to be restored
  --drop                Drop the existing database before creating
  --sql_list_file SQL_LIST_FILE
                        Path to the text file containing a list of SQL files
```
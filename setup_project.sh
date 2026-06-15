#!/usr/bin/env bash

# This is the trap command,to save the file into an archive.

archive_save() {
	echo "Saving progress into archive"
	tar -cvf ${PARENT_DIR}_archive ${PARENT_DIR} && rm -rf ${PARENT_DIR}
	echo "save successfull"
}

trap 'archive_save' SIGINT

# This code creates the directory structure and its contents

VERSION=1
while [ -d "attendance_tracker_v${VERSION}" ]; do
    VERSION=$((VERSION + 1))
done

PARENT_DIR="attendance_tracker_v${VERSION}"

mkdir -p ${PARENT_DIR}/Helpers
mkdir -p ${PARENT_DIR}/reports

echo '{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}' >> ${PARENT_DIR}/Helpers/config.json

echo 'Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0' >> ${PARENT_DIR}/Helpers/assets.csv

echo '--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.' >> ${PARENT_DIR}/reports/reports.log

echo 'import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()' >> ${PARENT_DIR}/attendance_checker.py



#This code changes the values in config.json

echo "CHANGE THE VALUE FOR WARNING IN CONFIG FILE"
read -p "enter new value: " warning_new
sed -i "s/\"warning\": [[:digit:]]*/\"warning\": ${warning_new}/" ${PARENT_DIR}/Helpers/config.json
echo "Change successfull."

echo "CHANGE THE VALUE FOR FAILURE IN CONFIG FILE"
read -p "enter new failure value: " failure_new
sed -i "s/\"failure\": [[:digit:]]*/\"failure\": ${failure_new}/" ${PARENT_DIR}/Helpers/config.json
echo "Change successful."

# This code checks if python3 is installed.


echo "Checking if python3 is intalled and its current version"
python3 --version
echo "check successful"

m="${PARENT_DIR}/Helpers"
j="${PARENT_DIR}/reports"
v="${PARENT_DIR}/attendance_checker.py"
l="${m}/assets.csv"
o="${m}/config.json"
n="${j}/reports.log"

for z in "$m" "$j" "${PARENT_DIR}"
do
	if [ -d $z ]; then 
		echo "directory "${z}" exists"
	else 
		echo "directory $z does not exist"
	fi
done

for y in $v $l $o $n
do
	if [ -e "$y" ]; then
		echo "file $y exists "
	else
		echo "file $y does not exist"
	fi
done

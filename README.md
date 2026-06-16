WHAT THE CODE IS ABOUT
The Attendance Tracker is a Bash script that helps you set up a complete attendance-tracking project from the ground up. It makes a new versioned folder each time, so you don’t lose previous runs, then creates all the needed subfolders. The script adds a JSON config file, a student CSV, a sample log, and a Python checker script. Before it finishes, you can update the warning and failure thresholds, check that Python 3 is installed, and make sure all the files and folders are in place.

HOW TO RUN THE CODE SO THAT IT WORKS
To access it, first clone the repository using the link: https://github.com/mwanikifelix-01/deploy_agent_mwanikifelix-01.git  then navigate into the directory deploy_agent_mwanikifelix-01.
To run it, you make the script executable with chmod +x setup.sh, run it with ./setup.sh and enter your preferred thresholds when prompted. When the attendance_checker.py is run by inputing python3 attendance_checker.py, the checker reads the student CSV, calculates each student's attendance percentage against the total sessions in the config, and writes alert messages to reports/reports.log for anyone who falls below a threshold.

HOW THE ARCHIVE FEATURE IS TRIGGERED
The archive feature acts as a safety net when you press Ctrl+C during the setup script. Rather than stopping right away, the script catches the interrupt and runs archive_save(). This command packs the project folder into a tar archive and deletes the original folder only if the archive is created successfully. You can restore the archive later using tar -xvf followed by the filename.

This is the link to the video:      https://drive.google.com/file/d/1t6D1O56fPwcR4ZoB7HoLwPPpqIQFmQsB/view?usp=drive_link


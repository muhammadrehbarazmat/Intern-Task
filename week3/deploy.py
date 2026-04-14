import os
import subprocess

# CONFIG
PROJECT_DIR = os.path.expanduser("~/internship-tasks/week4/myapp")
BRANCH = "main"
APP_FILE = "app.py"

# Getting into project directory
os.chdir(PROJECT_DIR)

# Pulling latest code
print("Pulling latest code...")
subprocess.run(["git", "pull", "origin", BRANCH])

#  Killing old app (if running)
print("Stopping old app...")
subprocess.run(["pkill", "-f", APP_FILE])

#  Starting app in background
print("Starting app...")
subprocess.Popen(
    ["nohup", "python3", APP_FILE],
    stdout=open("output.log", "a"),
    stderr=open("error.log", "a")
)

print("Deployment completed")

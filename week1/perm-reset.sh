#!/bin/bash

#Directory for monitor
DIR="/home/rehbar/Downloads"
Email="muhammadrehbarazmat@gmail.com"


#Correct permissions and ownership
CORRECT_PERMS="750"
CORRECT_OWNER="rehbar"
CORRECT_GROUP="rehbar"

#Check if the directory exists first
if [ ! -d "$DIR" ]; then
    echo "Error: $DIR does not exist. Skipping check."
    exit 1
fi

#Get current values
CURRENT_PERMS=$(stat -c "%a" "$DIR")
CURRENT_OWNER=$(stat -c "%U" "$DIR")
CURRENT_GROUP=$(stat -c "%G" "$DIR")

#Compare values
if [[ "$CURRENT_PERMS" != "$CORRECT_PERMS" || "$CURRENT_OWNER" != "$CORRECT_OWNER" || "$CURRENT_GROUP" != "$CORRECT_GROUP" ]]; then
    echo "Change detected in $DIR"
    
    echo "Restoring permissions..."
    # Using -f (force) to suppress errors if something changes mid-execution
    sudo chmod "$CORRECT_PERMS" "$DIR"
    sudo chown "$CORRECT_OWNER:$CORRECT_GROUP" "$DIR"
    
        #Send email alert 
      echo  "$MESSAGE" | mail -s "Permissions restored" "$Email"
    
    echo "Permissions restored successfully"
else
    echo "No changes detected"
fi


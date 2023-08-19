#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]; then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d "$1" ]] || [[ ! -d "$2" ]]; then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory="$1"
destinationDirectory="$2"

# [TASK 2]
echo " "
echo " "

# [TASK 3]
currentTS=$(date +"%Y-%m-%d %H:%M:%S")

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
# 1: Go into the target directory
# 2: Create the backup file
# 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=$(realpath "$targetDirectory")

# [TASK 6]
cd "$targetDirectory"
destDirAbsPath=$(realpath "$destinationDirectory")

# [TASK 8]
yesterdayTS=$(date -d "yesterday" +"%Y-%m-%d %H:%M:%S")

declare -a toBackup

for file in "$targetDirectory"/*; do
  # [TASK 10]
  if [ -f "$file" ]; then
    # [TASK 11]
    if [ -r "$file" ]; then
      # [TASK 12]
      fileTimestamp=$(stat -c %Y "$file")

      yesterdayTimestamp=$(date -d "yesterday" +%s)
      if [ "$fileTimestamp" -gt "$yesterdayTimestamp" ]; then
        toBackup+=("$file")
      fi
    fi
  fi
done

# [TASK 13]
if [ ${#toBackup[@]} -gt 0 ]; then
  tar -czvf "$destDirAbsPath/$backupFileName" "${toBackup[@]}"
fi

echo "Backup complete!"

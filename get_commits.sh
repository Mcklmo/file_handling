#!/bin/bash

# Check if both date and folder path arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <YYYY-MM-DD> <folder_path>"
  exit 1
fi

# Store the provided date and folder path
START_DATE=$1
FOLDER_PATH=$2

# Check if the specified folder exists
if [ ! -d "$FOLDER_PATH" ]; then
  echo "Error: The folder '$FOLDER_PATH' does not exist."
  exit 1
fi

# Change to the specified folder
cd "$FOLDER_PATH" || { echo "Error: Could not change to folder '$FOLDER_PATH'."; exit 1; }

# Check if the folder is a git repository
if [ ! -d ".git" ]; then
  echo "Error: The folder '$FOLDER_PATH' is not a git repository."
  exit 1
fi

# Calculate the end date (7 days later)
END_DATE=$(date -I -d "$START_DATE + 1 months")

# Get the list of commits made by the current user during the specified week
git log --author="$(git config user.name)" --since="$START_DATE 00:00" --until="$END_DATE 23:59" --pretty=format:"%h %an %ad %s" --date=local

# Check if there are no commits found
if [ $? -ne 0 ]; then
  echo "No commits found between $START_DATE and $END_DATE by $(git config user.name) in the repository at '$FOLDER_PATH'."
fi


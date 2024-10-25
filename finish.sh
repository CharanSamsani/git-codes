#!/bin/bash

# Define colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Show git status
git status

# Prompt for files or directories to add individually
echo "Enter the names of the files or directories you want to add (type 'done' when finished):"
while true; do
    read -p "File/Directory: " file
    if [[ $file == "done" ]]; then
        break
    elif [[ -e $file ]]; then
        git add "$file"
        echo "Added $file"
    else
        echo "$file does not exist in the repository."
    fi
done

# Commit and push if there are staged changes
if git diff --cached --quiet; then
    echo "No files were staged. Exiting."
    exit 1
fi

# Get commit message and push changes
read -p "Enter your commit message: " commit_message
git commit -m "$commit_message"

# Attempt to push changes
if ! git push; then
    # If push fails, prompt to force push
    read -p "Push failed. Would you like to force push? (y/n): " force_push
    if [[ $force_push == "y" ]]; then
        git push --force
        echo "Changes have been force-pushed."
    else
        echo "Push canceled."
        exit 1
    fi
else
    echo "Changes have been pushed."
fi

# Success message in green
echo -e "${GREEN}Script executed successfully! All changes have been committed and pushed.${NC}"

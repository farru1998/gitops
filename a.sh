#!/bin/bash

# Fetch the latest two tags
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
previous_tag=$(git describe --tags `git rev-list --tags --max-count=2 | tail -n 1`)

if [ -z "$latest_tag" ]; then
    echo "Error: Could not find sufficient tags to generate a changelog."
    exit 1
fi

# Define the changelog file
changelog_file="CHANGELOG.md"

# Create or overwrite the changelog file if it doesn't exist
if [ ! -f $changelog_file ]; then
    echo "# Changelog" > $changelog_file
    echo "" >> $changelog_file
fi

# Create a temporary file to hold the new changelog entries
temp_file=$(mktemp)

# Add the latest tag section to the temporary file
echo "## [$latest_tag] - $(date +%Y-%m-%d)" >> $temp_file
echo "" >> $temp_file

# Use git log to get commit messages between the latest tag and the previous tag
git log $previous_tag..$latest_tag --pretty=format:"- %s" >> $temp_file

# Create a new changelog file with the header and the new entries at the top
{
    echo ""
    cat $temp_file
    echo ""
    cat $changelog_file
} > $changelog_file.tmp

# Move the temporary file to the changelog file
mv $changelog_file.tmp $changelog_file

# Clean up the temporary file
rm $temp_file

echo "Changelog for $latest_tag generated successfully in $changelog_file."

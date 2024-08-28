#!/bin/bash

# Fetch the latest two tags
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

if [ -z "$latest_tag" ]; then
    echo "Error: Could not find sufficient tags to generate a changelog."
    exit 1
fi

# Create or overwrite the changelog file
changelog_file="CHANGELOG.md"
echo "# Changelog" > $changelog_file
echo "" >> $changelog_file
echo "## $latest_tag" >> $changelog_file
echo "" >> $changelog_file

# Use git log to get commit messages between the two tags
git log $latest_tag.. --pretty=format:"- %s" >> $changelog_file

echo "Changelog for $latest_tag generated successfully in $changelog_file."

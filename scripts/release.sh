#!/bin/bash

# Exit on error
set -e

# Default release type
RELEASE_TYPE=${1:-"patch"}

# Validate release type
if [[ ! "$RELEASE_TYPE" =~ ^(major|minor|patch)$ ]]; then
    echo "Error: Release type must be one of: major, minor, patch"
    echo "Usage: $0 [major|minor|patch]"
    exit 1
fi

# Ensure we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Error: Must be on main branch to create a release"
    exit 1
fi

# Ensure working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "Error: Working directory is not clean. Please commit or stash changes first."
    exit 1
fi

# Pull latest changes
echo "Pulling latest changes..."
git pull origin main

# Get current version from package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "Current version: $CURRENT_VERSION"

# Calculate new version
NEW_VERSION=$(node -e "
const semver = require('semver');
const current = '$CURRENT_VERSION';
const type = '$RELEASE_TYPE';
console.log(semver.inc(current, type));
")

if [ -z "$NEW_VERSION" ]; then
    echo "Error: Failed to calculate new version"
    exit 1
fi

echo "New version will be: $NEW_VERSION"

# Update version in package.json
npm version $RELEASE_TYPE --no-git-tag-version

# Commit changes
git add package.json
git commit -m "chore: release v$NEW_VERSION"

# Create and push tag
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"

# Push changes and tags
echo "Pushing changes and tags..."
git push origin main
git push origin "v$NEW_VERSION"

echo "✨ Released version $NEW_VERSION successfully!" 
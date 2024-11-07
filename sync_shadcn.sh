#!/bin/bash

REPO="ArcaneArts/arcane_shadcn"
BRANCH="arcane"
FOLDER_NAME="arcane_shadcn"

if [ ! -d "$FOLDER_NAME" ]; then
    echo "Repository doesn't exist locally. Cloning..."
    git clone -b $BRANCH https://github.com/ArcaneArts/arcane_shadcn.git
else
    echo "Repository exists. Updating..."
    cd "$FOLDER_NAME"
    git fetch origin
    git reset --hard "origin/$BRANCH"
    cd ..
fi

echo "Done! Repository is up to date on branch '$BRANCH'."

pause
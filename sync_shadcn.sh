#!/bin/bash

REPO="ArcaneArts/arcane_shadcn"
BRANCH="arcane"

# Update Git
if [ ! -d "arcane_shadcn" ]; then
    echo "Repository doesn't exist locally. Cloning..."
    git clone -b $BRANCH https://github.com/ArcaneArts/arcane_shadcn.git
else
    echo "Repository exists. Updating..."
    cd "arcane_shadcn"
    git fetch origin
    git reset --hard "origin/$BRANCH"
    cd ..
fi

echo "Done! Repository is up to date on branch '$BRANCH'."

# Update dependencies
cd "arcane_shadcn"
flutter pub get
cd docs && flutter pub get && cd ..
cd example && flutter pub get && cd ..
cd ..

# Install package
rm -rf lib/generated/arcane_shadcn
mkdir -p lib/generated/arcane_shadcn
cp -a arcane_shadcn/lib/. lib/generated/arcane_shadcn

# Fix imports
find lib/generated/arcane_shadcn -type f -name "*.dart" -exec sed -i 's|import '\''package:shadcn_flutter/|import '\''package:arcane/generated/arcane_shadcn/|g' {} +

# Update arcane dependencies
flutter pub get
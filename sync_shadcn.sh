#!/bin/bash

REPO="ArcaneArts/arcane_shadcn"
BRANCH="arcane"

clear

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

# Install package
echo "Installing 'arcane_shadcn' package into 'lib/generated'."
rm -rf lib/generated/arcane_shadcn && mkdir -p lib/generated/arcane_shadcn
cp -a arcane_shadcn/lib/. lib/generated/arcane_shadcn

# Fix imports
echo "Fixing imports for 'arcane_shadcn'."
find lib/generated/arcane_shadcn -type f -name "*.dart" -exec sed -i 's|import '\''package:shadcn_flutter/|import '\''package:arcane/generated/arcane_shadcn/|g' {} +

# Tear out docs into arcane
echo "Tearing out 'arcane_shadcn/docs' into 'intermediate_docs'."
rm -rf intermediate_docs && mkdir -p intermediate_docs
cp -a arcane_shadcn/docs/. intermediate_docs 

# Fix doc imports
echo "Fixing pubspec for 'intermediate_docs' to target arcane_shadcn."
find intermediate_docs -type f -name "pubspec.yaml" -exec sed -i 's|path: ../|path: ../arcane_shadcn|g' {} +
echo "Updating dependencies for 'intermediate_docs'."

# Brand docs
cd intermediate_docs
echo "Branding 'intermediate_docs' to 'arcane'."
find lib/pages -type f -name "docs_page.dart" -exec sed -i "s/'shadcn_flutter'/'arcane'/g" {} +
cd ..
echo "Changing urls to arcane"
find intermediate_docs -type f -name "*.dart" -exec sed -i 's|'https://github.com/sunarya-thito/shadcn_flutter'|'https://github.com/ArcaneArts/arcane'|g' {} +
find intermediate_docs -type f -name "*.dart" -exec sed -i 's|'https://pub.dev/packages/shadcn_flutter'|'https://pub.dev/packages/arcane'|g' {} +

# Cleanup
echo "Cleaning intermediate_docs & example remnants."
rm -rf arcane_shadcn/docs &
rm -rf arcane_shadcn/example &
rm -rf arcane_shadcn/docs_images &
rm -rf arcane_shadcn/.github &
echo "Pub get on all projects."
(flutter clean && flutter pub get) &
(cd intermediate_docs && flutter clean && flutter pub get) &
(cd example && flutter clean && flutter pub get) &
(cd arcane_shadcn && flutter clean && flutter pub get) &
wait
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
find lib/generated/arcane_shadcn -type f -name "*.dart" -exec sed -i '' 's|import '\''package:shadcn_flutter/|import '\''package:arcane/generated/arcane_shadcn/|g' {} +

# Tear out docs into arcane
echo "Tearing out 'arcane_shadcn/docs' into 'docs'."
rm -rf docs && mkdir -p docs
cp -a arcane_shadcn/docs/. docs 

# Fix doc imports 


echo "Fixing pubspec for 'docs' to target arcane_shadcn."
find docs -type f -name "pubspec.yaml" -exec sed -i '' 's|path: ../|path: ../arcane_shadcn|g' {} +
find docs -type f -name "pubspec.yaml" -exec sed -i '' 's|  # The following adds the Cupertino Icons font to your application.|  arcane: |g' {} +
find docs -type f -name "pubspec.yaml" -exec sed -i '' 's|  # Use with the CupertinoIcons class for iOS style icons.|    path: ../ |g' {} +
echo "Updating dependencies for 'docs'."

# Brand docs
cd docs
echo "Branding 'docs' to 'arcane'."
find lib/pages -type f -name "docs_page.dart" -exec sed -i '' "s/'shadcn_flutter'/'arcane'/g" {} +
find lib/pages -type f -name "docs_page.dart" -exec sed -i '' 's|'FlutterLogo'|'Logo'|g' {} +

# Fix Localizations
echo "Fixing localizations for 'docs'."

find lib -type f -name "main.dart" -exec sed -i '' 's|routerConfig: router,|routerConfig: router,localizationsDelegates: const \[a\.ShadcnLocalizationsDelegate\(\)\],|g' {} +
find lib -type f -name "main.dart" -exec sed -i '' 's|import '\''package:docs/custom.dart'\'';|import '\''package:docs/custom.dart'\'';import '\''package:arcane/arcane.dart'\'' as a;|g' {} +

cd ..
echo "Changing urls to arcane"
find docs -type f -name "*.dart" -exec sed -i '' 's|- asset: "packages/shadcn_flutter/|- asset: "packages/arcane/resources/|g' {} +
find docs -type f -name "*.dart" -exec sed -i '' 's|'https://github.com/sunarya-thito/shadcn_flutter'|'https://github.com/ArcaneArts/arcane'|g' {} +
find docs -type f -name "*.dart" -exec sed -i '' 's|'https://pub.dev/packages/shadcn_flutter'|'https://pub.dev/packages/arcane'|g' {} +
cp docs/pubspec.yaml docs/pubspec.original.yaml
./script_sync_docs_live.sh


# Cleanup
echo "Cleaning docs & example remnants."
rm -rf arcane_shadcn/docs &
rm -rf arcane_shadcn/example &
rm -rf arcane_shadcn/docs_images &
rm -rf arcane_shadcn/.github &
rm -rf lib/generated/arcane_shadcn/fonts &
rm -rf lib/generated/arcane_shadcn/icons &
echo "Pub get on all projects."
(flutter clean && flutter pub get) &
(cd docs && flutter clean && flutter pub get) &
(cd example && flutter clean && flutter pub get) &
(cd arcane_shadcn && flutter clean && flutter pub get) &
wait
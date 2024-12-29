#!/bin/bash
cp arcane_docs/lib/custom.dart docs/lib/custom.dart
cp arcane_docs/lib/installation_page.dart docs/lib/pages/docs/installation_page.dart
cp arcane_docs/lib/introduction_page.dart docs/lib/pages/docs/introduction_page.dart
cp arcane_docs/lib/theme_page.dart docs/lib/pages/docs/theme_page.dart

sed -i '' -e '/^flutter:$/r arcane_docs/shaderinject.txt' -e '/^flutter:$/d' docs/pubspec.yaml
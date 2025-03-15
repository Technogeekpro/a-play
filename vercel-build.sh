#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter and install dependencies
flutter doctor -v
flutter pub get

# Build web app
flutter build web --release --no-tree-shake-icons

# Ensure the build/web directory exists
if [ -d "build/web" ]; then
  echo "Build successful!"
else
  echo "Build failed or directory not found!"
  exit 1
fi 
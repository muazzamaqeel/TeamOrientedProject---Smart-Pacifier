#!/bin/bash

echo "[*] Launching SmartPacifier-Tool (Frontend)..."

# Move to the script's directory
cd "$(dirname "$0")" || exit 1

# Check if protoc binary exists
if ! command -v protoc >/dev/null 2>&1; then
  echo "[ERROR] protoc not found"
  echo "Please install it using: sudo apt install protobuf-compiler -y"
  read -p "Press any key to continue..."
  exit 1
fi

# Show fake loading bar directly in this terminal
echo "Please wait while setting things up..."
bar="["
for i in $(seq 1 30); do
    bar="${bar}#"
    clear
    echo "$bar"
    sleep 1
done

# Clean up old generated Dart files
echo "[*] Cleaning old .pb.dart files..."
rm -f lib/generated/*.dart 2>/dev/null

# Run build_runner clean and regenerate .pb.dart files
echo "[*] Running build_runner clean..."
dart run build_runner clean

echo "[*] Generating Protobuf Dart files..."
dart run build_runner build --delete-conflicting-outputs

# Run the Flutter app in release mode
echo
echo "[✓] Build complete. Launching the app in release mode..."
flutter run -d linux --release

# Keep terminal open in case of errors
echo
echo "[!] Process finished. Press any key to exit..."
read -n 1 -s
exit 0

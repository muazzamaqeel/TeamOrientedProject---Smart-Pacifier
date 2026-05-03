import os

# Root directory to scan
ROOT_DIR = os.path.expanduser(
    "~/git-hub/SmartPacifier-Tool/src/smartpacifier_app"
)

# Output file next to this script
OUTPUT_FILE = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "dart_files_dump.txt"
)

# Folders to completely ignore
IGNORED_DIRS = {
    "generated",
    ".dart_tool",
    "build",
    ".plugin_symlinks",
}

# Generated Dart file patterns to ignore anywhere
GENERATED_FILE_SUFFIXES = (
    ".pb.dart",
    ".pbenum.dart",
    ".pbgrpc.dart",
    ".pbjson.dart",
    ".g.dart",
    ".freezed.dart",
)


def should_skip_file(path):
    """Return True if this Dart file should be skipped."""
    parts = path.lower().split(os.sep)
    filename = os.path.basename(path).lower()

    # Skip ignored folders anywhere in the path
    if any(part in IGNORED_DIRS for part in parts):
        return True

    # Skip generated protobuf / build-generated Dart files anywhere
    if filename.endswith(GENERATED_FILE_SUFFIXES):
        return True

    return False


def main():
    if not os.path.isdir(ROOT_DIR):
        print(f"[ERROR] Folder does not exist: {ROOT_DIR}")
        return

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        for root, dirs, files in os.walk(ROOT_DIR):
            # Prevent os.walk from entering ignored folders
            dirs[:] = [d for d in dirs if d.lower() not in IGNORED_DIRS]

            for file in files:
                if not file.endswith(".dart"):
                    continue

                full_path = os.path.join(root, file)

                out.write("=" * 80 + "\n")
                out.write(f"FILE: {full_path}\n")
                out.write("=" * 80 + "\n")

                if should_skip_file(full_path):
                    out.write(f"(generated/protobuf file skipped) {file}\n\n")
                    continue

                try:
                    with open(full_path, "r", encoding="utf-8") as f:
                        out.write(f.read())
                        out.write("\n\n")
                except Exception as e:
                    out.write(f"[Error reading file: {e}]\n\n")

    print(f"Done. Output saved to: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
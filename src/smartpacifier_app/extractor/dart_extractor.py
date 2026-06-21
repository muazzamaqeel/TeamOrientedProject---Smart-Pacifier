import os

# Root directory to scan
ROOT_DIR = os.path.expanduser(
    "C:\\Programming\\GitHub\\SmartPacifier-Tool\\src\\smartpacifier_app\\"
)

# Output file next to this script
OUTPUT_FILE = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "dart_files_dump.txt"
)

# Directory names to skip entirely (build artifacts, platform scaffolding, tooling)
SKIP_DIRS = {
    "generated",
    "build",
    ".dart_tool",
    ".git",
    ".idea",
    "ios",
    "android",
    "macos",
    "linux",
    "windows",
    "ephemeral",
}

# Generated-source filename suffixes to skip even outside skipped folders
SKIP_FILE_SUFFIXES = (
    ".g.dart",        # json_serializable / general codegen
    ".freezed.dart",  # freezed
    ".pb.dart",       # protobuf
    ".pbenum.dart",
    ".pbjson.dart",
    ".pbgrpc.dart",
    ".mocks.dart",    # mockito
)


def is_generated_file(filename):
    """True if the filename matches a known generated-source pattern."""
    return filename.endswith(SKIP_FILE_SUFFIXES)


def main():
    if not os.path.isdir(ROOT_DIR):
        print(f"[ERROR] Folder does not exist: {ROOT_DIR}")
        return

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        for root, dirs, files in os.walk(ROOT_DIR):
            # Prune skipped directories in-place so os.walk won't descend into them
            dirs[:] = [d for d in dirs if d.lower() not in SKIP_DIRS]

            for file in files:
                if not file.endswith(".dart"):
                    continue

                full_path = os.path.join(root, file)

                out.write("=" * 80 + "\n")
                out.write(f"FILE: {full_path}\n")
                out.write("=" * 80 + "\n")

                if is_generated_file(file):
                    out.write(f"(generated file – content skipped) {file}\n\n")
                else:
                    try:
                        with open(full_path, "r", encoding="utf-8") as f:
                            out.write(f.read())
                            out.write("\n\n")
                    except Exception as e:
                        out.write(f"[Error reading file: {e}]\n\n")

    print(f"Done. Output saved to: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
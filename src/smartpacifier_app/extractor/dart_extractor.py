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


def is_generated(path):
    """Check if file is inside a generated folder."""
    parts = path.lower().split(os.sep)
    return "generated" in parts


def main():
    if not os.path.isdir(ROOT_DIR):
        print(f"[ERROR] Folder does not exist: {ROOT_DIR}")
        return

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        for root, dirs, files in os.walk(ROOT_DIR):
            for file in files:
                if file.endswith(".dart"):
                    full_path = os.path.join(root, file)

                    out.write("=" * 80 + "\n")
                    out.write(f"FILE: {full_path}\n")
                    out.write("=" * 80 + "\n")

                    if is_generated(full_path):
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
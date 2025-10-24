#!/usr/bin/env python3
"""
Split a large Firebase Realtime Database JSON export into one file per top-level key.

Usage:
    python split_firebase_json.py input.json output_dir/

Output:
    output_dir/key1.json
    output_dir/key2.json
    ...
"""

import json
import os
import sys
from pathlib import Path

def split_json_by_toplevel(input_path: str, output_dir: str):
    print(f"Reading {input_path} (this may take a moment for large files)...")

    # Stream-parse to avoid loading entire 2GB into memory at once (optional but safer)
    # However, since we need top-level keys, we must load the root object.
    # For 2GB, ensure you have enough RAM (~3–4 GB recommended).
    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    if not isinstance(data, dict):
        raise ValueError("Top-level JSON element must be an object (dict).")

    Path(output_dir).mkdir(parents=True, exist_ok=True)

    count = 0
    total_keys = len(data)
    print(f"Found {total_keys} top-level keys. Writing to {output_dir}...")

    for key, value in data.items():
        safe_key = "".join(c if c.isalnum() or c in "._-" else "_" for c in str(key))
        output_path = os.path.join(output_dir, f"{safe_key}.json")

        # Write { "key": value } as root object (Firebase-compatible)
        with open(output_path, 'w', encoding='utf-8') as out_f:
            json.dump({key: value}, out_f, ensure_ascii=False, separators=(',', ':'))

        count += 1
        if count % 100 == 0:
            print(f"  Written {count}/{total_keys} files...")

    print(f"✅ Done! Split into {count} files in '{output_dir}'.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python split_firebase_json.py <input.json> <output_directory>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_dir = sys.argv[2]

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)

    split_json_by_toplevel(input_file, output_dir)

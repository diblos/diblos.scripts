#!/usr/bin/env python3
"""
Split a Firebase Realtime Database JSON export into one file per second-level key.

Each output file contains a single path like:
    { "top_key": { "second_key": value } }

Usage:
    python split_firebase_json_second_layer.py input.json output_dir/

Output:
    output_dir/users_user1.json
    output_dir/users_user2.json
    output_dir/posts_postA.json
    ...
"""

import json
import os
import sys
from pathlib import Path


def sanitize_filename_component(s: str) -> str:
    """Sanitize a string to be safe for use in filenames."""
    return "".join(c if c.isalnum() or c in "._-" else "_" for c in str(s))


def split_json_by_secondlayer(input_path: str, output_dir: str):
    print(f"Reading {input_path} (this may take a moment for large files)...")

    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    if not isinstance(data, dict):
        raise ValueError("Top-level JSON element must be an object (dict).")

    Path(output_dir).mkdir(parents=True, exist_ok=True)

    file_count = 0
    total_second_keys = 0

    # Pre-count second-level keys for progress (optional but helpful)
    for top_key, top_value in data.items():
        if isinstance(top_value, dict):
            total_second_keys += len(top_value)
        else:
            # If top-level value isn't a dict, skip or treat as single entry?
            # We'll skip non-dict top-level values for second-layer split.
            pass

    print(f"Found {total_second_keys} second-level keys. Writing to {output_dir}...")

    for top_key, top_value in data.items():
        if not isinstance(top_value, dict):
            print(f"⚠️ Skipping top-level key '{top_key}': value is not an object.")
            continue

        for second_key, value in top_value.items():
            safe_top = sanitize_filename_component(top_key)
            safe_second = sanitize_filename_component(second_key)
            filename = f"{safe_top}_{safe_second}.json"
            output_path = os.path.join(output_dir, filename)

            # Structure: { "top_key": { "second_key": value } }
            content = {top_key: {second_key: value}}

            with open(output_path, 'w', encoding='utf-8') as out_f:
                json.dump(content, out_f, ensure_ascii=False, separators=(',', ':'))

            file_count += 1
            if file_count % 100 == 0:
                print(f"  Written {file_count}/{total_second_keys} files...")

    print(f"✅ Done! Split into {file_count} files in '{output_dir}'.")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python split_firebase_json_second_layer.py <input.json> <output_directory>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_dir = sys.argv[2]

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)

    split_json_by_secondlayer(input_file, output_dir)

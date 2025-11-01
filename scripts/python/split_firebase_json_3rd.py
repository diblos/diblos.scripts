#!/usr/bin/env python3
"""
Split a Firebase Realtime Database JSON export into one file per third-level key.

Each output file contains a single path like:
    { "top": { "second": { "third": value } } }

Usage:
    python split_firebase_json_third_layer.py input.json output_dir/

Output:
    output_dir/users_user1_profile.json
    output_dir/users_user1_settings.json
    ...
"""

import json
import os
import sys
from pathlib import Path


def sanitize_filename_component(s: str) -> str:
    """Sanitize a string to be safe for use in filenames."""
    return "".join(c if c.isalnum() or c in "._-" else "_" for c in str(s))


def split_json_by_thirdlayer(input_path: str, output_dir: str):
    print(f"Reading {input_path} (this may take a moment for large files)...")

    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    if not isinstance(data, dict):
        raise ValueError("Top-level JSON element must be an object (dict).")

    Path(output_dir).mkdir(parents=True, exist_ok=True)

    file_count = 0
    total_third_keys = 0

    # Pre-count third-level keys for progress reporting
    for top_key, top_value in data.items():
        if isinstance(top_value, dict):
            for second_key, second_value in top_value.items():
                if isinstance(second_value, dict):
                    total_third_keys += len(second_value)
                # If second_value is not a dict, it has no third layer → skip
        # Non-dict top-level values are skipped

    print(f"Found {total_third_keys} third-level keys. Writing to {output_dir}...")

    for top_key, top_value in data.items():
        if not isinstance(top_value, dict):
            print(f"⚠️ Skipping top-level key '{top_key}': value is not an object.")
            continue

        for second_key, second_value in top_value.items():
            if not isinstance(second_value, dict):
                print(f"⚠️ Skipping second-level path '{top_key}/{second_key}': value is not an object.")
                continue

            for third_key, value in second_value.items():
                safe_top = sanitize_filename_component(top_key)
                safe_second = sanitize_filename_component(second_key)
                safe_third = sanitize_filename_component(third_key)
                filename = f"{safe_top}_{safe_second}_{safe_third}.json"
                output_path = os.path.join(output_dir, filename)

                # Build nested structure: { top: { second: { third: value } } }
                content = {top_key: {second_key: {third_key: value}}}

                with open(output_path, 'w', encoding='utf-8') as out_f:
                    json.dump(content, out_f, ensure_ascii=False, separators=(',', ':'))

                file_count += 1
                if file_count % 100 == 0:
                    print(f"  Written {file_count}/{total_third_keys} files...")

    print(f"✅ Done! Split into {file_count} files in '{output_dir}'.")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python split_firebase_json_third_layer.py <input.json> <output_directory>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_dir = sys.argv[2]

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)

    split_json_by_thirdlayer(input_file, output_dir)

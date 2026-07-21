#!/usr/bin/env python3
import json
import glob
import os
import sys

def beautify_json_files(directory="."):
    json_files = sorted(glob.glob(os.path.join(directory, "*.json")))
    if not json_files:
        print("No JSON files found in", os.path.abspath(directory))
        return

    for file_path in json_files:
        # Skip beautify.py if named with .json or metadata
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            
            with open(file_path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            
            filename = os.path.basename(file_path)
            item_count = len(data["data"]) if isinstance(data, dict) and "data" in data else "N/A"
            print(f"✓ Successfully beautified '{filename}' (Items: {item_count})")
        except Exception as e:
            print(f"✗ Failed to process '{os.path.basename(file_path)}': {e}")

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    beautify_json_files(target_dir)

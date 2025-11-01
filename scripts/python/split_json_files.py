import json
import os
import sys
from math import ceil

def split_json_into_groups(input_file, num_groups, output_dir="split_output"):
    os.makedirs(output_dir, exist_ok=True)

    # Load input JSON
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in '{input_file}': {e}")
        sys.exit(1)

    if not isinstance(data, dict):
        print("Error: JSON root must be an object (dictionary).")
        sys.exit(1)

    items = list(data.items())
    total = len(items)

    if num_groups <= 0:
        print("Error: Number of groups must be at least 1.")
        sys.exit(1)

    if num_groups > total:
        print(f"Warning: Requested {num_groups} groups, but only {total} items exist. Creating {total} groups instead.")
        num_groups = total

    # Calculate how many items per group
    items_per_group = ceil(total / num_groups)
    groups = []

    for i in range(0, total, items_per_group):
        group_items = items[i:i + items_per_group]
        group_dict = dict(group_items)
        groups.append(group_dict)

    # Write each group to a file
    for idx, group in enumerate(groups, start=1):
        output_path = os.path.join(output_dir, f"part_{idx}.json")
        with open(output_path, 'w', encoding='utf-8') as out_file:
            json.dump(group, out_file, indent=2, ensure_ascii=False)
        print(f"Saved {len(group)} top-level items to: {output_path}")

    print(f"\n✅ Successfully split {total} items into {len(groups)} file(s) in '{output_dir}'.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python split_json_grouped.py <input_file.json> <number_of_files>")
        print("Example: python split_json_grouped.py data.json 3")
        sys.exit(1)

    input_file = sys.argv[1]
    try:
        num_files = int(sys.argv[2])
    except ValueError:
        print("Error: Number of files must be an integer.")
        sys.exit(1)

    split_json_into_groups(input_file, num_files)

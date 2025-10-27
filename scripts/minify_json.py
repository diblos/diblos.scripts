import json
import sys

def minify_json(input_file, output_file):
    """Remove all unnecessary whitespace from JSON to reduce file size."""
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, separators=(',', ':'), ensure_ascii=False)

        print(f"Minified: '{input_file}' → '{output_file}'")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python minify_json.py <input.json> <output.json>")
        sys.exit(1)
    minify_json(sys.argv[1], sys.argv[2])

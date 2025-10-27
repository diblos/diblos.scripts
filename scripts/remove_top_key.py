import json
import sys

def remove_top_key(input_file, output_file):
    """
    Reads a JSON file, removes the top-level key, and saves the nested values to a new file.
    
    Args:
        input_file (str): Path to the input JSON file
        output_file (str): Path to the output JSON file
    """
    try:
        # Read the input JSON file
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Verify input is a dictionary with exactly one top-level key
        if not isinstance(data, dict):
            raise ValueError("Input JSON must be an object (dictionary)")
        if len(data) != 1:
            raise ValueError("Input JSON must have exactly one top-level key")
        
        # Extract the nested values (remove top key)
        nested_values = next(iter(data.values()))
        
        # Write the nested values to the output file
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(nested_values, f, indent=2, ensure_ascii=False)
        
        print(f"Successfully processed '{input_file}' -> '{output_file}'")
        
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in '{input_file}': {e}", file=sys.stderr)
        sys.exit(1)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_file.json> <output_file.json>")
        sys.exit(1)
    
    input_path = sys.argv[1]
    output_path = sys.argv[2]
    remove_top_key(input_path, output_path)

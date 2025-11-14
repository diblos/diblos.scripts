import requests
import json
import os

# --- Configuration ---
# Replace with your actual Firebase ID Token
# WARNING: This token should be kept secure. For production/long-term scripts,
# consider using a Firebase Service Account or the official Firebase Admin SDK.
FIREBASE_ID_TOKEN = "<FIREBASE_ID_TOKEN>"
PROJECT_ID = "<PROJECT_ID>"
DATABASE_URL = f"https://{PROJECT_ID}.firebaseio.com"

# Define your list of paths and desired filenames
# The key is the Firebase path, and the value is the local filename
paths = {
    "zasss/zasss_payment/z_bank_acc": "bank_acc.json",
    "invoices": "invoice.json",
    "jobs/joblist": "joblist.json",
    "jobs/job_match": "jobmatch.json",
    "users": "uprofile.json",
    "scores": "uscore.json",
    # Add more paths as needed
}

# --- Download Logic ---

print("Starting Firebase Realtime Database downloads...")
print("-" * 30)

for path, filename in paths.items():
    # Construct the full URL for the Firebase REST API
    # We include the '.json' extension and the 'auth' query parameter
    full_url = f"{DATABASE_URL}/{path}.json"

    # Parameters for the request (auth token)
    params = {
        "auth": FIREBASE_ID_TOKEN
        # Note: We are not using the '&download=' parameter from the shell script
        # as it's not a standard Firebase REST API parameter and 'requests' handles saving the content.
    }

    print(f"Downloading /{path} to {filename}...")

    try:
        # Make the GET request to Firebase
        response = requests.get(full_url, params=params)
        response.raise_for_status() # Raise an HTTPError for bad responses (4xx or 5xx)

        # The Firebase REST API returns the data as JSON
        data = response.json()

        # Write the data to a local file
        with open(filename, 'w', encoding='utf-8') as f:
            # Use json.dump to write the data to the file, optionally with indentation for readability
            json.dump(data, f, ensure_ascii=False, indent=4)

        print(f"Finished downloading /{path}")
        print(f"  > Saved as: {filename} ({os.path.getsize(filename)} bytes)")

    except requests.exceptions.RequestException as e:
        print(f"ERROR: Failed to download /{path}. Request error: {e}")
    except json.JSONDecodeError:
        print(f"ERROR: Failed to decode JSON for /{path}. Response content: {response.text[:100]}...") # Show a snippet of the response
    except IOError as e:
        print(f"ERROR: Failed to write file {filename}. IO error: {e}")

    print("-" * 30)

print("All downloads complete!")

# Example of how the data structure looks in a JSON file:

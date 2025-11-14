#!/bin/bash

# Check if gcloud is installed and authenticated
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud CLI is required but not installed."
    echo "Please install Google Cloud CLI: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Verify authentication
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
    echo "Error: Not authenticated with gcloud. Run 'gcloud auth login' first."
    exit 1
fi

PROJECT_ID="<PROJECT_ID>"
DATABASE_URL="https://${PROJECT_ID}.firebaseio.com"

# Define your list of paths and desired filenames
# declare -A paths
declare paths
paths["zasss/zasss_payment/z_bank_acc"]="bank_acc.json"
paths["invoices"]="invoice.json"
paths["jobs/joblist"]="joblist.json"
paths["jobs/job_match"]="jobmatch.json"
paths["users"]="uprofile.json"
paths["scores"]="uscore.json"

# Download each path using gcloud to get access token
for path in "${!paths[@]}"; do
  filename="${paths[$path]}"
  echo "Downloading /${path} to ${filename}..."

  # Get access token from gcloud
  ACCESS_TOKEN=$(gcloud auth print-access-token)

  curl -o "$filename" \
       -H "Authorization: Bearer $ACCESS_TOKEN" \
       "${DATABASE_URL}/${path}.json"

  if [ $? -eq 0 ]; then
    echo "✓ Finished downloading /${path} to ${filename}"
  else
    echo "✗ Failed to download /${path}"
  fi
done

echo "All downloads complete!"

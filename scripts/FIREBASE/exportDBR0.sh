#!/bin/bash

# Replace with your actual Firebase ID Token (obtain this from a signed-in user or service account)
FIREBASE_ID_TOKEN="<FIREBASE_ID_TOKEN>"
PROJECT_ID="<PROJECT_ID>"
DATABASE_URL="https://${PROJECT_ID}.firebaseio.com"

# Define your list of paths and desired filenames
declare -A paths
paths["zasss/zasss_payment/z_bank_acc"]="bank_acc.json"
paths["invoices"]="invoice.json"
paths["jobs/joblist"]="joblist.json"
paths["jobs/job_match"]="jobmatch.json"
paths["users"]="uprofile.json"
paths["scores"]="uscore.json"
# Add more paths as needed

for path in "${!paths[@]}"; do
  filename="${paths[$path]}"
  # echo "Downloading /${path} to ${filename}..."
  # curl -o "$filename" "${DATABASE_URL}/${path}.json?auth=${FIREBASE_ID_TOKEN}&download=${filename}"
  echo "Finished downloading /${path}"
  echo "${path} > ${filename}"
done

echo "All downloads complete!"

#!/bin/bash

# Path to your service account JSON key file
SERVICE_ACCOUNT_KEY_FILE="<FILE_PATH>"
PROJECT_ID="<PROJECT_ID>"
DATABASE_URL="https://${PROJECT_ID}.firebaseio.com"

# Function to generate OAuth 2.0 access token using service account
get_access_token() {
    local key_file="$1"

    # Extract service account info
    local client_email=$(jq -r '.client_email' "$key_file")
    local private_key=$(jq -r '.private_key' "$key_file" | sed 's/\\n/\\n/g')

    # Create JWT header and payload for Google OAuth2
    local header=$(printf '{"alg":"RS256","typ":"JWT"}' | openssl base64 -A -e | tr -d '=' | tr '/+' '_-' | sed 's/=*$//')

    # Current timestamp and expiration (1 hour)
    local now=$(date -u +%s)
    local exp=$((now + 3600))

    local payload=$(printf '{"iss":"%s","scope":"https://www.googleapis.com/auth/firebase.database","aud":"https://oauth2.googleapis.com/token","exp":%d,"iat":%d}' "$client_email" "$exp" "$now" | openssl base64 -A -e | tr -d '=' | tr '/+' '_-' | sed 's/=*$//')

    # Create signature
    local signing_input="${header}.${payload}"
    local signature=$(echo -n "$signing_input" | openssl dgst -sha256 -sign <(echo "$private_key") | openssl base64 -A -e | tr -d '=' | tr '/+' '_-' | sed 's/=*$//')

    local jwt="${signing_input}.${signature}"

    # Exchange for access token
    local response=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$jwt" \
        https://oauth2.googleapis.com/token)

    echo "$response" | jq -r '.access_token'
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install with: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
    exit 1
fi

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is required but not installed."
    exit 1
fi

# Check if service account key file exists
if [ ! -f "$SERVICE_ACCOUNT_KEY_FILE" ]; then
    echo "Error: Service account key file not found at $SERVICE_ACCOUNT_KEY_FILE"
    echo "Please download your service account key file from Firebase Console"
    exit 1
fi

# Get access token
echo "Obtaining access token..."
ACCESS_TOKEN=$(get_access_token "$SERVICE_ACCOUNT_KEY_FILE")

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
    echo "Error: Failed to obtain access token"
    exit 1
fi

echo "Access token obtained successfully"

# Define your list of paths and desired filenames
declare -A paths
paths["zasss/zasss_payment/z_bank_acc"]="bank_acc.json"
paths["invoices"]="invoice.json"
paths["jobs/joblist"]="joblist.json"
paths["jobs/job_match"]="jobmatch.json"
paths["users"]="uprofile.json"
paths["scores"]="uscore.json"
# Add more paths as needed

# Download each path
for path in "${!paths[@]}"; do
  filename="${paths[$path]}"
  echo "Downloading /${path} to ${filename}..."

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

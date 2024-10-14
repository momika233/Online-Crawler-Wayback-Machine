#!/bin/bash
# Checking user input
if [ -z "$1" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

DOMAIN=$1

# Set the requested URL
url="https://web.archive.org/web/timemap/json?url=$DOMAIN&matchType=prefix&collapse=urlkey&output=json&fl=original%2Cmimetype%2Ctimestamp%2Cendtimestamp%2Cgroupcount%2Cuniqcount&filter=!statuscode%3A%5B45%5D..&limit=10000&_=1728877410012"

# Output file
output_file="$DOMAIN.txt"

# Print the response to check the data structure
response=$(curl -s "$url")

# Print the first few lines of the response for debugging
echo "Response (First 10 characters):"
echo "${response:0:10}"

# Process the response using jq, checking and extracting links containing the specified domain name
echo "$response" | jq -r '.[] | select(type == "array") | .[0]' | grep "$DOMAIN" > "$output_file"

# The saving success message is displayed
echo "The extracted link has been saved to $output_file"

# Filter duplicate links
cat "$output_file" | uro > "$DOMAIN_url.txt"
rm -rf "$output_file"

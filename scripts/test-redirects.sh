#!/usr/bin/env bash
# Test script for redirect functionality
# Can be run locally or from CI/CD pipeline

set -e

# Default host and port if not provided
HOST=${1:-localhost}
PORT=${2:-2015}

echo "🧪 Testing redirects on $HOST:$PORT"

paths=(
  "/"
  "/sysdig-monitor-onboarding/"
  "/rocketchat-etiquette/"
  "/platform-security-tools/"
)

expected_destinations=(
  "https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/"
  "https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/app-monitoring/sysdig-monitor-onboarding/"
  "https://developer.gov.bc.ca/docs/default/component/bc-developer-guide/rocketchat/rocketchat-etiquette/"
  "https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/security-and-privacy-compliance/platform-security-tools/"
)

for i in "${!paths[@]}"; do
  path="${paths[$i]}"
  expected="${expected_destinations[$i]}"
  echo "Testing $path -> $expected"
  response=$(curl -s -w "%{http_code}\n%{redirect_url}\n" "http://$HOST:$PORT$path")
  status=$(echo "$response" | head -1)
  location=$(echo "$response" | tail -1)
  
  if [ "$status" == "301" ] && [[ "$location" == "$expected" ]]; then
    echo "✅ Redirect for $path works correctly"
  else
    echo "❌ Redirect for $path failed. Status: $status, Location: $location"
    exit 1
  fi
done

# Test error handling
echo "Testing error handling..."
response=$(curl -s -o /dev/null -w "%{http_code}\n" "http://$HOST:$PORT/non-existent-path/")
status=$(echo "$response")

if [ "$status" == "404" ]; then
  echo "✅ Error handling works correctly"
else
  echo "❌ Error handling failed. Status: $status"
  exit 1
fi

echo "✅ All tests passed successfully!"

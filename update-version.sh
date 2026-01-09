#!/bin/bash

TEMP_JSON=$(mktemp)
trap 'rm -f "$TEMP_JSON"' EXIT
API_URL="https://api.github.com/repos/jenkinsci/docker-agent/releases/latest"

HTTP_CODE=$(curl -fsL -o "$TEMP_JSON" -w "%{http_code}" "$API_URL")
if [ $? -ne 0 ]; then
    echo "Error: Network request failed."
    exit 1
fi

if [ "$HTTP_CODE" != "200" ]; then
    echo "Error: API returned HTTP $HTTP_CODE"
    if [ -s "$TEMP_JSON" ]; then
        echo "Response body:"
        cat "$TEMP_JSON"
    fi
    exit 1
fi

LATEST_VERSION=$(jq -r '.tag_name // empty' "$TEMP_JSON")
if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" == "null" ]; then
    echo "Error: Failed to extract tag_name from response."
    exit 1
fi

if [ -f LATEST_VERSION ]; then
    CURRENT_VERSION=$(cat LATEST_VERSION)
else
    CURRENT_VERSION=""
fi

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
    echo "New version found: $LATEST_VERSION (Old: $CURRENT_VERSION)"
    echo "$LATEST_VERSION" > LATEST_VERSION
else
    echo "Already at latest version: $LATEST_VERSION"
fi

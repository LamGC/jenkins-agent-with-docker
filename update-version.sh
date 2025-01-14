#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/jenkinsci/docker-agent/releases/latest | jq -r '.tag_name')
CURL_EXIT_CODE=$?
if [ $CURL_EXIT_CODE -ne 0 ] || [ -z "$LATEST_VERSION" ]; then
    echo "Failed to retrieve the latest version"
    exit 1
fi

if [ "$LATEST_VERSION" != "$(cat LATEST_VERSION)" ]; then
    echo "$LATEST_VERSION" > LATEST_VERSION
fi
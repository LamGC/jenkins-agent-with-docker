#!/bin/bash

if [ $(id -u) != "0" ]; then
  echo "This script must be run as root"
  exit 1
fi

if [ -z "$GID" ]; then
  echo "GID is not set"
  exit 1
fi
if [ -z "$UID" ]; then
  echo "UID is not set"
  exit 1
fi
if ! grep -q docker /etc/group; then
  groupadd -g $GID docker && usermod -aG docker jenkins
  echo "Added docker group"
fi
if [ $(id -u jenkins) -ne $UID ]; then
  usermod -u $UID jenkins
  echo "Changed jenkins UID"
fi

echo "Starting agent..."
su - jenkins -c "/usr/local/bin/jenkins-agent $@"

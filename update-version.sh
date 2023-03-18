LATEST_VERSION=$(curl -s https://api.github.com/repos/jenkinsci/docker-inbound-agent/releases/latest | grep tag_name | cut -d '"' -f 4)
if [ "$LATEST_VERSION" != "$(cat LATEST_VERSION)" ]; then
    echo "$LATEST_VERSION" > LATEST_VERSION
fi
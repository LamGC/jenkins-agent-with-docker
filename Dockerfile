ARG BASE_TAG=latest

FROM jenkins/inbound-agent:${BASE_TAG}

USER root

COPY start-agent.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh
ENTRYPOINT [ "/bin/bash", "/usr/local/bin/start.sh" ]

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    mkdir -m 0755 -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli docker-buildx-plugin docker-compose-plugin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV DOCKER_HOST=unix:///var/run/docker.sock

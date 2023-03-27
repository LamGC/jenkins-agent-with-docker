# jenkins-agent-with-docker

带有 Docker CLI 的 Jenkins agent 镜像。

> **Note**：仅适用于 Docker，不适用于 Podman。

## 安全警告

将宿主机的 Docker 访问接口提供给 Jenkins 容器（包括 Agent）是一件很危险的事情，一旦 Jenkins 执行了恶意流水线，
那么流水线将能完全控制 Docker Engine，甚至能够访问宿主机的所有文件。因此，使用此镜像时必须非常小心。

## Usage

使用此镜像必须将宿主机的 `/var/run/docker.sock` 映射到容器内同等目录，否则 Docker CLI 无法正常工作。  

### 创建用户和用户组

如果 Docker 不是用软件包管理器安装的，那就要先创建一个 `docker` 用户组，然后将 `jenkins` 用户加入到该用户组内：  

```bash
sudo groupadd docker
```

然后创建一个 `jenkins` 用户，并将其加入到 Docker 用户组内：

```bash
sudo useradd -m -g docker jenkins
```

### 部署 Jenkins Agent 容器

在原先的部署命令上，添加 `/var/run/docker.sock` 的映射和宿主机 `jenkins` 用户、`docker` 用户组的 ID 到容器中：

```bash
docker run -d --name agent \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e GID=$(grep docker /etc/group | cut -d: -f3) \
    -e UID=$(id -u jenkins) \
    lamgc/jenkins-agent-docker  -url {JENKINS_URL} -workDir=/home/jenkins/agent {Secret} {Agent_Name}
```

具体配置请参考原版镜像说明：[jenkins/inbound-agent - Readme](https://github.com/jenkinsci/docker-inbound-agent/#readme)  

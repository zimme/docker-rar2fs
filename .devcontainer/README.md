# Development Container

This directory contains the configuration for the development container that provides a consistent development environment for the `docker-rar2fs` project.

## What's Included

### Base Environment
- **Alpine Linux 3.20** - Minimal, security-focused base image
- **Docker-in-Docker** - Full Docker support for building and testing Docker images
- **GitHub CLI** - For interacting with GitHub repositories and workflows

### VS Code Extensions
- **Docker Extension** - Docker file syntax highlighting, build/run support
- **GitHub Copilot** - AI-powered code assistance
- **GitHub Copilot Chat** - Interactive AI conversations
- **YAML Extension** - Support for GitHub Actions workflows

### Key Features
- **Privileged mode** - Required for Docker-in-Docker functionality
- **Multi-platform support** - Defaults to linux/amd64 for consistency
- **Volume mounting** - Persistent Docker storage across container restarts

## Usage

### With VS Code
1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open the repository in VS Code
3. When prompted, click "Reopen in Container" or use the Command Palette: `Dev Containers: Reopen in Container`

### With GitHub Codespaces
The devcontainer configuration automatically works with GitHub Codespaces, providing the same environment in the cloud.

## Testing the Docker Image

Once the development container is running, you can build and test the rar2fs Docker image:

```bash
# Build the image
docker build -t test-rar2fs .

# Test basic functionality (requires successful build)
docker run --rm test-rar2fs --version

# Run with custom configuration
docker run --rm test-rar2fs --help
```

## Development Workflow

This container is optimized for:
- Building and testing multi-platform Docker images
- Developing GitHub Actions workflows
- Contributing to the rar2fs Docker image project
- Using GitHub Copilot for enhanced development experience

## Notes

- The container runs with `--privileged` mode to support Docker-in-Docker
- Docker daemon storage is persisted in a named volume
- The environment includes all tools needed for this project's CI/CD workflows
# GitHub Copilot Instructions for docker-rar2fs

## Project Overview

This repository provides a minimal Docker image for `rar2fs`, a FUSE filesystem that allows mounting RAR archives as regular directories. The project focuses on:

- **Minimal Alpine-based Docker images** with multi-stage builds
- **Automated dependency management** with GitHub Actions
- **Security-first approach** with proper FUSE capabilities and user permissions
- **Multi-platform support** (linux/amd64, linux/arm64)

## General Coding Guidelines

### Docker Best Practices
- Use multi-stage builds to minimize final image size
- Pin specific versions for base images (e.g., `alpine:3.21.2`)
- Use `ARG` for build-time variables that may need updates
- Implement proper health checks using filesystem mounts
- Follow principle of least privilege with user permissions

### Build Process
- The Dockerfile builds `unrar` library and `rar2fs` from source
- Use `autoreconf`, `configure`, and `make` for building rar2fs
- Copy only essential binaries to runtime image
- Set proper environment variables (e.g., `FUSE_THREAD_STACK`)

### Security Considerations
- Run as non-root when possible (recommend `-u` flag override)
- Require specific capabilities: `MKNOD` and `SYS_ADMIN`
- Need `/dev/fuse` device access for FUSE operations
- Consider AppArmor restrictions with `--security-opt apparmor:unconfined`

## File-Specific Guidelines

### Dockerfile
- Keep `ARG` declarations at the top for easy automated updates
- Use specific version numbers that can be automatically updated
- Maintain the multi-stage build pattern (builder + runtime)
- Ensure proper library copying from builder stage
- Set sensible defaults in `CMD` for common use cases

### GitHub Actions Workflows
- **Version Update Workflow**: Automatically checks for new versions of UnRAR and rar2fs
- **Build & Publish Workflow**: Builds, tests, and publishes to Docker Hub and GHCR
- Use semantic versioning in tags: `{rar2fs_version}-unrar{unrar_version}-{base_image}{version}`
- Always test built images before publishing (`--version` check)

### Docker Compose
- Include all required capabilities and devices
- Use `rshared` bind propagation for FUSE mounts
- Recommend `--init` flag for proper process handling
- Template placeholder paths with clear `<>` indicators

## Commit Message Patterns

Based on project history, follow these patterns:

### Automated Version Updates
```
Update Dockerfile ARG values: rar={version}, rar2fs={version}
```

### Feature/Fix Commits
- Use clear, imperative mood
- Be specific about what changed
- For Docker changes: mention image impact
- For workflow changes: specify which workflow

### Examples
- `Add health check for FUSE mount status`
- `Update Alpine base image to 3.21.3`
- `Fix build process for ARM64 architecture`
- `Improve documentation for AppArmor configuration`

## VSCode Copilot Chat Instructions

When working with this repository:

1. **Building**: Always consider both `amd64` and `arm64` architectures
2. **Testing**: Suggest using `docker run --rm {image} --version` for basic validation
3. **Dependencies**: When updating versions, check both UnRAR and rar2fs simultaneously
4. **Security**: Always mention required capabilities and devices in suggestions
5. **Documentation**: Keep README.md examples current with any changes

### Common Tasks
- **Version Updates**: Update both `UNRAR_VERSION` and `RAR2FS_VERSION` ARGs
- **Base Image Updates**: Update `BUILDER_IMAGE` and `RUNTIME_IMAGE` consistently
- **Workflow Modifications**: Test locally with `act` if possible
- **Documentation**: Validate Docker commands work as documented

## GitHub Agent Mode Instructions

### Repository Context
- This is a **single-purpose Docker image** project
- **No source code** for rar2fs/unrar (external dependencies)
- **Infrastructure-focused** with CI/CD automation
- **Minimal maintenance** philosophy

### Change Patterns
- Most changes are **version updates** (automated)
- **Manual changes** typically for:
  - Base image updates
  - Build process improvements
  - Documentation updates
  - Workflow enhancements

### Testing Strategy
- **Build testing**: Verify Docker build succeeds
- **Basic functionality**: Test `--version` and `--help` flags
- **Integration testing**: Verify FUSE mount capabilities (requires privileged environment)
- **Multi-platform**: Ensure builds work on both amd64 and arm64

### Dependencies to Monitor
1. **Alpine Linux** base image versions
2. **UnRAR** library releases from rarlab.com
3. **rar2fs** releases from hasse69/rar2fs
4. **GitHub Actions** dependencies

### Common Issues & Solutions
- **Build failures**: Usually due to missing dependencies or URL changes
- **FUSE mount issues**: Check capabilities, devices, and AppArmor settings
- **Permission problems**: Recommend user override with `-u` flag
- **Network issues**: Use `--network none` for security when possible

## Code Quality Standards

### Dockerfile
- Use `.dockerignore` if adding temporary files
- Minimize layers while maintaining readability
- Use `COPY` instead of `ADD` unless extracting archives
- Set proper `WORKDIR` for build context

### YAML Files
- Maintain consistent indentation (2 spaces)
- Use descriptive job and step names
- Include comments for complex logic
- Quote version strings to prevent parsing issues

### Documentation
- Keep examples executable and tested
- Include security considerations prominently
- Provide both basic and advanced usage patterns
- Maintain compatibility notes for different Docker versions

## Advanced Configuration

### Environment Variables
- `FUSE_THREAD_STACK`: Controls FUSE thread stack size (default: 320000)
- Consider exposing more rar2fs options as environment variables if needed

### Volume Mounts
- `/source`: Read-only mount for RAR files
- `/destination`: Mount point for extracted filesystem (requires `rshared`)
- Consider additional mounts for configuration or logging

### Network Configuration
- Default: Recommend `--network none` for security
- Alternative: Use custom networks for specific use cases
- Consider read-only filesystem for additional security

This project exemplifies modern DevOps practices with automated dependency management, multi-platform support, and security-conscious design.

## Additional Resources

- **[Copilot Interface Guide](./copilot-interface-guide.md)**: Specific instructions for different Copilot interfaces (VSCode Chat, Agent Mode, etc.)
- **[Quick Reference](./copilot-quick-reference.md)**: Concise commands and patterns for daily development
- **[Commit Guidelines](./commit-guidelines.md)**: Detailed commit message patterns and best practices

These files provide comprehensive guidance for AI-assisted development in this repository.
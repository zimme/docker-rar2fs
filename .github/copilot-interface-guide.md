# Copilot Interface-Specific Instructions

## GitHub Copilot (Code Completion)

### Dockerfile Completion
When editing the Dockerfile:
- Prioritize Alpine packages for runtime dependencies
- Suggest multi-stage build patterns when adding new build steps
- Auto-complete with security-conscious defaults (non-root user suggestions)
- Prefer `COPY --from=builder` for binary transfers
- Suggest health check commands related to FUSE mounts

### GitHub Actions Completion
When editing workflow files:
- Complete with latest GitHub Actions versions
- Suggest cache optimization for Docker builds
- Auto-complete matrix strategies for multi-platform builds
- Prioritize security with minimal token permissions
- Complete with proper artifact handling patterns

### Docker Compose Completion
When editing docker-compose files:
- Auto-complete required capabilities: `MKNOD`, `SYS_ADMIN`
- Suggest proper device mappings: `/dev/fuse`
- Complete volume bindings with `:rshared` for FUSE
- Suggest `init: true` for proper process handling

## VSCode Copilot Chat

### Project Context Prompts
Use these prompts to get better assistance:

```
This is a Docker project for rar2fs FUSE filesystem. The image needs FUSE capabilities to mount RAR files. Consider security implications and multi-platform builds.
```

### Common Chat Queries

#### For Version Updates:
```
How do I update the UnRAR and rar2fs versions in the Dockerfile? Check the latest versions and update both ARG declarations.
```

#### For Build Issues:
```
The Docker build is failing during the rar2fs compilation. Help me debug the build process in the multi-stage Dockerfile.
```

#### For Security Hardening:
```
How can I improve the security of this FUSE-based Docker container while maintaining functionality?
```

#### For Performance Optimization:
```
How can I optimize the Docker build time and final image size for this rar2fs container?
```

### Code Review Prompts
When reviewing changes:
```
Review this Docker/CI change for:
1. Multi-platform compatibility
2. Security implications for FUSE operations
3. Build efficiency and caching
4. Breaking changes to the API
```

## GitHub Copilot Agent Mode

### Agent Capabilities
The agent should understand:
- This is a **specialized FUSE filesystem container**
- **Security is critical** due to FUSE mount requirements
- **Automated workflows** handle most updates
- **Manual changes** should be minimal and surgical

### Task Delegation
For different types of tasks:

#### Version Updates
- Check both UnRAR and rar2fs releases
- Update Dockerfile ARG values atomically
- Test build process before committing
- Update documentation if API changes

#### Build Optimization
- Profile build times and suggest improvements
- Optimize layer caching strategies
- Suggest base image alternatives if beneficial
- Maintain multi-platform compatibility

#### Security Reviews
- Audit capability requirements
- Review user permission strategies
- Check for privilege escalation risks
- Validate FUSE mount security

#### Documentation Updates
- Ensure examples work with current versions
- Update security recommendations
- Verify Docker Compose configurations
- Maintain troubleshooting guides

### Agent Constraints
The agent should:
- **Never** remove security features without explicit approval
- **Always** test changes in both architectures when possible
- **Prioritize** minimal changes that maintain backward compatibility
- **Consider** the impact on automated workflows

### Debugging Workflows
When troubleshooting:

1. **Build Issues**:
   ```bash
   # Test local build
   docker build --no-cache --platform linux/amd64 .
   docker build --no-cache --platform linux/arm64 .
   ```

2. **Runtime Issues**:
   ```bash
   # Test basic functionality
   docker run --rm {image} --version
   docker run --rm {image} --help
   ```

3. **FUSE Issues**:
   ```bash
   # Test with minimal FUSE setup
   docker run --rm --cap-add SYS_ADMIN --device /dev/fuse {image}
   ```

### Integration Points
Consider these when making changes:

- **GitHub Actions**: Automated builds trigger on pushes to main
- **Dependabot**: Updates Docker base images automatically  
- **Docker Hub**: Multi-platform images published automatically
- **GHCR**: Mirror registry for redundancy

## Copilot Custom Instructions

### For Repository Root
Add this to your Copilot settings when working in this repo:

```yaml
project_type: "docker_infrastructure"
primary_language: "dockerfile"
frameworks: ["docker", "github_actions", "alpine_linux"]
security_focus: "fuse_capabilities"
deployment_targets: ["docker_hub", "ghcr"]
architectures: ["amd64", "arm64"]
```

### Context-Aware Suggestions
Copilot should prioritize:
1. **Alpine package suggestions** over other distributions
2. **Multi-stage build patterns** for efficiency
3. **Security-first approaches** for FUSE operations
4. **Automated workflow integration** for maintenance
5. **Minimal surface area** for attack vectors

### Anti-Patterns to Avoid
Don't suggest:
- Running as root without clear justification
- Downloading binaries without checksum verification
- Exposing unnecessary network ports
- Complex orchestration for a single-purpose container
- Breaking the automated update workflows

This configuration helps Copilot provide more relevant and secure suggestions for this specialized Docker project.
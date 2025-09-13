# Quick Reference for GitHub Copilot

## Project Summary
**docker-rar2fs**: Minimal Alpine-based Docker image for rar2fs FUSE filesystem to mount RAR archives.

## Key Constraints
- **FUSE Requirements**: Needs `--cap-add MKNOD --cap-add SYS_ADMIN --device /dev/fuse`
- **Security**: Run with `--init` and consider user override with `-u`
- **Multi-platform**: Support linux/amd64 and linux/arm64
- **Minimal**: Keep image size small, Alpine-based

## Common Commands

### Build & Test
```bash
# Local build
docker build -t rar2fs-test .

# Test functionality
docker run --rm rar2fs-test --version
docker run --rm rar2fs-test --help

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 .
```

### Run Container
```bash
# Basic usage
docker run -d --init --name rar2fs \
  --cap-add MKNOD --cap-add SYS_ADMIN \
  --device /dev/fuse --network none \
  -v /path/to/rars:/source \
  -v /path/to/mount:/destination:rshared \
  zimme/rar2fs

# With user override (recommended)
docker run -d --init --name rar2fs \
  --cap-add MKNOD --cap-add SYS_ADMIN \
  --device /dev/fuse --network none \
  -u $(id -u):$(id -g) --group-add $(id -g) \
  -v /path/to/rars:/source \
  -v /path/to/mount:/destination:rshared \
  zimme/rar2fs
```

## File Patterns

### Dockerfile ARGs (auto-updated)
```dockerfile
ARG BUILDER_IMAGE=alpine:3.21.2
ARG RUNTIME_IMAGE=alpine:3.21.2
ARG UNRAR_VERSION=7.1.10
ARG RAR2FS_VERSION=1.29.7
```

### Health Check Pattern
```dockerfile
HEALTHCHECK --interval=5s --timeout=3s \
  CMD grep -qs rar2fs /proc/mounts
```

### Default CMD Pattern
```dockerfile
CMD [ "-f", "-o", "allow_other", "-o", "auto_unmount", 
      "--seek-length=1", "/source", "/destination" ]
```

## Commit Message Templates

### Version Updates (automated)
```
Update Dockerfile ARG values: rar={version}, rar2fs={version}
```

### Manual Changes
```
Fix: {what was wrong}
Add: {new feature/capability}
Update: {what was changed}
Improve: {optimization/enhancement}
```

## Troubleshooting

### Build Failures
- Check Alpine package availability
- Verify download URLs for UnRAR/rar2fs
- Ensure proper library linking

### Runtime Issues
- Verify FUSE capabilities and devices
- Check mount point permissions  
- Consider AppArmor restrictions
- Validate bind mount propagation

### AppArmor Issues
```bash
# If FUSE permission denied
docker run --security-opt apparmor:unconfined ...
```

## Workflow Integration

### Automatic Updates
- **Daily**: Check for new UnRAR and rar2fs versions
- **Push to main**: Build and publish multi-platform images
- **Dependabot**: Update Docker base images

### Manual Testing
```bash
# Validate workflow changes locally
act -j docker  # if act is available

# Test specific platforms
docker buildx build --platform linux/arm64 --load -t test-arm64 .
docker run --rm test-arm64 --version
```

## Security Checklist
- [ ] Minimal base image (Alpine)
- [ ] Non-root execution recommended
- [ ] Required capabilities only (MKNOD, SYS_ADMIN)
- [ ] Network isolation when possible
- [ ] Read-only root filesystem compatible
- [ ] No unnecessary packages in runtime image

## Quick Copilot Prompts

### For Updates
"Update the rar2fs Docker image to use the latest versions"

### For Security
"Review this Docker setup for FUSE security best practices"

### For Optimization  
"Optimize this Dockerfile for smaller image size and faster builds"

### For Debugging
"Help debug this FUSE mount issue in the Docker container"
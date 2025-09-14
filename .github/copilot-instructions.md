# GitHub Copilot Instructions

This repository provides a minimal Docker image for `rar2fs`, a FUSE filesystem that allows mounting RAR archives as regular directories.

## Project Context

This is a single-purpose Docker image project that:
- Builds `rar2fs` and `unrar` from source using Alpine Linux multi-stage builds
- Supports multi-platform builds (linux/amd64, linux/arm64) 
- Uses automated dependency management via GitHub Actions
- Requires specific FUSE capabilities and security considerations

## Key Files

### Dockerfile
- Multi-stage build: builder stage compiles from source, runtime stage contains minimal image
- Key ARG variables: `UNRAR_VERSION`, `RAR2FS_VERSION`, `BUILDER_IMAGE`, `RUNTIME_IMAGE`
- Dependencies built from source: UnRAR library and rar2fs binary
- Runtime requirements: fuse, libstdc++, `/dev/fuse` device access

### GitHub Actions Workflows
- `check-for-updates-and-update-dockerfile.yaml`: Automatically updates ARG versions
- `docker-build-and-publish.yaml`: Builds and publishes to Docker Hub and GHCR
- Uses semantic versioning: `{rar2fs_version}-unrar{unrar_version}-{base_image}{version}`

### Docker Usage
- Requires capabilities: `MKNOD` and `SYS_ADMIN`
- Needs `/dev/fuse` device and `rshared` bind propagation
- Mount points: `/source` (RAR files), `/destination` (FUSE mount)
- May need `--security-opt apparmor:unconfined` for AppArmor systems

## Development Guidelines

### When making changes:
- Always consider both amd64 and arm64 architectures
- Test with `docker run --rm {image} --version` for basic validation
- Update both UNRAR_VERSION and RAR2FS_VERSION ARGs when needed
- Maintain multi-stage build pattern for minimal image size
- Pin specific versions for reproducible builds

### Common patterns:
- Automated version updates: `Update Dockerfile ARG values: rar={version}, rar2fs={version}`
- Manual changes: Use imperative mood, be specific about impact
- Security: Always mention required capabilities and devices in suggestions

### Dependencies to monitor:
- Alpine Linux base image versions  
- UnRAR library releases from rarlab.com
- rar2fs releases from hasse69/rar2fs

### Testing approach:
- Build testing: Verify Docker build succeeds on both platforms
- Basic functionality: Test `--version` and `--help` flags  
- Integration testing: Verify FUSE mount capabilities (requires privileged environment)

This project follows minimal maintenance philosophy with automated workflows handling most updates.
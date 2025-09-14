#!/bin/bash

# Development Container Validation Script
# This script verifies that the development environment is properly configured

set -e

echo "🔍 Validating development container setup..."

# Check Docker availability
echo "📦 Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not available"
    exit 1
fi

docker --version
echo "✅ Docker is available"

# Check Docker daemon
echo "🐳 Checking Docker daemon..."
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running"
    exit 1
fi
echo "✅ Docker daemon is running"

# Check GitHub CLI
echo "🐙 Checking GitHub CLI..."
if command -v gh &> /dev/null; then
    gh --version
    echo "✅ GitHub CLI is available"
else
    echo "⚠️  GitHub CLI not found (optional)"
fi

# Test basic Docker functionality
echo "🧪 Testing Docker functionality..."
if docker run --rm hello-world &> /dev/null; then
    echo "✅ Docker can run containers"
else
    echo "❌ Docker cannot run containers"
    exit 1
fi

# Check if we can build multi-platform images
echo "🏗️  Checking Docker buildx..."
if docker buildx version &> /dev/null; then
    echo "✅ Docker buildx is available for multi-platform builds"
else
    echo "⚠️  Docker buildx not available (may limit multi-platform builds)"
fi

# Verify we're in the correct workspace
echo "📁 Checking workspace..."
if [[ -f "Dockerfile" && -f "README.md" ]]; then
    echo "✅ Workspace contains expected rar2fs project files"
else
    echo "❌ Workspace doesn't contain expected project files"
    exit 1
fi

echo ""
echo "🎉 Development container validation completed successfully!"
echo "📚 You can now:"
echo "   - Build the Docker image: docker build -t test-rar2fs ."
echo "   - Test basic functionality: docker run --rm test-rar2fs --help"
echo "   - Use GitHub Copilot for enhanced development experience"
echo ""
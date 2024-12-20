#!/bin/bash

# Check if service name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

SERVICE_NAME=$1
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="../$SERVICE_NAME"

# Create the new service directory
mkdir -p "$TARGET_DIR"

# Copy template files
cp -R "$TEMPLATE_DIR"/* "$TARGET_DIR"
cp "$TEMPLATE_DIR"/.gitignore "$TARGET_DIR"
cp "$TEMPLATE_DIR"/.dockerignore "$TARGET_DIR"

# Rename and modify files
mv "$TARGET_DIR/cmd/server" "$TARGET_DIR/cmd/$SERVICE_NAME"
sed -i '' "s/TEMPLATE/$SERVICE_NAME/g" "$TARGET_DIR/cmd/$SERVICE_NAME/main.go"
sed -i '' "s/TEMPLATE/$SERVICE_NAME/g" "$TARGET_DIR/internal/service/service.go"
sed -i '' "s/TEMPLATE/$SERVICE_NAME/g" "$TARGET_DIR/Dockerfile"
sed -i '' "s/TEMPLATE/$SERVICE_NAME/g" "$TARGET_DIR/docker-compose.yml"
sed -i '' "s/TEMPLATE/$SERVICE_NAME/g" "$TARGET_DIR/.github/workflows/docker-build-push.yml"

# Initialize go module
cd "$TARGET_DIR"
go mod init "github.com/Cdaprod/$SERVICE_NAME"
go mod tidy

# Initialize git repository
git init
git add .
git commit -m "Initial commit for $SERVICE_NAME"

echo "Service $SERVICE_NAME has been set up successfully!"
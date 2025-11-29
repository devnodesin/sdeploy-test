#!/bin/bash

# Step 1: Download Hugo binary
HUGO_VERSION="0.152.2"
HUGO_TAR="hugo_${HUGO_VERSION}_linux-amd64.tar.gz"
HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_TAR}"

BIN_DIR="bin"

echo "Downloading Hugo ${HUGO_VERSION}..."
curl -L -o "$HUGO_TAR" "$HUGO_URL"


# Step 2: Extract Hugo binary to bin directory
echo "Extracting Hugo to $BIN_DIR..."
mkdir -p "$BIN_DIR"
tar -xzf "$HUGO_TAR" -C "$BIN_DIR"

# Step 3: Build Hugo site

echo "Building Hugo site..."
"$BIN_DIR/hugo" -s hugo

echo "Build complete."

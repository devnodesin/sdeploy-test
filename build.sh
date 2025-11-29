#!/bin/bash

# Step 1: Download Hugo binary
HUGO_VERSION="0.152.2"
HUGO_TAR="hugo_${HUGO_VERSION}_linux-amd64.tar.gz"
HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_TAR}"

BIN_DIR="bin"

# Only fetch and extract Hugo if binary is not present
if [ ! -f "$BIN_DIR/hugo" ]; then
	echo "Hugo binary not found in $BIN_DIR. Fetching and extracting..."
	echo "Running: curl -L -o $HUGO_TAR $HUGO_URL"
	curl -L -o "$HUGO_TAR" "$HUGO_URL"
	echo "Running: mkdir -p $BIN_DIR"
	mkdir -pv "$BIN_DIR"
	echo "Running: tar -xzf $HUGO_TAR -C $BIN_DIR"
	tar -xzf "$HUGO_TAR" -C "$BIN_DIR"
else
	echo "Hugo binary already exists at $BIN_DIR/hugo. Skipping download and extraction."
fi

# Step 3: Build Hugo site
echo "Running: $BIN_DIR/hugo -s hugo"
"$BIN_DIR/hugo" -s hugo

echo "Build complete."

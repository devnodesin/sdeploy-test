#!/bin/bash

# Step 1: Download Hugo binary
HUGO_VERSION="0.152.2"
HUGO_TAR="hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
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
if [ $? -eq 0 ]; then
	echo "Build complete."
	DEPLOY_DIR="/server/storage/html/test.domain.in/"
	SOURCE_DIR="hugo/public/"
	# Need to set the owner/group to www-data for web server access
	echo "Set Owner/Group of $SOURCE_DIR: chown -R www-data:www-data $SOURCE_DIR"
	chown -R www-data:www-data $SOURCE_DIR
	# Step 4: Deploy the site
	echo "Running: rsync -ahWO --no-compress --delete --stats --no-perms --no-owner --no-group $SOURCE_DIR $DEPLOY_DIR"
	rsync -ahWO --no-compress --delete --stats --no-perms --no-owner --no-group "$SOURCE_DIR" "$DEPLOY_DIR"
	# Safer side set the owner/group once again
	echo "Set Owner/Group of $DEPLOY_DIR: chown -R www-data:www-data $DEPLOY_DIR"
	chown -R www-data:www-data $DEPLOY_DIR
else
	echo "Build failed."
fi


echo "build.sh completed."

#!/usr/bin/env bash
set -eo pipefail

# Define where your public GPG key can be downloaded from
GPG_KEY_URL="https://mev-commit.primev.xyz/public-key.gpg"
# Define where the signature for the script can be found
SCRIPT_SIGNATURE_URL="https://mev-commit.primev.xyz/launchmevcommit.sig"
# Define the URL of the actual script
SCRIPT_URL="https://raw.githubusercontent.com/primevprotocol/scripts/v0.1.0/launchmevcommit"
# Installation directory and binary path
INSTALL_DIR="$HOME/.mev-commit"
BIN_PATH="$INSTALL_DIR/launchmevcommit"

# Download and import the public GPG key
curl -sSf -L "$GPG_KEY_URL" | gpg --import

# Download the script and its signature
curl -sSf -L "$SCRIPT_URL" -o "$BIN_PATH"
curl -sSf -L "$SCRIPT_SIGNATURE_URL" -o "$BIN_PATH.sig"

# Verify the script with the downloaded signature
gpg --verify "$BIN_PATH.sig" "$BIN_PATH"

# Proceed if verification succeeded
echo "Script verified successfully."

# Make the downloaded script executable
chmod +x "$BIN_PATH"

# Add the installation directory to the user's PATH in their .bashrc if it isn't already there
PROFILE="$HOME/.bashrc"
if ! grep -q "$INSTALL_DIR" "$PROFILE"; then
    echo "Adding $INSTALL_DIR to PATH in $PROFILE"
    echo -e "\n# Add mev-commit to PATH\nexport PATH=\"\$PATH:$INSTALL_DIR\"" >> "$PROFILE"
fi

echo
echo "mev-commit has been installed to $BIN_PATH."
echo "Source your profile or start a new shell session to use it."
echo "You can now run 'launchmevcommit' to start."

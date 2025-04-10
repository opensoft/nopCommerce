#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add the .devcontainer directory to PATH if not already there
if [[ ":$PATH:" != *":$SCRIPT_DIR/.devcontainer:"* ]]; then
    export PATH="$SCRIPT_DIR/.devcontainer:$PATH"
fi

echo "nopCommerce development tools are now available."
echo "You can use the \"clone\" command from any nopCommerce directory to clone plugins."

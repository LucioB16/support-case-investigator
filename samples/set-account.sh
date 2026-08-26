#!/bin/bash
export AZURE_CONFIG_DIR="$HOME/.azure-client-slug"
if [ "$1" == "--login" ] || [ "$1" == "-Login" ]; then
    az login --allow-no-subscriptions "$@"
fi

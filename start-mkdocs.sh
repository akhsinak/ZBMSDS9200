#!/bin/bash

echo "============================================"
echo "  Local Email App - MkDocs Documentation"
echo "============================================"
echo ""

# Get script directory
cd "$(dirname "$0")"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed or not in PATH"
    echo "Please install Python from https://python.org"
    exit 1
fi

# Create virtual environment if needed
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
pip install -q -r requirements.txt

# Create symlink for Japanese docs if not exists
if [ ! -d "docs/ja" ]; then
    echo "Linking Japanese documentation..."
    ln -sf "$(pwd)/docs-jp" "$(pwd)/docs/ja"
fi

echo ""
echo "Starting MkDocs server..."
echo "Open http://127.0.0.1:8000 in your browser"
mkdocs serve

read -p "Press any key to continue..."

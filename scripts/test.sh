#!/bin/bash
# Test script for neojj.nvim

set -e

# Create vendor directory if it doesn't exist
mkdir -p tests/vendor

# Clone mini.nvim if not present
if [ ! -d "tests/vendor/mini.nvim" ]; then
    echo "Vendoring mini.nvim for tests..."
    git clone --depth=1 https://github.com/echasnovski/mini.nvim tests/vendor/mini.nvim
fi

# Run tests
echo "Running tests..."
nvim --headless -u tests/minirc.lua +"lua MiniTest.run({collect = {find_files = function() return {'tests/test_hints.lua', 'tests/test_plugin.lua'} end}})" +qa
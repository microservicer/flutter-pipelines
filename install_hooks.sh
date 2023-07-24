#!/bin/bash

# Copy hooks from git_hooks to .git/hooks.
cp git_hooks/* .git/hooks/

# Make the hooks executable.
chmod +x .git/hooks/*

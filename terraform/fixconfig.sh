#!/bin/sh

# Looks up all config.tf files and remove commenting
# for terraform init to work properly
find . -maxdepth 3 -name config.tf -exec sed -r -i '' "s/# //g" {} \;f

#!/usr/bin/env bash

# Get fresh CodeArtifact token
export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1 \
  --query authorizationToken \
  --output text)

echo "Fetched new CODEARTIFACT_AUTH_TOKEN"

# Now install and build
npm install
npm run build

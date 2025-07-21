#!/usr/bin/env bash
set -e

echo "Downloading AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip

# ✅ Install AWS CLI locally inside ./aws-cli directory
./aws/install -i ./aws-cli -b ./aws-cli/bin

echo "Adding local AWS CLI to PATH..."
export PATH=$PWD/aws-cli/bin:$PATH

echo "Fetching CodeArtifact token..."
export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1 \
  --query authorizationToken \
  --output text)

echo "Logging in to CodeArtifact..."
aws codeartifact login --tool npm \
  --repository nye-shared-ui \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1

echo "Running npm install & build..."
npm install
npm run build

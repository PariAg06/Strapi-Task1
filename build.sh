#!/usr/bin/env bash
set -e

echo "Downloading AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip

echo "Installing AWS CLI locally..."
mkdir -p $PWD/aws-cli-bin
./aws/install -i $PWD/aws-cli -b $PWD/aws-cli-bin

echo "Verifying AWS CLI version..."
$PWD/aws-cli-bin/aws --version

echo "Fetching CodeArtifact token..."
export CODEARTIFACT_AUTH_TOKEN=$($PWD/aws-cli-bin/aws codeartifact get-authorization-token \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1 \
  --query authorizationToken \
  --output text)

echo "Logging in to CodeArtifact..."
$PWD/aws-cli-bin/aws codeartifact login --tool npm \
  --repository nye-shared-ui \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1

echo "Installing Node packages..."
npm install
npm run build

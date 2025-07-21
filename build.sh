#!/usr/bin/env bash
set -e

# Install unzip & curl (without sudo!)
apt-get update
apt-get install -y unzip curl

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Fetch CodeArtifact token
export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1 \
  --query authorizationToken \
  --output text)

# Configure npm to use CodeArtifact
aws codeartifact login --tool npm \
  --repository nye-shared-ui \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1

# Install & build
npm install
npm run build

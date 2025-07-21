#!/usr/bin/env bash

# Fail on any error
set -e

echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "Fetching new CODEARTIFACT_AUTH_TOKEN..."
export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain shared-nye-domain \
  --domain-owner 243016416530 \
  --region ap-south-1 \
  --query authorizationToken \
  --output text)

echo "Setting npm registry..."
npm config set //shared-nye-domain-243016416530.d.codeartifact.ap-south-1.amazonaws.com/npm/nye-shared-ui/:_authToken=$CODEARTIFACT_AUTH_TOKEN
npm config set registry https://shared-nye-domain-243016416530.d.codeartifact.ap-south-1.amazonaws.com/npm/nye-shared-ui/

echo "Running npm install..."
npm install

echo "Running npm run build..."
npm run build

#!/usr/bin/env bash

echo "🔑 Installing AWS CLI..."

# Download AWS CLI v2 installer for Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip it
unzip awscliv2.zip

# Install it
sudo ./aws/install

# Verify
aws --version

echo "✅ AWS CLI installed!"

echo "🔑 Getting fresh AWS CodeArtifact token..."

export CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
  --domain $CODEARTIFACT_DOMAIN \
  --domain-owner $CODEARTIFACT_DOMAIN_OWNER \
  --region $AWS_DEFAULT_REGION \
  --query authorizationToken \
  --output text)

echo "✅ Token fetched! Running npm install..."

npm install

echo "✅ Building Strapi..."

npm run build

echo "🎉 Build done!"

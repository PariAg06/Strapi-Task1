#!/usr/bin/env bash
set -e

echo "=== Checking AWS credentials ==="

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "❌ ERROR: AWS credentials not set! Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as environment variables."
  exit 1
fi

echo "✅ AWS credentials found."

echo "=== Downloading AWS CLI ==="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip

echo "=== Installing AWS CLI locally ==="
./aws/install -i ./aws-cli-bin -b ./aws-cli-bin

echo "=== Verifying AWS CLI version ==="
./aws-cli-bin/aws --version

echo "=== Fetching CodeArtifact auth token ==="
CODEARTIFACT_AUTH_TOKEN=$(./aws-cli-bin/aws codeartifact get-authorization-token \
  --domain <YOUR_DOMAIN> \
  --domain-owner <YOUR_DOMAIN_OWNER_ID> \
  --region ${AWS_DEFAULT_REGION} \
  --query authorizationToken \
  --output text)

echo "=== Logging in to CodeArtifact ==="
npm config set "//<YOUR_CODEARTIFACT_REPO>.d.codeartifact.${AWS_DEFAULT_REGION}.amazonaws.com/npm/<YOUR_REPO_NAME>/:always-auth" true
npm config set "//<YOUR_CODEARTIFACT_REPO>.d.codeartifact.${AWS_DEFAULT_REGION}.amazonaws.com/npm/<YOUR_REPO_NAME>/:_authToken" "${CODEARTIFACT_AUTH_TOKEN}"

echo "✅ AWS CodeArtifact login done."

echo "=== Running npm install ==="
npm install

echo "✅ Build done ==="

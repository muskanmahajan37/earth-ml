#!/bin/bash

# Check the required environment variables.
: ${PROJECT:?"Please set PROJECT to your Google Cloud Project ID"}
: ${BUCKET:?"Please set BUCKET to your Cloud Storage bucket (without gs:// prefix)"}
: ${ASSET_ID:?"Please set ASSET_ID to users/your-ee-username/landcover or projects/your-ee-project/landcover"}
: ${GOOGLE_APPLICATION_CREDENTIALS:?"Please set GOOGLE_APPLICATION_CREDENTIALS to point to the path/to/your/credentials.json"}

# Copy your credentials to upload to the server.
cp $GOOGLE_APPLICATION_CREDENTIALS server/credentials.json

# Generate the server's App Engine yaml file with the environment variables.
cat > server/app.yaml <<EOF
# This file is autogenerated, please change from deploy.sh

runtime: python37
instance_class: F4_1G
service: server

env_variables:
  GOOGLE_APPLICATION_CREDENTIALS: credentials.json
  PROJECT: $PROJECT
  BUCKET: $BUCKET
  ASSET_ID: $ASSET_ID
EOF

# Deploying the server into App Engine.
gcloud app deploy server
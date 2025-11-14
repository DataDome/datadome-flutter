#!/usr/bin/env bash

# fail if any commands fails
set -e

# debug log
set -x

POST=$(awk '/## '${BITRISE_GIT_TAG}'/{flag=1;next}/^## /{flag=0}flag' $DOCUMENTATION_FILE_PATH)
POST_BODY=$(sed 's/$/\\n/' <<<"$POST" | tr -d '\n')

# BITRISE_README_TOKEN is the readme.com token, stored in the Bitrise secret manager
curl --request POST \
     --url https://dash.readme.com/api/v1/changelogs \
     --header "authorization: Basic ${BITRISE_README_TOKEN}" \
     --header 'content-type: application/json' \
     --data '
{
  "hidden": true,
  "title": "'"Flutter HTTP SDK ${BITRISE_GIT_TAG}"'",
  "body": "'"$POST_BODY"'"
}
'
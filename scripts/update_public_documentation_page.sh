#!/usr/bin/env bash

# fail if any commands fails
set -e

# debug log
set -x

FILE_BODY=$(sed 's/$/\\n/' $DOCUMENTATION_FILE_PATH | tr -d '\n')

curl --request PUT \
     --url https://docs.datadome.co/docs/$PUBLIC_CHANGELOG_PAGE_SLUG \
     --header 'accept: application/json' \
     --header "authorization: Basic ${BITRISE_README_TOKEN}" \
     --header 'content-type: application/json' \
     --data '
    {
  "body": "'"$FILE_BODY"'"
  }
  '
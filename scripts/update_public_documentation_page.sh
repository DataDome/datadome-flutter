#!/usr/bin/env bash

# fail if any commands fails
set -e

# debug log
set -x

# privacy_view options:
README_PAGE_VISIBILITY_PRIVATE="anyone_with_link"
README_PAGE_VISIBILITY_PUBLIC ="public"
README_DEFAULT_BRANCH_NAME="stable"

FILE_BODY=$(cat $DOCUMENTATION_FILE_PATH)

jq -n --arg body "${FILE_BODY}" --arg privacy_view "${README_PAGE_VISIBILITY_PUBLIC}" \
    '{content: {body: $body}, privacy: {view: $privacy_view}}' > changelog.json

curl --request PATCH \
     --url "https://api.readme.com/v2/branches/${README_DEFAULT_BRANCH_NAME}/guides/${README_CHANGELOG_SLUG}" \
     --header 'accept: application/json' \
     --header "authorization: Bearer ${BITRISE_README_TOKEN}" \
     --header 'content-type: application/json' \
     --data @changelog.json

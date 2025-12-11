#!/usr/bin/env bash

# fail if any commands fails
set -e

# debug log
set -x

# privacy_view options:
README_RSS_ENTRY_VISIBILITY_PRIVATE="anyone_with_link"
README_RSS_ENTRY_VISIBILITY_PUBLIC ="public"

# Extract the CHANGELOG section corresponding to the specified TAG
POST_BODY=$(awk '/## '${BITRISE_GIT_TAG}'/{flag=1;next}/^## /{flag=0}flag' $DOCUMENTATION_FILE_PATH)

jq -n --arg body "${POST_BODY}" --arg title "Flutter HTTP SDK ${BITRISE_GIT_TAG}" --arg privacy_view "${README_PUBLIC_PUBLICATION}" \
    '{title: $title, content: {body: $body}, privacy: {view: $privacy_view}}' > changelog_rss_release.json

# BITRISE_README_TOKEN is the readme.com token, stored in the Bitrise secret manager
curl --request POST \
     --url "https://api.readme.com/v2/changelogs" \
     --header "authorization: Bearer ${BITRISE_README_TOKEN}" \
     --header "content-type: application/json" \
     --data @changelog_rss_release.json
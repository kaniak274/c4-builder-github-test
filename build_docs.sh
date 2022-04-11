#!/bin/sh

set -e

CONTEXT_FILE="$(openssl rand -base64 12)_context.svg"
SYSTEM_FILE="$(openssl rand -base64 12)_system.svg"
CONTAINER_FILE="$(openssl rand -base64 12)_container.svg"
REPO="$1"

mv ./generated/context.svg "$REPO.wiki/$CONTEXT_FILE"
mv ./generated/Test/system.svg "$REPO.wiki/$SYSTEM_FILE"
mv ./generated/Test/Backend/container.svg "$REPO.wiki/$CONTAINER_FILE"

cd $REPO.wiki
git config --global user.email "kaniak274@gmail.com"
git config --global user.name "Kamil Kucharski"

CUSTOM_FILE = """
## C1 Diagram

![context]($CONTEXT_FILE)

## C2 Diagram

![context]($SYSTEM_FILE)

## Backend C3 Diagram

![context]($CONTAINER_FILE)

"""

echo "$CUSTOM_FILE" > Custom.md

git add "$CONTEXT_FILE"
git add "$SYSTEM_FILE"
git add "$CONTAINER_FILE"
git add Custom.md

git diff-index --quiet HEAD || git commit -m "Update diagrams"
git push

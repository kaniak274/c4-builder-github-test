#!/bin/sh

set -e

REPO="$1"

### Generate hashes of the files to remove caching issues. 
CONTEXT_FILE="$(openssl rand -hex 12)_context.svg"
SYSTEM_FILE="$(openssl rand -hex 12)_system.svg"
CONTAINER_FILE="$(openssl rand -hex 12)_container.svg"

### Recreate diagrams directory.
rm -rf "$REPO.wiki/diagrams/"
mkdir "$REPO.wiki/diagrams/"

### Copy diagrams with hash.
cp ./generated/context.svg "$REPO.wiki/diagrams/$CONTEXT_FILE"
cp ./generated/Test/system.svg "$REPO.wiki/diagrams/$SYSTEM_FILE"
cp ./generated/Test/Backend/container.svg "$REPO.wiki/diagrams/$CONTAINER_FILE"

cd $REPO.wiki

### Set git configs to push to the WIKI
git config --global user.email "kaniak274@gmail.com"
git config --global user.name "Kamil Kucharski"

### Create wiki page based on the template with injected hashed files.
cat > Custom.md <<- EOM
## C1 Diagram

![context]($CONTEXT_FILE)

## C2 Diagram

![context]($SYSTEM_FILE)

## Backend C3 Diagram

![context]($CONTAINER_FILE)

EOM

### Push changes to the WIKI.
git add diagrams/
git add Custom.md

git diff-index --quiet HEAD || git commit -m "Update diagrams"
git push

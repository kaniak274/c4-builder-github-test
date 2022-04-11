#!/bin/sh

set -e

REPO="$1" ### Path to the repository.
WIKI_PAGE="$2" ### Name of the WIKI file.
DOCS_PATH="$3" ### Path to the C4 files.

### Generate hashes of the files to remove caching issues.
### Using -hex to not generate the `/` inside a hash.
CONTEXT_FILE="$(openssl rand -hex 12)_context.svg"
SYSTEM_FILE="$(openssl rand -hex 12)_system.svg"
CONTAINER_FILE="$(openssl rand -hex 12)_container.svg"

### Recreate diagrams directory.
rm -rf "$REPO.wiki/diagrams/"
mkdir "$REPO.wiki/diagrams/"

### Copy diagrams with hash.
cp -r "$DOCS_PATH/" "$REPO.wiki/diagrams/"
#cp "$DOCS_PATH/context.svg" "$REPO.wiki/diagrams/$CONTEXT_FILE"
#cp "$DOCS_PATH/Test/system.svg" "$REPO.wiki/diagrams/$SYSTEM_FILE"
#cp "$DOCS_PATH/Test/Backend/container.svg" "$REPO.wiki/diagrams/$CONTAINER_FILE"

cd $REPO.wiki

### Set git configs to push to the WIKI
git config --global user.email "kaniak274@gmail.com"
git config --global user.name "Kamil Kucharski"

### Create wiki page based on the template with injected hashed files.
#cat > "$WIKI_PAGE" <<- EOM
### C1 Diagram
#
#![context_diagram](./diagrams/$CONTEXT_FILE)
#
### C2 Diagram
#
#![system_diagram](./diagrams/$SYSTEM_FILE)
#
### Backend C3 Diagram
#
#![backend_container_diagram](./diagrams/$CONTAINER_FILE)
#
#EOM
cat > "$WIKI_PAGE" <<- EOM
[test](./diagrams/Test.md)
EOM

### Push changes to the WIKI.
git add diagrams/
git add "$WIKI_PAGE"

git diff-index --quiet HEAD || git commit -m "Update diagrams"
git push

#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

CONTAINER_1=$(docker run -it -d $1)
CONTAINER_2=$(docker run -it -d $2)

DUMPFILE_1="/tmp/$1.fsdump"
DUMPFILE_2="/tmp/$2.fsdump"
echo "Containers started, beginning export to files $DUMPFILE_1 and $DUMPFILE_2"

docker export $CONTAINER_1 | tar tv > $DUMPFILE_1
docker export $CONTAINER_2 | tar tv > $DUMPFILE_2

docker container stop $CONTAINER_1
docker container stop $CONTAINER_2

echo "Removing timestamp info from filesystem dump before diffing..."

python3 $SCRIPT_DIR/clean_dump.py $DUMPFILE_1
python3 $SCRIPT_DIR/clean_dump.py $DUMPFILE_2

diff "$DUMPFILE_1.processed" "$DUMPFILE_2.processed"

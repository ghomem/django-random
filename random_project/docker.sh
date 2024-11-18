#!/bin/bash

COMMAND=""
DJANGO_PORT=8000

usage() {
    echo "Usage:"
    echo "  $0 --build                 # Build docker image"
    echo "  $0 --run [puerto]          # Run the container in a specific port (default: 8000)"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --build)
            COMMAND="build"
            shift
            ;;
        --run)
            COMMAND="run"
            shift
            if [ -n "$1" ] && [[ "$1" =~ ^[0-9]+$ ]]; then
                DJANGO_PORT="$1"
                shift
            fi
            ;;
        *)
            echo "Unknown: $1"
            usage
            ;;
    esac
done

if [ "$COMMAND" == "build" ]; then
    docker build -t random_project .
elif [ "$COMMAND" == "run" ]; then
    docker run -p "$DJANGO_PORT":"$DJANGO_PORT" \
    -v "$(pwd)/db:/app/db" \
    -e DJANGO_PORT="$DJANGO_PORT" \
    -e DJANGO_DB_PATH="/app/db/db.sqlite3" \
    random_project
else
    usage
fi

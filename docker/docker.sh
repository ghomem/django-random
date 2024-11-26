#!/bin/bash

COMMAND=""
DJANGO_PORT=8000
CONTAINER_NAME="random_project_container"
IMAGE_NAME="random_project"

usage() {
    echo "Usage:"
    echo "  $0 --build                 # Build docker image" 
    echo "  $0 --create [port]         # Create the container in a specific port (default: 8000)" 
    echo "  $0 --start                 # Start the container previously created" 
    echo "  $0 --logs                  # Show the logs of the container running" 
    echo "  $0 --stop                  # Stop the container " 
    echo "  $0 --remove                # Remove the container " 
    exit 1
}
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: Please run this script as root."
        exit 1
    fi
}
check_container_exists() {
    docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -wq "$CONTAINER_NAME"
}

check_container_running() {
    docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -wq "$CONTAINER_NAME"
}
check_image_exists() {
    docker images --format "{{.Repository}}" | grep -wq "$IMAGE_NAME"
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
        --create)
            COMMAND="create"
            shift
            if [ -n "$1" ] && [[ "$1" =~ ^[0-9]+$ ]]; then
                DJANGO_PORT="$1"
                shift
            fi
            ;;
        --start)
            COMMAND="start"
            shift
            ;;
        --logs)
            COMMAND="logs"
            shift
            ;;
        --stop)
            COMMAND="stop"
            shift
            ;;
            
        --remove)
            COMMAND="remove"
            shift
            ;;
        *)
            echo "Unknown: $1"
            usage
            ;;
    esac
done

check_root


if [ "$COMMAND" == "build" ]; then
    docker build -t $IMAGE_NAME -f Dockerfile ..

elif [ "$COMMAND" == "create" ]; then
    if ! check_image_exists; then
        echo "Error: Image does not exist. Please build the image first using --build."
        exit 1
    fi
    if check_container_exists; then
        echo "Error: Container is already created."
        exit 1
    fi
    docker create --name $CONTAINER_NAME \
    -p $DJANGO_PORT:$DJANGO_PORT \
    -e DJANGO_PORT="$DJANGO_PORT" \
    $IMAGE_NAME
    
elif [ "$COMMAND" == "start" ]; then
    if ! check_container_exists; then
        echo "Error: Container is not created. Please create the container first using --create"
        exit 1
    fi
    if check_container_running; then
        echo "Error: Container is already running."
        exit 1
    fi
    docker start $CONTAINER_NAME

elif [ "$COMMAND" == "logs" ]; then
    if ! check_container_exists; then
        echo "Error: Container is not created."
        exit 1
    fi
    if ! check_container_running; then
        echo "Error: Container is not running."
        exit 1
    fi
    docker logs $CONTAINER_NAME

elif [ "$COMMAND" == "stop" ]; then
    if ! check_container_exists; then
        echo "Error: Container is not created."
        exit 1
    fi
    if ! check_container_running; then
        echo "Error: Container is not running."
        exit 1
    fi    
    docker stop $CONTAINER_NAME

elif [ "$COMMAND" == "remove" ]; then
    if ! check_container_exists; then
        echo "Error: Container is not created."
        exit 1
    fi
    if check_container_running; then
        echo "Error: Container is still running.Please stop the container first using --stop"
        exit 1
    fi
    docker rm $CONTAINER_NAME
else
    usage
fi
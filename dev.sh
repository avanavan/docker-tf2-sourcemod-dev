#!/bin/bash

# Usage: ./dev.sh [build|run|stop|clean|logs|shell]

set -e

IMAGE_NAME="tf2-sourcemod-dev"
CONTAINER_NAME="dev"
TAG="dev"

case "$1" in
    build)
        echo "=== Building Docker image with detailed output ==="
        docker build \
            --progress=plain \
            --no-cache \
            -t ${IMAGE_NAME}:${TAG} \
            .
        echo "=== Build completed ==="
        ;;
    
    run)
        echo "=== Stopping and removing existing container if it exists ==="
        docker stop ${CONTAINER_NAME} 2>/dev/null || true
        docker rm ${CONTAINER_NAME} 2>/dev/null || true
        
        echo "=== Running new container ==="
        docker run -dit \
            --name ${CONTAINER_NAME} \
            --net=host \
            -v ./external:/external \
            ${IMAGE_NAME}:${TAG}
        
        echo "=== Container started ==="
        echo "Container name: ${CONTAINER_NAME}"
        echo "Ports: 27015 (UDP/TCP), 27021 (TCP), 27020 (UDP)"
        ;;
    
    stop)
        echo "=== Stopping container ==="
        docker stop ${CONTAINER_NAME} || echo "Container not running"
        ;;
    
    clean)
        echo "=== Cleaning up container and image ==="
        docker stop ${CONTAINER_NAME} 2>/dev/null || true
        docker rm ${CONTAINER_NAME} 2>/dev/null || true
        docker rmi ${IMAGE_NAME}:${TAG} 2>/dev/null || true
        echo "=== Cleanup completed ==="
        ;;
    
    logs)
        echo "=== Container logs ==="
        docker logs -f ${CONTAINER_NAME}
        ;;
    
    shell)
        echo "=== Opening shell in container ==="
        docker exec -it ${CONTAINER_NAME} /bin/bash
        ;;
    
    rebuild)
        echo "=== Full rebuild: clean + build + run ==="
        $0 clean
        $0 build
        $0 run
        ;;
    
    status)
        echo "=== Container status ==="
        docker ps -a --filter name=${CONTAINER_NAME}
        echo ""
        echo "=== Image info ==="
        docker images --filter reference=${IMAGE_NAME}:${TAG}
        ;;
    
    *)
        echo "Usage: $0 {build|run|stop|clean|logs|shell|rebuild|status}"
        echo ""
        echo "Commands:"
        echo "  build    - Build the Docker image with detailed output"
        echo "  run      - Stop existing container and run a new one"
        echo "  stop     - Stop the running container"
        echo "  clean    - Stop and remove container and image"
        echo "  logs     - Show container logs (follow mode)"
        echo "  shell    - Open bash shell in running container"
        echo "  rebuild  - Full clean, build, and run cycle"
        echo "  status   - Show container and image status"
        echo ""
        echo "  $0 rebuild"
        exit 1
        ;;
esac
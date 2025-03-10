
# Podman or Docker executable
PODMAN_COMPOSE := "podman-compose"
DOCKER_COMPOSE := "docker compose"
COMPOSE_FILE := "-f docker-compose.yaml"

# Check if the podman is available
CONTAINER_EXECUTABLE := if shell('command -v ' + DOCKER_COMPOSE ) != "" { DOCKER_COMPOSE } else { PODMAN_COMPOSE }

# List of command
default:
    @just --list

# Start services (and build if needed)
up:
    touch .env.override
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} --env-file .env --env-file .env.override up -d --build

# Start services (without recreate or build)
start:
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} start

# Stop the services
stop:
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} stop

# Bring the stack down
down:
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} down

# Show the current status
@ps:
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} ps

# Show the logs of the service provided as parameter
@logs SERVICE:
    {{CONTAINER_EXECUTABLE}} {{COMPOSE_FILE}} logs {{SERVICE}}
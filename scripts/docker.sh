
# check if file docker-compose-file exists 
if [[ -f docker-compose-file ]]; then
    export DOCKER_COMPOSE_FILE=$(cat docker-compose-file)
fi

docker() {
    case "$1" in
    compose)
        shift

        if [[ -n "${DOCKER_COMPOSE_FILE}" ]]; then
        command docker compose -f "${DOCKER_COMPOSE_FILE}" "$@"
        else
        command docker compose "$@"
        fi
        ;;
    *)
        command docker "$@"
        ;;
    esac
}
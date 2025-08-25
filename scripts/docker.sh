

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
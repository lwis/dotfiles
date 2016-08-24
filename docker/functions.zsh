docker-stats() {
    docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))
}

docker-log() {
    docker-compose logs -f
}

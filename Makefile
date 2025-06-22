COMPOSE_FILE = srcs/docker-compose.yml

all: build up

build:
    @echo "A construir as imagens Docker..."
    docker-compose -f $(COMPOSE_FILE) build

up:
    @echo "A iniciar os serviços..."
    docker-compose -f $(COMPOSE_FILE) up -d

down:
    @echo "A parar os serviços..."
    docker-compose -f $(COMPOSE_FILE) down

clean:
    @echo "A parar e a remover contentores, redes e volumes..."
    docker-compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans

re: clean all

.PHONY: all build up down clean re
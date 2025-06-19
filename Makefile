COMPOSE = docker compose -f srcs/docker-compose.yml

# alvo padrão: constrói e sobe
.DEFAULT_GOAL := all
all: build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

fclean: down
	rm -rf ~/data/mariadb ~/data/wordpress

re: fclean build up
.PHONY: all build up down fclean re
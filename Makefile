LOGIN ?= $(shell id -un)
COMPOSE = docker compose -f srcs/docker-compose.yml

.DEFAULT_GOAL := all
all: build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

fclean: down
	 rm -rf /home/$(LOGIN)/data/mariadb /home/$(LOGIN)/data/wordpress

re: fclean build up

.PHONY: all build up down fclean re

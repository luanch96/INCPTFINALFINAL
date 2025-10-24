

COMPOSE_CMD = docker-compose -f srcs/docker-compose.yml
DOMAIN_NAME ?= luisanch.42.fr

export DOMAIN_NAME

.PHONY: all build up run down restart clean fclean test

all: run

build:
	$(COMPOSE_CMD) build

up:
	$(COMPOSE_CMD) up -d

run: build up
	@echo "✅ Todos los contenedores se han iniciado correctamente."
	@echo "🌐 Accede a https://$(DOMAIN_NAME)"

down:
	$(COMPOSE_CMD) down -v

restart: down up

clean:
	@docker stop $$(docker ps -qa) 2>/dev/null || true; \
	docker rm $$(docker ps -qa) 2>/dev/null || true; \
	docker rmi -f $$(docker images -qa) 2>/dev/null || true; \
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true; \
	docker network rm $$(docker network ls -q) 2>/dev/null || true; \
	docker system prune -f --volumes

fclean: clean
	sudo rm -rf /home/luisanch/data/mariadb/*
	sudo rm -rf /home/luisanch/data/wordpress/*
	@echo "🗑️  Todo limpio ✅"

setup:
	@echo "📁 Creando directorios para volúmenes..."
	sudo mkdir -p /home/luisanch/data/mariadb
	sudo mkdir -p /home/luisanch/data/wordpress
	sudo mkdir -p /home/luisanch/data/ssl
	sudo chown -R luisanch:luisanch /home/luisanch/data/
	@echo "🔐 Generando certificados SSL para $(DOMAIN_NAME)..."
	./srcs/requirements/nginx/tools/generate-ssl.sh
	@echo "✅ Directorios creados correctamente"

test:
	@echo "🧪 Ejecutando pruebas de conectividad..."
	@./test-connectivity.sh
	@echo ""
	@echo "🧪 Verificando base de datos..."
	@./check-database.sh

info:
	@echo "🌐 Servicios disponibles:"
	@echo "  WordPress: https://$(DOMAIN_NAME)"
	@echo ""
	@echo "📊 Estado de contenedores:"
	@$(COMPOSE_CMD) ps
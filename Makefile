.PHONY: init up down restart build logs status

## First-time setup — copy example files to .env and config/servers.conf
init:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✔  Created .env"; \
	else \
		echo ".env already exists — skipping"; \
	fi
	@if [ ! -f config/servers.conf ]; then \
		cp config/servers.conf.example config/servers.conf; \
		echo "✔  Created config/servers.conf"; \
	else \
		echo "config/servers.conf already exists — skipping"; \
	fi

## Start all containers in the background
up:
	docker compose up -d

## Stop and remove containers (keeps the generated config volume)
down:
	docker compose down

## Reload config: picks up changes in config/servers.conf
restart:
	docker compose restart

## Rebuild the db-hub image (needed after editing Dockerfile.tunnels or entrypoint.py)
build:
	docker compose build --no-cache db-hub

## Tail logs for all containers  (Ctrl-C to exit)
logs:
	docker compose logs -f

## Show container status
status:
	docker compose ps

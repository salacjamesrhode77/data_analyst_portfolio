network:
	docker network create maven-network

remove-network:
	docker network rm maven-network

build:
	docker compose build --no-cache

up:
	docker-compose up -d

down:
	docker compose down -v

clean:
	docker compose down -v --rmi all
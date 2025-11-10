HOST_DIR=host_anguinau
ROUTER_DIR=router_anguinau

HOST_NAME=host_anguinau
ROUTER_NAME=router_anguinau

TAG=p1

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST_NAME):$(TAG)" "$(HOST_DIR)"
	@docker build -t "$(ROUTER_NAME):$(TAG)" "$(ROUTER_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker ps -a | tail -n+2 | cut -d ' ' -f 1 | xargs docker rm -f
	-@docker image prune -f

	-@docker rmi "$(HOST_NAME):$(TAG)"
	-@docker rmi "$(ROUTER_NAME):$(TAG)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -fa

	@echo "Docker system prune complete."

re: clean build

.PHONY: all build clean fclean re

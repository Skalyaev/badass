HOST-1_DIR=host_anguinau-1
HOST-2_DIR=host_anguinau-2
HOST-3_DIR=host_anguinau-3
ROUTER_1_DIR=router_anguinau-1
ROUTER-2_DIR=router_anguinau-2
ROUTER-3_DIR=router_anguinau-3
ROUTER-4_DIR=router_anguinau-4

HOST-1_NAME=host_anguinau-1
HOST-2_NAME=host_anguinau-2
HOST-3_NAME=host_anguinau-3
ROUTER_1_NAME=router_anguinau-1
ROUTER-2_NAME=router_anguinau-2
ROUTER-3_NAME=router_anguinau-3
ROUTER-4_NAME=router_anguinau-4

TAG=p3

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST-1_NAME):$(TAG)" "$(HOST-1_DIR)"
	@docker build -t "$(HOST-2_NAME):$(TAG)" "$(HOST-2_DIR)"
	@docker build -t "$(HOST-3_NAME):$(TAG)" "$(HOST-3_DIR)"
	@docker build -t "$(ROUTER_1_NAME):$(TAG)" "$(ROUTER_1_DIR)"
	@docker build -t "$(ROUTER-2_NAME):$(TAG)" "$(ROUTER-2_DIR)"
	@docker build -t "$(ROUTER-3_NAME):$(TAG)" "$(ROUTER-3_DIR)"
	@docker build -t "$(ROUTER-4_NAME):$(TAG)" "$(ROUTER-4_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker ps -a | tail -n+2 | cut -d ' ' -f 1 | xargs docker rm -f
	-@docker image prune -f

	-@docker rmi "$(HOST-1_NAME):$(TAG)"
	-@docker rmi "$(HOST-2_NAME):$(TAG)"
	-@docker rmi "$(HOST-3_NAME):$(TAG)"
	-@docker rmi "$(ROUTER_1_NAME):$(TAG)"
	-@docker rmi "$(ROUTER-2_NAME):$(TAG)"
	-@docker rmi "$(ROUTER-3_NAME):$(TAG)"
	-@docker rmi "$(ROUTER-4_NAME):$(TAG)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -fa

	@echo "Docker system prune complete."

re: clean build

.PHONY: all build clean fclean re

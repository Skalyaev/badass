HOST-1_DIR=host_anguinau-1
HOST-2_DIR=host_anguinau-2
ROUTER-1_DIR=router_anguinau-1
ROUTER-2_DIR=router_anguinau-2
SWITCH_DIR=switch_anguinau

HOST-1_NAME=host_anguinau-1
HOST-2_NAME=host_anguinau-2
ROUTER-1_NAME=router_anguinau-1
ROUTER-2_NAME=router_anguinau-2
SWITCH_NAME=switch_anguinau

TAG=p2

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST-1_NAME):$(TAG)" "$(HOST-1_DIR)"
	@docker build -t "$(HOST-2_NAME):$(TAG)" "$(HOST-2_DIR)"
	@docker build -t "$(ROUTER-1_NAME):$(TAG)" "$(ROUTER-1_DIR)"
	@docker build -t "$(ROUTER-2_NAME):$(TAG)" "$(ROUTER-2_DIR)"
	@docker build -t "$(SWITCH_NAME):$(TAG)" "$(SWITCH_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker ps -a | tail -n+2 | cut -d ' ' -f 1 | xargs docker rm -f
	-@docker image prune -f

	-@docker rmi "$(HOST-1_NAME):$(TAG)"
	-@docker rmi "$(HOST-2_NAME):$(TAG)"
	-@docker rmi "$(ROUTER-1_NAME):$(TAG)"
	-@docker rmi "$(ROUTER-2_NAME):$(TAG)"
	-@docker rmi "$(SWITCH_NAME):$(TAG)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -fa

	@echo "Docker system prune complete."

re: clean build

.PHONY: all build clean fclean re

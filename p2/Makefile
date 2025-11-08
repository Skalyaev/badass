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

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST-1_NAME)" "$(HOST-1_DIR)"
	@docker build -t "$(HOST-2_NAME)" "$(HOST-2_DIR)"
	@docker build -t "$(ROUTER-1_NAME)" "$(ROUTER-1_DIR)"
	@docker build -t "$(ROUTER-2_NAME)" "$(ROUTER-2_DIR)"
	@docker build -t "$(SWITCH_NAME)" "$(SWITCH_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker rmi "$(HOST-1_NAME)"
	-@docker rmi "$(HOST-2_NAME)"
	-@docker rmi "$(ROUTER-1_NAME)"
	-@docker rmi "$(ROUTER-2_NAME)"
	-@docker rmi "$(SWITCH_NAME)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -fa

	@echo "Docker system prune complete."

re: fclean build

.PHONY: all build clean fclean re

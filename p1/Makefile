HOST_DIR=host_anguinau
ROUTER_DIR=router_anguinau

HOST_NAME=host_anguinau
ROUTER_NAME=router_anguinau

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST_NAME)" "$(HOST_DIR)"
	@docker build -t "$(ROUTER_NAME)" "$(ROUTER_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker rmi "$(HOST_NAME)"
	-@docker rmi "$(ROUTER_NAME)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -fa

	@echo "Docker system prune complete."

re: fclean build

.PHONY: all build clean fclean re

HOST-1_DIR=host_anguinau
ROUTER-1_DIR=router_anguinau

HOST-1_NAME=host_anguinau
ROUTER-1_NAME=router_anguinau

all: build

build:
	@echo "Building Docker images..."

	@docker build -t "$(HOST-1_NAME)" "$(HOST-1_DIR)"
	@docker build -t "$(ROUTER-1_NAME)" "$(ROUTER-1_DIR)"

	@echo "Images built, you can now use them with GNS3."

clean:
	@echo "Cleaning up Docker images..."

	-@docker rmi "$(HOST-1_NAME)"
	-@docker rmi "$(ROUTER-1_NAME)"

	@echo "Cleanup complete."

fclean: clean
	@echo "Running Docker system prune..."

	-@docker system prune -f

	@echo "Docker system prune complete."

re: fclean build

.PHONY: all build clean fclean re

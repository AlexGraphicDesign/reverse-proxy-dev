up:
	@echo "Starting reverse-proxy-dev containers..."
	@docker-compose up --force-recreate -d
	@echo "Starting reverse-proxy-dev containers [OK]"

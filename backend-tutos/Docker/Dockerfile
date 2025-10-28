# Documentation : docs.docker.com/reference/dockerfile

# Image
FROM python:3.11-slim

# Define default Shell
SHELL ["zsh"]

# Copy files and directories
COPY . /app

# Change directory
WORKDIR /app

# Environment variables
ENV key=value \
	key2=value2

# Run commands
RUN echo "Hello" \
	apt-get update && apt-get upgrade -y \
	pip install --no-cache-dir -r requirements.txt \
	useradd app

# Set port
EXPOSE 8000

# Shared directory
VOLUME /app/logs

# Set the user name to use for running any RUN, CMD, and ENTRYPOINT instructions that follow.
USER app

# Set default executable for application
CMD ["python3.11", "src/main.py", "-option"]

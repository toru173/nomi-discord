#!/bin/bash

# Check for a .env file, and use the values from there if present
if [ -f .env ]; then
  # Advanced Users:
  #
  # Load environment variables from .env file
  source .env
  echo ".env file found and loaded."
else
  # Otherwise, you can set up you Nomi container here!
  #
  # Change the value in quotation marks to change the default name for your companion
  # You may want to do this if you're running multiple instances of this bot
  # Ex: COMPANION_NAME = "friend_1"
  COMPANION_NAME="friend_1"
  read -p "Companion Name (name of the Docker container) is set to $COMPANION_NAME - is this okay? Press Enter to accept this name or enter another one: " NAME

  if [ -n "$NAME" ]; then
    COMPANION_NAME=$NAME
  fi

  read -p "Enter Discord Token: " DISCORD_BOT_TOKEN
  read -p "Enter Nomi API Key: " NOMI_TOKEN
  read -p "Enter Nomi AI ID for your companion: " NOMI_ID
fi

# Converts the companion's name to lower case, replaces
# non-valid charactes with an underscore and strips any
# trailing underscores
DOCKER_IMAGE_NAME=$(echo "$COMPANION_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9.-' '_' | sed 's/_*$//')

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
docker container rm $DOCKER_IMAGE_NAME -f
docker build -t $DOCKER_IMAGE_NAME "$SCRIPT_ROOT"
docker run -d --name $DOCKER_IMAGE_NAME -e DISCORD_BOT_TOKEN=$DISCORD_BOT_TOKEN -e NOMI_TOKEN=$NOMI_TOKEN -e NOMI_ID=$NOMI_ID $DOCKER_IMAGE_NAME

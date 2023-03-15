#!/bin/bash

# Retrieve a random champion from ddragon's Riot API
# Store the response from the API in a variable
CHAMPION_RESPONSE="$(curl -s "https://ddragon.leagueoflegends.com/api/versions.json")"

# Parse the response, and get the latest version
VERSION="$(echo "${CHAMPION_RESPONSE}" | jq ".[0]" | sed tr -d "\"")"

# Get the list of champions
CHAMPION_LIST=$(curl -s "https://ddragon.leagueoflegends.com/cdn/$VERSION/data/en_US/champion.json")

# Get a random champion
RANDOM_CHAMPION=$(echo $CHAMPION_LIST | jq '.data | keys | .[]' | shuf -n1 | tr -d '"')

# Output the champion name
echo $RANDOM_CHAMPION

#!/bin/bash

## Ask user for language
echo "Please enter the language of your choice (e.g. en_US, es_ES, etc.)"
read LANGUAGE

## Retrieve a random champion from ddragon's Riot API

VERSION="$(curl -s "https://ddragon.leagueoflegends.com/api/versions.json" | jq ".[0]" | tr -d "\"")"

# Setting the variable `DDRAGON_URL` to the URL of the latest version of the champion data.
DDRAGON_URL="https://ddragon.leagueoflegends.com/cdn/$VERSION/data/$LANGUAGE/"

# Get random champion id

RANDOM_CHAMPION="$(echo '$DDRAGON_URL/champion.json' | jq '.data | keys | .[]' | shuf -n1 | tr -d '"')





























# champion_id=$(curl -s "https://ddragon.leagueoflegends.com/cdn/9.21.1/data/$LANGUAGE/champion.json" | jq -r '.data | keys | .[]' | shuf -n1)

# # Get random ability
# abilities=$(curl -s "https://ddragon.leagueoflegends.com/cdn/9.21.1/data/$LANGUAGE/champion/$champion_id.json" | jq -r '.data[].spells | .[]')

# # Get random ability from champion
# random_ability=$(echo $abilities | jq -r '.description' | shuf | head -n1)

# # Get champion name
# champion_name=$(curl -s "https://ddragon.leagueoflegends.com/cdn/9.21.1/data/$LANGUAGE/champion.json" | jq -r ".data[\"$champion_id\"].name")

# # Display ability and ask user to guess champion
# echo "Which champion has the ability: $random_ability"
# echo "Enter the champion name:"
# read user_guess

# if [ "$user_guess" == "$champion_name" ]; then
#   echo "Correct!"
# else
#   echo "Incorrect, it was $champion_name"
# fi

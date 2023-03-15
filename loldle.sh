#!/bin/bash

clear

# ## Ask user for language
# echo "Please enter the language of your choice (e.g. en_US, es_ES, etc.)"
# read LANGUAGE
LANGUAGE="en_US"

## Retrieve a random Champion from Riot's DDragon API
# Getting the latest version of the champion data.
VERSION="$(curl -s "https://ddragon.leagueoflegends.com/api/versions.json" | jq ".[0]" | tr -d "\"")"

# Setting the variable `DDRAGON_URL` to the URL of the latest version of the champion data.
DDRAGON_URL="https://ddragon.leagueoflegends.com/cdn/$VERSION/data/$LANGUAGE"

# It's getting the champion data from the Riot API, and then using `jq` to parse the JSON data and get
# the keys of the `data` object. Then, it's using `shuf` to shuffle the keys and get a random one.
# Finally, it's removing the quotes from the key.
RANDOM_CHAMPION="$(curl -s "${DDRAGON_URL}/champion.json" | jq ".data | keys | .[]" | shuf -n1 | tr -d "\"")"

#Care Accent K'Sante = Ksante / LeBlanc = Leblanc "Mantra" "Nunu & Willump" = Nunu
RANDOM_ABILITY="$(curl -s "${DDRAGON_URL}/champion/${RANDOM_CHAMPION}.json" | jq -r ".data[].spells | .[] | .description" | shuf | head -n1 | sed "s/<[^>]*>//g" | sed "s/${RANDOM_CHAMPION}/???/g")"

echo "Guess the Champion: \"${RANDOM_ABILITY}\""

read YN

echo "${RANDOM_CHAMPION}"

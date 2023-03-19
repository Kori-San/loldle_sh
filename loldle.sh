#!/bin/bash

### Parameters
# Language from "https://ddragon.leagueoflegends.com/cdn/languages.json"
LANGUAGE="fr_FR"

# Number of tries
TRIES="3"

### Variables
# It's creating an array called `PKGS` containing all dependencies.
PKGS=(jq curl sed coreutils)  # coreutils -> (shuf head tr)

# Getting the latest version of the champion data.
VERSION="$(curl -s "https://ddragon.leagueoflegends.com/api/versions.json" | jq ".[0]" | tr -d "\"")"

# Setting the variable `DDRAGON_URL` to the URL of the latest version of the champion data.
DDRAGON_URL="https://ddragon.leagueoflegends.com/cdn/$VERSION/data/$LANGUAGE"

# Total Score
SCORE="0"

### Functions
# It's checking if a package is installed.
check_pkg() {
    if ! dpkg --list | cut -d " " -f3 | grep -v "lib" | grep "${1}" > /dev/null; then
        echo "${1} need to be installed"
        exit 1
    fi

    return 0
}

# Generate a random Champion and a random Ability
gen_new_ability() {
    # It's getting the champion data from the Riot API, and then using `jq` to parse the JSON data and get
    # the keys of the `data` object. Then, it's using `shuf` to shuffle the keys and get a random one.
    # Finally, it's removing the quotes from the key.
    RANDOM_CHAMPION="$(curl -s "${DDRAGON_URL}/champion.json" | jq ".data | keys | .[]" | shuf -n1 | tr -d "\"")"


    # Get the full name of the Champion, full name contain spaces, apostrophes and other characters that are not used in a champion's json file's name
    RANDOM_CHAMPION_NAME="$( curl -s "${DDRAGON_URL}/champion/${RANDOM_CHAMPION}.json" | jq -r ".data[] | .name")"

    # Get a random Ability, takes its descriptions and remove all <tags>. Finally sed is used to remove the Champion's name and replace it by ???
    RANDOM_ABILITY="$(curl -s "${DDRAGON_URL}/champion/${RANDOM_CHAMPION}.json" | jq -r ".data[].spells | .[] | .description" | shuf | head -n1 | sed "s/<[^>]*>//g" | sed "s/${RANDOM_CHAMPION_NAME}/???/g")"

    # Display a random Ability from the random Champion
    echo "-- Anonymous Ability --"
    echo "\"${RANDOM_ABILITY}\""
}

### Start of Script
# It's looping through the array `PKGS` and calling the function `check_pkg` with the value of the array as the argument.
for package in "${PKGS[@]}"; do
    check_pkg "${package}"
done

# # Clear for user readability
# clear

# Main Title & newline for readability
echo "~ Guess the Champion from an Ability ~" && echo ""

# Generate and display new Ability & add newline for readability
gen_new_ability && echo ""

# Game Loop
while [ "${TRIES}" -gt "0" ] ; do
    read -r -p "${TRIES} lives left: " USER_CHAMPION

    if [ "${USER_CHAMPION,,}" != "${RANDOM_CHAMPION,,}" ] && [ "${USER_CHAMPION,,}" != "${RANDOM_CHAMPION_NAME,,}" ]; then
        # Newline for readability
        echo "" && echo "Wrong guess, try again !" 
        TRIES=$((TRIES - 1))

    elif [ "${USER_CHAMPION,,}" == "${RANDOM_CHAMPION,,}" ] || [ "${USER_CHAMPION,,}" == "${RANDOM_CHAMPION_NAME,,}" ]; then
        # Newlines for readability
        echo "" && echo "You're right !" && echo "" && SCORE=$((SCORE + 1))
        gen_new_ability
    fi

    # Newline for readability
    echo ""
done

echo "The Champion was: ${RANDOM_CHAMPION_NAME}"
echo "Total Score = ${SCORE}"
exit 0
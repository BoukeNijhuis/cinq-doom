#!/bin/bash

# Set where you want the output file, make sure to use a .json extension.
OUTPUT_FILE="$HOME/user_data.json"

# Set the title (top bar of dialog) and explanation texts
TITLE="Welcome to the Cinq DOOM Game"
EXPLAIN="The game works as follows:\n
Register name and email. \
When submitted the timer will start and you \
have 5 minutes to correct the code in the project and then finish the game within 5 minutes. \
The final score will be based on the killcount and the remaining seconds left."

USER_INPUT=$(osascript <<EOL
set userInput to {"", ""}
try
    repeat
        set userInput to {display dialog "${EXPLAIN}" with title "${TITLE}", text returned of (display dialog "Enter your name:"\
        default answer item 1 of userInput with title "${TITLE}"), text returned of (display dialog "Enter your email:"\
        default answer item 2 of userInput with title "${TITLE}")}
        if (item 1 of userInput is not "") and (item 2 of userInput is not "") then exit repeat
    end repeat
on error
    return "CANCELLED"
end try
return userInput
EOL
)

# Make sure that if the cancel button is pressed, no data will be
if [ "$USER_INPUT" = "CANCELLED" ]; then
    echo "User cancelled input. No data saved."
    exit 0
fi

NAME=$(echo "$USER_INPUT" | awk -F, '{print $2}' | xargs)
EMAIL=$(echo "$USER_INPUT" | awk -F, '{print $3}' | xargs)

# Decided to go for the unix timestamp. If you'd rather have a date/time string,
# use the timestamp in comments below.
# TIMESTAMP=$(date "+%d-%m-%Y %H:%M:%S")
TIMESTAMP=$(date +%s)

NEW_ENTRY=$(jq -n --arg ts "$TIMESTAMP" --arg un "$NAME" --arg em "$EMAIL" '{name: $un, email: $em, starttime: $ts}')

if [ ! -f "$OUTPUT_FILE" ]; then
    echo "[$NEW_ENTRY]" > "$OUTPUT_FILE"
else
    # Decided to make use of a temp file as a safeguard to prevent data loss while executing.
    # Its up to you, you can also use the command in comment below to skip this safeguard.
    # jq --argjson newEntry "$NEW_ENTRY" '. + [$newEntry]' "$OUTPUT_FILE" > "$OUTPUT_FILE"
    jq --argjson newEntry "$NEW_ENTRY" '. + [$newEntry]' "$OUTPUT_FILE" > "$OUTPUT_FILE.tmp" && mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
fi

echo "Data saved to $OUTPUT_FILE"

# Open IntelliJ
open -a "IntelliJ IDEA"
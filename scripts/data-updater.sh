#!/bin/env bash

file=$(ls ../data/ | fzf --prompt "Choose a data file to strip: ")
# Get unique ids from the JSON file
id=$(jq -r 'map(.id) | unique[]' $file)

# Loop through each unique id
for i in $id; do
  echo "Running $i"

  # Filter the $file by id and output to a new file
  jq --arg id "$i" 'map(select(.id == $id))' $file >../data/"$i".json
done

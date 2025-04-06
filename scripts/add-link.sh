#!/usr/bin/env bash

check_command() {
  for cmd in "$@"; do
    if command -v "$cmd" &>/dev/null; then
      return 0
    else
      return 1
    fi
  done
}

check_command jq || {
  echo "jq is not installed. Please install it!"
  exit 1
}

while true; do
  check_command fzf
  val=$?
  if [[ "$val" -eq 0 ]]; then
    # FZF Choice
    id=$(ls ../data/ | awk -F '.' '{print $1}' | fzf --prompt "Enter the ID for the Link: ")
  else
    echo "Enter ID:"
    read -r id
  fi

  if [[ -z "$id" ]]; then
    echo "Create a new ID? (y/n)"
    read -r idcreate
    if [ "$idcreate" == "y" ]; then
      echo "Enter new ID:"
      read -r id
      newid=true
    else
      echo "Exiting..."
      break
    fi
  fi

  if [ -n "$id" ] || [ -f "./data/$id.json" ]; then
    if [[ "$val" -eq 0 ]]; then
      # FZF Choice
      sub_id=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .sub_id' ../data/$id.json | sort -u | fzf --prompt "Enter the SUB-ID (Category): ")
    else
      echo "Enter Sub-ID:"
      read -r sub_id
    fi
  else
    echo "Enter the ID for the link:"
    read -r sub_id
  fi

  if [[ -z "$sub_id" ]]; then
    echo "Create a new SUB-ID? (y/n)"
    read -r idcreate
    if [ "$idcreate" == "y" ]; then
      echo "Enter new SUB-ID (Category):"
      read -r sub_id
    else
      echo "Exiting..."
      break
    fi
  fi

  echo "Enter the Title of the link:"
  read -r title
  if [[ -z "$title" ]]; then
    echo "Exiting..."
    break
  fi

  echo "Enter the URL of the link:"
  read -r url
  if [[ -z "$url" ]]; then
    echo "Exiting..."
    break
  fi

  domain=$(echo "$url" | awk -F[/:] '{print $4}')
  icon_url="https://external-content.duckduckgo.com/ip3/$domain.ico"

  id_escaped=$(echo "$id" | sed 's/"/\\"/g')
  sub_id_escaped=$(echo "$sub_id" | sed 's/"/\\"/g')
  title_escaped=$(echo "$title" | sed 's/"/\\"/g')
  url_escaped=$(echo "$url" | sed 's/"/\\"/g')
  icon_url_escaped=$(echo "$icon_url" | sed 's/"/\\"/g')

  if [ -s ../data/$id.json ]; then
    jq --arg id "$id_escaped" --arg sub_id "$sub_id_escaped" --arg title "$title_escaped" --arg url "$url_escaped" --arg icon "$icon_url_escaped" \
      '. += [{"id": $id, "sub_id": $sub_id, "title": $title, "url": $url, "icon": $icon}]' ../data/$id.json >temp.json && mv temp.json ../data/$id.json
  else
    jq -n --arg id "$id_escaped" --arg sub_id "$sub_id_escaped" --arg title "$title_escaped" --arg url "$url_escaped" --arg icon "$icon_url_escaped" \
      '[{"id": $id, "sub_id": $sub_id, "title": $title, "url": $url, "icon": $icon}]' >../data/$id.json
  fi

  if [ "$newid" != "true" ]; then
    echo "Link added successfully to $id.json!"
  else
    if [ -n "$newid" ]; then
      echo "You have added a new ID!"
      echo "You must manually add a new button in the index.html!"
    else
      echo "Failed to add link!"
    fi
  fi
done

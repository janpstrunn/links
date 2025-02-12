#!/bin/bash

while true; do
  echo "Enter the ID for the link:"
  read id
  if [[ -z "$id" ]]; then
    echo "Exiting..."
    break
  fi

  echo "Enter the Sub ID (category or title):"
  read sub_id
  if [[ -z "$sub_id" ]]; then
    echo "Exiting..."
    break
  fi

  echo "Enter the Title of the link:"
  read title
  if [[ -z "$title" ]]; then
    echo "Exiting..."
    break
  fi

  echo "Enter the URL of the link:"
  read url
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

  if [ -s data/links.json ]; then
    jq --arg id "$id_escaped" --arg sub_id "$sub_id_escaped" --arg title "$title_escaped" --arg url "$url_escaped" --arg icon "$icon_url_escaped" \
      '. += [{"id": $id, "sub_id": $sub_id, "title": $title, "url": $url, "icon": $icon}]' data/links.json >temp.json && mv temp.json data/links.json
  else
    jq -n --arg id "$id_escaped" --arg sub_id "$sub_id_escaped" --arg title "$title_escaped" --arg url "$url_escaped" --arg icon "$icon_url_escaped" \
      '[{"id": $id, "sub_id": $sub_id, "title": $title, "url": $url, "icon": $icon}]' >data/links.json
  fi

  if [ $? -eq 0 ]; then
    echo "Link added successfully to links.json!"
  else
    echo "Failed to add link!"
  fi
done

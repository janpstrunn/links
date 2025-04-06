#!/usr/bin/env bash

username=$1
shift 1
name=$*

if [ -z "$username" ] || [ -z "$name" ]; then
  echo "Missing username or name"
  echo "Usage: setup <username> <name>"
  exit 1
fi

year=$(date +%Y)

sed -i -E "s/username/$username/g" ../index.html
sed -i -E "s/myName/$name/g" ../index.html
sed -i -E "s/year/$year/g" ../index.html

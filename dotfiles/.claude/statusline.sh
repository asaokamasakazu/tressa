#!/bin/bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
usage=$(echo "$input" | jq '.context_window.current_usage')

if [ "$usage" != "null" ]; then
  current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  size=$(echo "$input" | jq '.context_window.context_window_size')
  pct=$((current * 100 / size))
  printf '\033[36m%s\033[0m | \033[33m%d%% context\033[0m' "$model" "$pct"
else
  printf '\033[36m%s\033[0m | \033[90mno context yet\033[0m' "$model"
fi

#!/bin/bash

shopt -s nocasematch

query="{query}"
[ $query = "{query}" ] && query="$@"

IFS=' '
devices=$(SwitchAudioSource -a | tail -n+2)
current=$(SwitchAudioSource -c)


echo '<?xml version="1.0"?>'
echo '<items>'

function print_items {
  target=$devices
  jq -R -r <<< "$target" | while IPS= read -r device; do
    if [[ -n $query && ! $device =~ $query ]]; then
      continue
    fi

    icon="volume_off.png"
    if [[ $device == $current ]]; then
      icon="icon.png"
    fi

    echo "
      <item uid=\"$device\" arg=\"${device}\">
        <title>$device</title>
         <subtitle></subtitle>
        <icon>$icon</icon>
      </item>
    "
  done
}

print_items

echo '</items>'


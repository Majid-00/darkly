#!/bin/bash

if [ -z "$1" ]; then
    echo "Utilisation : $0"
    exit 1
fi

crawl() {
  local url="$1"
  
  content=$(curl -s "$url")
  links=$(echo "$content" | grep -oP '(?<=href=")[^"]+')
  
  #on esquive le dossier css et le retour en arriere
  for link in $links; do
    [[ "$link" == "../" ]] && continue
    [[ "$link" == "css/" ]] && continue

    new_url="${url}${link}"

    # si c un repertoire on relance la fonction :
    if [[ "$link" =~ /$ ]]; then
      crawl "$new_url"
    else
      # si c'est un fichier on check :
      file_content=$(curl -s "$new_url")
      #   echo "$file_content"
      if echo "$file_content" | grep -qi "flag"; then
        echo "FLAG found in file: $new_url"
        echo "$file_content"
        exit 0
      fi
    fi
  done
}

crawl "http://$1/.hidden/"

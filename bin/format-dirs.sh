#!/bin/sh
tac | while read DIR; do
  P=${DIR%[/~]*}
  P=${P%[/~]*}
  P=${P%[/~]*}
  [ -z "$P" -o "$DIR" = "$P" ] && P="$DIR" || P="...${DIR:${#P}}"
  echo "$P"
done | tr '\n' ' ' | sed 's/ $//'

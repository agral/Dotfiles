#!/usr/bin/env bash

# Name:          Color256.sh
# Description:   Prints out 256 colors to the terminal.
# Options:       None
# Author:        Adam Graliński (https://gralin.ski)
# License:       MIT


for i in {0..255}; do
  printf "\033[48;5;%sm%4d\e[0m " "$i" "$i"
  if (( (i+1) % 16 == 0)); then
    printf "\n";
  fi
done

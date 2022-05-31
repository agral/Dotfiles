#!/usr/bin/env bash

__usage="\
GCD.sh - calculate and print the greatest common divisor of a set of integers

Usage: GCD.sh [-h] num1 num2 [...numN]
Options:
    -h|--help: print this message and exit
Example: GCD.sh 42 36
Author: Adam Graliński (https://gralin.ski)
License: MIT"

### Calculates a GCD of the two numbers provided as arguments.
GCD() {
  # Sort the two arguments into `lower` and `higher` variables
  local lower="$1"
  local higher="$2"
  if [ "$lower" -gt "$higher" ]; then
    local temp="$lower"
    lower="$higher"
    higher="$temp"
  fi

  # Perform the GCD calculation, print the result.
  while [ "$lower" -gt 0 ]; do
    local temp="$lower"
    lower="$(( "$higher" % "$lower" ))"
    higher="$temp"
  done
  echo "$higher"
}

# Handle script arguments:
args_positional=()
while [ "${#}" -gt 0 ]; do
  case "${1}" in
    -h|--help)
      echo "$__usage"
      exit 0
      ;;
    *) # unknown argument
      args_positional+=("$1")
    ;;
  esac
  shift # past this iteration's keyword / argument
done

if [ "${#args_positional[@]}" -lt 1 ]; then
  >&2 echo "Error: No arguments have been provided. Aborting."
  exit 1
fi

set -- "${args_positional[@]}"
result="$1"
shift
while [ "$#" -gt 0 ]; do
  result="$( GCD "$result" "$1" )"
  shift
done

echo "$result"

#!/bin/bash

print_usage() {
  echo "Ratio.sh"
  echo "Finds the greatest common denominator of the numbers num1, num2, ..., numN; provided as arguments,"
  echo "then prints out these numbers divided by that denominator, along with the denominator."
  echo "Useful for calculating the ratio of displays."
  echo
  echo "Usage:"
  echo "    Ratio.sh [-h] num1 num2 [...numN], where every num is a positive integer number."
  echo "    Note: More than two numbers can be provided, but at least two are mandatory."
  echo "Example:"
  echo "    Ratio.sh 1280 720"
  echo "    # prints out: 16:9 (scale factor 80)"
  echo "Author: Adam Graliński (https://gralin.ski)"
  echo "License: MIT"
}

# Returns the greatest common denominator of the two provided numbers.
# Parameters: $1, $2 - two numbers (int) to calculate the GCD of.
calculate_gcd() {
  # Assign higher of two numbers to $higher, lower to $lower:
  local higher=$1
  local lower=$2
  if [ "$higher" -lt "$lower" ]; then
    local temp=$lower
    lower=$higher
    higher=$temp
  fi

  # perform the GCD calculating algorithm:
  while [ "$lower" -ne 0 ]; do
    local temp="$lower"
    lower="$(( "$higher" % "$temp" ))"
    higher="$temp"
  done

  # At the end of the GCD calculating algorithm, $higher contains the GCD, while $lower is zero.
  echo "$higher"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  print_usage
  exit 0
fi

# Complain if less than two arguments were provided (excluding the handling of -h flag, done above):
if [ $# -lt 2 ]; then
  >&2 echo "Error: Ratio.sh requires at least two parameters, $# provided. Aborting."
  exit 1
fi

# Remember the original arguments for later:
original_args="$*"

# Calculate the GCD of all the provided arguments:
gcd="$1"
shift # past 1st argument, already in $gcd.
for number in "$@"; do
  # update $gcd so that it contains the greater common denominator of all the numbers seen so far.
  gcd="$(calculate_gcd "$number" "$gcd")"
done

# Restore the original arguments. Note: $original_args not in double quotes, because word splitting is desired here.
set -- $original_args

# Print out the first reduced element, then the rest of reduced elements separated with ':' character:
printf "%d" "$(( "$1" / "$gcd" ))"
shift # move past this 1st argument
for arg in "$@"; do
  printf ":%d" "$(( "$arg" / "$gcd" ))"
done

# Finally print out the calculated scale factor (gcd):
printf " (scale factor: %d)\n" "$gcd"

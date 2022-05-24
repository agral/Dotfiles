#!/usr/bin/env bash

# Outputs a ribbon with gradient rainbow background, red (left) to blue (right).
# The background is seamless on terminals that support truecolor (24-bit color).
# On terminals without 24-bit color support, the gradient is visually jagged.

# Based on: https://gist.github.com/XVilka/8346728

awk -v term_columns="${width:-$(tput cols || echo 80)}" 'BEGIN{
  s="/\\";
  for (colnum = 0; colnum < term_columns; colnum++) {
    r = 255 - (colnum * 255 / term_columns);
    g = (colnum * 510 / term_columns);
    if (g > 255) {
      g = 510 - g;
    }
    b = (colnum * 255 / term_columns);

    printf "\033[48;2;%d;%d;%dm", r, g, b;
    printf "\033[38;2;%d;%d;%dm", 255 - r, 255 - g, 255 - b;
    printf "%s\033[0m", substr(s, colnum % 2 + 1, 1);
  }
  printf "\n";
}'

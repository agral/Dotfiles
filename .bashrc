# Name:          .bashrc
# Description:   Main config file for the bash shell
# Options:       None
# Author:        Adam Graliński (https://gralin.ski)
# License:       CC0

# Apply the contents of this file only for interactive sessions:
[[ $- != *i* ]] && return

# Don't put duplicate lines or lines starting with space in the history:
HISTCONTROL=ignoreboth:erasedups

# Appends to the history file instead of overwriting it:
shopt -s histappend

# *Remember* the history:
HISTSIZE=100000
HISTFILESIZE=200000

# Check the window size after each command and automatically update the values of LINES and COLUMNS:
shopt -s checkwinsize

extract_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

make_bash_prompt() {
  local EXITCODE="$?"                 # This needs to be first.

  local colorNONE="\[\033[0m\]"       # resets color to terminal's FG color.
  local colorR="\[\033[0;31m\]"       # regular red
  local colorG="\[\033[0;32m\]"       # regular green
  local colorY="\[\033[0;33m\]"       # regular yellow
  local colorB="\[\033[0;34m\]"       # regular blue
  local colorM="\[\033[0;35m\]"       # regular magenta
  local colorYEM="\[\033[1;33m\]"     # bold yellow

  local usercolor=$colorG    # normal user's color - green.
  if [ $UID -eq "0" ]; then
    usercolor=$colorR        # superuser's color - red.
  fi
  local exitcolor=$colorG    # normal exit color - green.
  if [ "$EXITCODE" -ne "0" ]; then
    exitcolor="$colorY"      # abnormal exit color - yellow.
  fi
  local gitbr="$(extract_git_branch)"
  local prompt_gitbr_part=""
  if [ "${gitbr}" ]; then
    printf -v prompt_gitbr_part " on ${colorYEM}%s${colorNONE}" "${gitbr}"
  fi
  PS1="${colorNONE}[${exitcolor}$EXITCODE${colorNONE}] [${colorM}\t${colorNONE}] ${usercolor}\u${colorNONE} in ${colorB}\w${colorNONE}${prompt_gitbr_part} ${PROMPT_FLAGS}\n${usercolor}\$${colorNONE} "
}

PROMPT_COMMAND=make_bash_prompt

# Check whether the provided file exists; if so, source it.
# Parameters:
#    $1: path to the file to be sourced
source_shellrc() {
  if [ -f "$1" ]; then
    . "$1"
  else
    >&2 printf "[bashrc] Could not source file %s: not a valid file!\n" "$1"
  fi
}

source_shellrc "${HOME}/.config/shrc/global_variables.shrc"
source_shellrc "${HOME}/.config/shrc/common.shrc"
source_shellrc "${HOME}/.config/shrc/package_manager.shrc"
source_shellrc "${HOME}/.config/shrc/machine_specific.shrc"
source_shellrc "${HOME}/.config/shrc/dotfiles.shrc"

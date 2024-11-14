# Adds a directory to the top of the ${PATH} iff it is not already in a ${PATH}:
function ExpandPath
{
  if [ -d "${1}" ]; then
    [[ ":${PATH}:" != *":${1}:"* ]] && export PATH="${1}:${PATH}"
  else
    echo "[ExpandPath] Warning: directory \"${1}\" does not exist. Skipping it."
  fi
}

ExpandPath "${HOME}/.local/bin"
ExpandPath "${HOME}/.local/bin/MachineSpecific"

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Includes .bashrc (if it exists)
if [ -f "${HOME}/.bashrc" ]; then
  . "${HOME}/.bashrc"
fi

# requires ttab (https://github.com/mklement0/ttab) for restoration
function save-session {
  setopt local_options BASH_REMATCH

  CLOSE_TAB=${1}

  [[ $ITERM_SESSION_ID =~ w([0-9]+)t([0-9]+)p([0-9]+):* ]] \
  && T="${BASH_REMATCH[3]}"

  TODAY=$(gdate +"%Y%m%d")
  if [[ ! -f ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh ]]; then
    touch ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh
    chmod 755 ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh
  fi

  echo "echo \"TAB: ${T}\"; ttab -s ${ITERM_PROFILE} 'cd $(pwd); set-title-tab ${ITERM_TAB}'" >> ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh
  cat ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh | sort -u | sponge ~/Work/${ITERM_PROFILE}/restore-session-${TODAY}.sh
  if [[ "${CLOSE_TAB}" == "x" ]]; then
    exit
  fi
}
alias gj='save-session x'
alias ss='save-session'


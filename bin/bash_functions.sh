# requires ttab (https://github.com/mklement0/ttab) for restoration
function save-session {
  CLOSE_TAB=${1}
  if [[ ! -f ~/Work/${ITERM_PROFILE}/restore-session.sh ]]; then
    touch ~/Work/${ITERM_PROFILE}/restore-session.sh
    chmod 755 ~/Work/${ITERM_PROFILE}/restore-session.sh
  fi
  echo "ttab -s ${ITERM_PROFILE} 'cd $(pwd); set-title-tab ${ITERM_TAB}'" >> ~/Work/${ITERM_PROFILE}/restore-session.sh
  cat ~/Work/${ITERM_PROFILE}/restore-session.sh | sort -u | sponge ~/Work/${ITERM_PROFILE}/restore-session.sh
  if [[ "${CLOSE_TAB}" == "x" ]]; then
    exit
  fi
}
alias gj='save-session x'
alias ss='save-session'

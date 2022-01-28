# requires ttab (https://github.com/mklement0/ttab) for restoration
function save-session {
  if [[ ! -f ~/Work/${ITERM_PROFILE}/restore-session.sh ]]; then
    touch ~/Work/${ITERM_PROFILE}/restore-session.sh
    chmod 755 ~/Work/${ITERM_PROFILE}/restore-session.sh
  fi
  echo "ttab -s ${ITERM_PROFILE} 'cd $(pwd); set-title-tab ${ITERM_TAB}'" >> ~/Work/${ITERM_PROFILE}/restore-session.sh
  cat ~/Work/${ITERM_PROFILE}/restore-session.sh | sort -u | sponge ~/Work/${ITERM_PROFILE}/restore-session.sh
  exit
}
alias gj='save-session'

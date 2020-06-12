function log-path() {
  TODAY=$(gdate +"%Y-%m-%d")
  if [[ ! -f ~/${TODAY}-OpenDirectories.txt ]]; then
    touch ~/${TODAY}-OpenDirectories.txt
  fi
  LOC=$(pwd)
  TS=$(gdate --rfc-3339="seconds")
  echo "${TS}:${ITERM_SESSION_ID}:${ITERM_TAB}:${LOC}" >> ~/${TODAY}-OpenDirectories.txt
}

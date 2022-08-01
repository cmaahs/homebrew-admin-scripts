function vi-all-extension {
  EXTENSION=${1}
  if [[ -n ${EXTENSION} ]]; then
    F_LIST=($(find . -iname "*.${EXTENSION}")) && vi ${F_LIST}
  fi
}


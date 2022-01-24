function unlock-bw {

  export BW_SESSION=$(cat ~/.bw_session)
  local BW_STATUS=$(bw status | jq -r '.status')
  if [[ "${BW_STATUS}" == "locked" ]]; then
    export BW_SESSION=$(bw unlock | grep '\$ export' | cut -d'"' -f2)
    echo "${BW_SESSION}" > ~/.bw_session
    chmod 0600 ~/.bw_session
  fi
}


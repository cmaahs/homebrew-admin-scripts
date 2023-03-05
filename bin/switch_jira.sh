function switch-jira {

local WHICH_JIRA=$1

if [[ -z ${WHICH_JIRA} ]]; then
  WHICH_JIRA=$((cd ~/.jira.d && ls -1 *.yml | cut -d'-' -f1) | fzf)
fi

echo "Switching to ${WHICH_JIRA}"
export ALTERJIRA_CONFIG=${WHICH_JIRA}-config.yaml
export GOJIRA_CONFIG=${WHICH_JIRA}

case "${WHICH_JIRA}" in
    "dbaas")
      jira sprint
      ;;
    "alteryx")
      jira mine
      ;;
    "pw")
      jira mine
      ;;
    "aj")
      jira mine
      ;;
    "gjr")
      jira mine
      ;;
    "gt")
      jira mine
      ;;
    "kt")
      jira mine
      ;;
    "bwca")
      jira mine
      ;;
    "em")
      jira mine
      ;;
    "gg")
      jira mine
      ;;
    "tn")
      jira mine
      ;;
    "vv")
      jira mine
      ;;
  esac
}


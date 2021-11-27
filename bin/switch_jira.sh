function switch-jira {

local WHICH_JIRA=$1

if [[ -z ${WHICH_JIRA} ]]; then
  WHICH_JIRA=alteryx
fi


echo "Switching to ${WHICH_JIRA}"
cp ~/.jira.d/${WHICH_JIRA}-config ~/.jira.d/config.yml

case "${WHICH_JIRA}" in
    "dbaas")
      jira sprint
      ;;
    "alteryx")
      jira sprint
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
  esac
}

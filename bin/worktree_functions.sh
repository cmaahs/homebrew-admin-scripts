function lswt {
  git worktree list
}

function cdwtp {
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  PARENT=$(git worktree list | head -n 1 | awk '{ print $1 }')
  if [[ -n ${PARENT} ]]; then
    cd ${PARENT}
  else
    echo -e "${YELLOW}Couldn't determine parent path${NONE}"
  fi
}

function cdwt {
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  SEDHOME=$(echo ${HOME} | sed 's/\//\\\//g')
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  if [[ -n ${REPONAME} ]]; then
    WTPATH=$(find ~/Worktrees/*/${REPONAME} -maxdepth 1 -mindepth 1 | grep -v .DS_Store | sed "s/${SEDHOME}\/Worktrees\///" | sort | fzf --tac)
  else
    WTPATH=$(find ~/Worktrees -maxdepth 3 -mindepth 3 | grep -v .DS_Store | sed "s/${SEDHOME}\/Worktrees\///" | sort | fzf --tac)
  fi
  if [[ -n ${WTPATH} ]]; then
    cd ${HOME}/Worktrees/${WTPATH}
    export BRANCH=$(git branch --show-current)
  else
    echo -e "${YELLOW}No selection made${NONE}"
  fi
}

function mkwt {
  JIRA=${1}
  BRANCH=${2}
  if [[ -z ${JIRA} || -z ${BRANCH} ]]; then
    echo -e "${YELLOW}Need JIRA (DBAAS-nnnn) and BRANCH (short name)${NONE}"; exit 1
  fi
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  if [[ ! -d ~/Worktrees/${JIRA}/${REPONAME}/${2} ]]; then
    git worktree add -b ${1}/${2} ~/Worktrees/${JIRA}/${REPONAME}/${2}
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

function mkwttrack {
  JIRA=${1}
  BRANCH=${2}
  if [[ -z ${JIRA} || -z ${BRANCH} ]]; then
    echo -e "${YELLOW}Need JIRA (DBAAS-nnnn) and BRANCH (short name)${NONE}"; exit 1
  fi
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  if [[ ! -d ~/Worktrees/${JIRA}/${REPONAME}/${2} ]]; then
    git worktree add --guess-remote -b ${1}/${2} ~/Worktrees/${JIRA}/${REPONAME}/${2}
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

function rmwt {
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  SEDHOME=$(echo ${HOME} | sed 's/\//\\\//g')
  PARENT=$(git worktree list | head -n 1 | awk '{ print $1 }')
  CURRDIR=$(pwd)
  if [[ "${PARENT}" == "${CURRDIR}" ]]; then
    REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
    WTPATH=$(find ~/Worktrees/*/${REPONAME} -maxdepth 1 -mindepth 1 | grep -v .DS_Store | sed "s/${SEDHOME}\/Worktrees\///" | sort | fzf --tac)
    if [[ -n ${WTPATH} ]]; then
      if [[ -d ~/Worktrees/${WTPATH} ]]; then
        git worktree remove ~/Worktrees/${WTPATH}
        JIRA=$(dirname $(dirname ${WTPATH})) # JIRA is two paths up
        EMPTYCOUNT=$(find ~/Worktrees/${JIRA}/${REPONAME} -maxdepth 0 -mindepth 0 -empty | sed "s/${SEDHOME}\/Worktrees\///" | wc -l | awk '{ print $1 }')
        if [[ "${EMPTYCOUNT}" != "0" ]]; then
          DIRTODELETE=$(find ~/Worktrees/${JIRA}/${REPONAME} -maxdepth 0 -mindepth 0 -empty | sed "s/${SEDHOME}\/Worktrees\///" | fzf --prompt "Remove Empty Directory? (ENTER/delete, ESC/cancel) >")
          if [[ -n ${DIRTODELETE} ]]; then
            if [[ -d ~/Worktrees/${DIRTODELETE} ]]; then
              rmdir ~/Worktrees/${DIRTODELETE}
            else
              echo -e "${YELLOW}This shouldn't happen, the directory didn't exist!${NONE}"
            fi
          else
            echo -e "${YELLOW}Deletion of empty dirctory cancelled${NONE}"
          fi
        fi
      else
        echo -e "${YELLOW}The worktree directory doesn't exist, aborting${NONE}"
      fi
    else
      echo -e "${YELLOW}No worktree path selected${NONE}"
    fi
  else
    echo -e "${YELLOW}Please change to the parent before removing the worktree${NONE}"
  fi
}

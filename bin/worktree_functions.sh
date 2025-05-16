# worktree_functions.sh
#
# This file is meant to be sourced into your current shell.  The naming is meant
# to be fairly easy to remember.  ls, cd, mk, rm prefixes to 'wt' for worktree.
#
# For those unfamiliar with worktrees:
#
# https://git-scm.com/docs/git-worktree
# tldr git-worktree
#
# The actual TLDR;
#
# git worktrees allow you to create a branch and check it out into a separate
# directory.  In a time when most tools where git 'unaware', like diffing tools,
# this was an easy way to have physical directories one could use to compare
# differences between branches.  It also means you can create and work on a new
# branch without having to stash and all those hoops.

# lswt - Used to list the worktrees that are created in the current repository
# directory.
function lswt {
  git worktree list
}

# cdwtp - This will change your working directory to the directory where the
# base repository was cloned.
function cdwtp {
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  PARENT=$(git worktree list | head -n 1 | awk '{ print $1 }')
  if [[ -n ${PARENT} ]]; then
    cd ${PARENT}
    export BRANCH=$(git branch --show-current)
  else
    echo -e "${YELLOW}Couldn't determine parent path${NONE}"
  fi
}

# cdwt - This will present a list of worktrees to choose from, allowing a section
# then setting your working directory to the chosen worktree directory.  This is
# keyed off of my '~/Worktrees' directory structure, so a bit hard coded.
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
    export JIRA_ISSUE=$(echo ${BRANCH} | cut -d'/' -f1)
  else
    echo -e "${YELLOW}No selection made${NONE}"
  fi
}

# mkwt - The structure I followed here is the JIRA number and "branch name".
# These are both combined to create the actual branch name as 'JIRA-NNNN/{branch}'
# and creates the worktree directory in '~/Worktrees/JIRA-NNNN/{repo name}/{branch}'
function mkwt {
  JIRA=${1}
  BRANCH=${2}
  if [[ -z ${JIRA} || -z ${BRANCH} ]]; then
    echo -e "${YELLOW}Need JIRA (DBAAS-nnnn) and BRANCH (short name)${NONE}"; exit 1
  fi
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  REPO_URL=$(git config --get remote.origin.url)
  # check to see if REPO_URL is an https:// or a git@ url
  if [[ "${REPO_URL}" == "https://"* ]]; then
    LINKABLE_URL=$(echo ${REPO_URL} | sed 's/\.git//')
    BRANCH_URL="${LINKABLE_URL}/~/tree/${BRANCH}"
  elif [[ "${REPO_URL}" == "git@"* ]]; then
    LINKABLE_URL=$(echo ${REPO_URL} | sed 's/:/\//' | sed 's/git@/https:\/\//' | sed 's/\.git//')
    BRANCH_URL="${LINKABLE_URL}/~/tree/${BRANCH}"
  else
    BRANCH_URL=${REPO_URL}
  fi
  echo "Branch Link: ${BRANCH_URL}"
  if [[ ! -d ~/Worktrees/${JIRA}/${REPONAME}/${2} ]]; then
    git worktree add -b ${1}/${2} ~/Worktrees/${JIRA}/${REPONAME}/${2}
    daily-notes add comment --comment "Created Branch" --link "[${JIRA}/${BRANCH}](${BRANCH_URL})"
    cd ${HOME}/Worktrees/${JIRA}/${REPONAME}/${2}
    export BRANCH=$(git branch --show-current)
    export JIRA_ISSUE=$(echo ${BRANCH} | cut -d'/' -f1)
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

# mkwtfrom - This takes JIRA-NNNN, <new branch name>, <source branch> and as with
# the mkwt function, creates a directory in '~/Worktrees' and sets up the new
# branch to track the <source branch>
#
# This is used when your local named branch differs from the origin branch name
function mkwtfrom {
  JIRA=${1}
  BRANCH=${2}
  SOURCE_BRANCH=${3}
  if [[ -z ${JIRA} || -z ${BRANCH} || -z ${SOURCE_BRANCH} ]]; then
    echo -e "${YELLOW}Need JIRA (DBAAS-nnnn) and BRANCH (short name) and SOURCE_BRANCH (commit from)${NONE}"; exit 1
  fi
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  if [[ ! -d ~/Worktrees/${JIRA}/${REPONAME}/${2} ]]; then
    git worktree add -b ${1}/${2} ~/Worktrees/${JIRA}/${REPONAME}/${2} ${SOURCE_BRANCH}
    cd ${HOME}/Worktrees/${JIRA}/${REPONAME}/${2}
    export BRANCH=$(git branch --show-current)
    export JIRA_ISSUE=$(echo ${BRANCH} | cut -d'/' -f1)
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

# mkwttrack - While similar to mkwtfrom, this function makes the assumption that
# the new local branch you are creating has the same name as the origin.
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
    cd ${HOME}/Worktrees/${JIRA}/${REPONAME}/${2}
    export BRANCH=$(git branch --show-current)
    export JIRA_ISSUE=$(echo ${BRANCH} | cut -d'/' -f1)
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

# mkwtbranch - This takes JIRA-NNNN, <source branch> and as with
# the mkwt function, creates a directory in '~/Worktrees' and sets up the new
# branch, with the same name as <source branch> to track the <source branch>
#
# This is used when you want your local and remote branchname to match
function mkwtbranch {
  JIRA=${1}
  SOURCE_BRANCH=${2}
  if [[ -z ${JIRA} || -z ${SOURCE_BRANCH} ]]; then
    echo -e "${YELLOW}Need JIRA (TSAASPD-nnnn) and SOURCE_BRANCH (commit from)${NONE}"; exit 1
  fi
  YELLOW='\033[01;33m'
  NONE='\033[0m'
  REPONAME=$(basename $(git config --get remote.origin.url) | sed 's/\.git//')
  if [[ ! -d ~/Worktrees/${JIRA}/${REPONAME}/${2} ]]; then
    git worktree add -b ${2} ~/Worktrees/${JIRA}/${REPONAME}/${2} ${SOURCE_BRANCH}
    cd ${HOME}/Worktrees/${JIRA}/${REPONAME}/${2}
    export BRANCH=$(git branch --show-current)
    export JIRA_ISSUE=$(echo ${BRANCH} | cut -d'/' -f1)
  else
    echo -e "${YELLOW}The worktree directory already exists, aborting${NONE}"
  fi
}

# rmwt - The removal function.  This will list the worktrees, similar to cdwt,
# and remove the worktree from your local git, then perform some cleanup in the
# '~/Worktrees' directory.
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


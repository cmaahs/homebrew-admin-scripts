# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
function set-terminal-title () {
    # echo works in bash & zsh
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
set-title-both   () { set-terminal-title 0 $@; }
set-title-tab    () { ITERM_TAB=$@; set-terminal-title 1 $@; }
set-title-window () { set-terminal-title 2 $@; }

#!/bin/zsh
# http://unix.stackexchange.com/questions/10823/where-do-my-ansi-escape-codes-go-when-i-pipe-to-another-process-can-i-keep-them
write-output() {
  echo -e "$(no-color)${1}"
}
write-verbose() {
  echo -e "$(yellow-text)${1}$(no-color)" >&2
}
write-error() {
  echo -e "$(red-text)${1}$(no-color)" >&2
}
write-highlight() {
  echo -e "$(orange-text)${1}$(no-color)" >&2
}

pickForeground(){
  printf '\x1b[38;2;%s;%s;%sm' $1 $2 $3
}
pickBackground(){
  printf '\x1b[48;2;%s;%s;%sm' $1 $2 $3
}
no-color(){
  echo -en "\x1b[0m\n"
}
black-text(){
  pickForeground 0 0 0
}
gray-text(){
  pickForeground 100 100 100
}
red-text(){
  pickForeground 255 0 0
}
orange-text(){
  pickForeground 255 150 0
}
yellow-text(){
  pickForeground 244 208 48
}
green-text(){
  pickForeground 15 128 18
}
light-blue-text(){
  pickForeground 65 156 242
}
dark-blue-text(){
  pickForeground 0 55 255
}
purple-text(){
  pickForeground 165 0 255
}
red-background(){
  pickForeground 0 0 0
  pickBackground 255 0 0
}
orange-background(){
  pickForeground 0 0 0
  pickBackground 255 150 0
}
yellow-background(){
  pickForeground 0 0 0
  pickBackground 244 208 48
}
green-background(){
  pickForeground 0 0 0
  pickBackground 15 128 18
}
light-blue-background(){
  pickForeground 0 0 0
  pickBackground 65 156 242
}
dark-blue-background(){
  pickForeground 0 0 0
  pickBackground 0 55 255
}
purple-background(){
  pickForeground 0 0 0
  pickBackground 165 0 255
}

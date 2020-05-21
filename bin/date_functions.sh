#!/usr/bin/env bash

alias zulu='gdate --utc +%FT%T.%3NZ'
function since() {
    ddiff $@ `zulu` -f'%H:%M:%S'
}

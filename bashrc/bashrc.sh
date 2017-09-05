#!/usr/bin/env bash

# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function 4howmanyfasta { cat $1 | grep ">" | wc -l;}
function 7submit { nohup ./$1 1>>$1.log 2>>$1.err & }
function 7zipsuper48 { pigz -c -p 48 -9 $1 >$1.gz; }
function 7targzsuper48 {  tar c- $1  | pigz -c -p 48 >$1.tar.gz; }
function FASTA { seqtk seq -l 180 $1 | less; }

## Aliases
alias l='ls -ltrh'
alias ll='ls -dlh $PWD/*'
alias df="df -Tha --total"
alias free="free -mt"
alias htop='htop -d 3'
alias fcolor='sed -e "s/[NnKkSsRrYyWwMmBbDdHhVv\-\.\*]/$(tput setaf 1)\\0$(tput sgr0)/ig; s/[Aa]/$(tput setaf 6)\\0$(tput sgr0)/ig; s/g/$(tput setaf 5)\\0$(tput sgr0)/ig; s/t/$(tput setaf 4)\\0$(tput sgr0)/ig"'
alias 7Bashrc='nano /home/Jose.Grau/\.bashrc'

#Ask before removing or overwriting files:
#alias mv="mv -i"
#alias cp="cp -i"
alias rm="rm -i"

## Navigation shotcut functions
function CD { cd $1 && ls;}
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.lzma)      unlzma $1      ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x -ad $1 ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}


## Hypermnesia
HISTSIZE=50000000
HISTFILESIZE=100000000
alias H='history | grep --color'
function HT { history | grep --color $1 | tail -n 20;}
# Save the history after each command finishes
# (and keep any existing PROMPT_COMMAND settings)
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'


function 7uploadgdrive { gdrive upload --recursive $1 ;}




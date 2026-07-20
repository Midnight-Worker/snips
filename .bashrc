# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <https://creativecommons.org/publicdomain/zero/1.0/>. 

# ~/.bashrc: executed by bash(1) for interactive shells.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the msys2 mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func
export PATH=$PATH:/C/Program\ Files/nodejs:/C/Users/maikt/AppData/Local/Programs/Python/Python313/Scripts:/C/Users/maikt/AppData/Local/Programs/Python/Python313/:/C/kotlin/bin/:/C/Program\ Files/Java/jdk-24/bin:/C/Program\ Files/Git/bin
#source /c/emsdk/emsdk_env.sh
export PATH=$PATH:/C/Qt/6.10.2/mingw_64/bin:/C/Users/maikt/miniconda3/Library/mingw-w64/bin


export PATH=$PATH:/C/Qt/Tools/QtCreator/bin
alias creator="QT_SCALE_FACTOR=1.5 qtcreator"

hash -r
export PATH=:$PATH:/C/xampp/mysql/bin
export PATH=:$PATH:/C/Program\ Files/Neovim/bin:/C/Users/maikt/AppData/Local/Programs/Lite\ XL/
export PATH=$PATH:/c/Qt/6.11.0/mingw_64/bin
#export PATH=$PATH:/c/Users/maikt/AppData/Local/Programs/Python/Python313/Scripts:/c/Users/maikt/AppData/Local/Programs/Python/Python313/

alias pip="pip.exe"
export PATH=$PATH:/c/Users/maikt/Desktop/bin
export PATH=$PATH:/C/Users/maikt/AppData/Local/Programs/Microsoft\ VS\ Code/bin
export PATH=$PATH:/c/Users/maikt/.cargo/bin/
alias r="python main.py"
alias n="nano main.py"
alias v="vim main.py"
alias b="vifm ."
export PATH=$PATH:/C/msys64/mingw64/bin
alias mark="/C/Users/maikt/AppData/Local/Programs/MarkText/MarkText.exe"
alias ranger="lf"
export EDITOR=code
#source ~/boxrepl
export PATH=$PATH:/C/jdk-21/bin
alias kick="java -jar /C/C64/tools/KickAss.jar"
alias 64="cd /c/C64/projects"
alias desk="cd /c/Users/maikt/Desktop/"
#alias python="/C/Users/maikt/AppData/Local/Programs/Python/Python313/python"
export PATH=:$PATH:/C/Users/maikt/AppData/Roaming/npm
alias make="mingw32-make"

# installkickstart
export PATH="$HOME/.local/bin:$PATH"
alias ik="installkickstart"
alias python='/C/Users/maikt/AppData/Local/Programs/Python/Python313/python'
alias pip='/C/Users/maikt/AppData/Local/Programs/Python/Python313/Scripts/pip.exe'
alias ipy="python -m IPython"
alias q="~/starter.sh"
#~/starter.sh
alias install='home/maikt/setup.sh'
alias ie="source ie"
desk
if [[ -n "$TMUX" ]]; then
    alias exit='tmux detach-client'
fi


# Ursprünglichen MSYS2-Prompt merken
MSYS2_PS1="$PS1"

color() {
    PS1='\[\e[1;32m\]\u@\h:\[\e[1;34m\]\w\[\e[0m\]\$ '

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
}

defaultcolor() {
    PS1="$MSYS2_PS1"

    unalias ls 2>/dev/null
    unalias grep 2>/dev/null
}

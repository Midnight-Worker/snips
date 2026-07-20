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

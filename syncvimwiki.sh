getwiki() {
        rsync -avp /c/users/maikt/desktop/Midnight-Walker/vimwiki ~/.vimwiki/
}
putwiki() {
        rsync -avp ~/.vimwiki/ /c/users/maikt/Desktop/Midnight-Walker/vimwiki
}


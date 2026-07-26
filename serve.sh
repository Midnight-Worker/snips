#npm install -g browser-sync

serve() {
    browser-sync start \
        --server \
        --files "**/*.html, **/*.css, **/*.js"
}

shot() {
    npx playwright screenshot \
        --full-page \
        "${1:-http://localhost:3000}" \
        "${2:-screenshot.png}"
}

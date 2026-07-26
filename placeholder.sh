ph() {
    local url="https://placehold.co/${1}.png"

    if [ -n "$3" ]; then
        local text="${3// /+}"
        url="${url}?text=${text}"
    fi

    curl -L "$url" -o "$2"
}

#icon mdi/computer
#icon lucide/terminal

icon() {
    local name="$1"
    local color="${2:-000000}"
    local filename="${3:-${name//\//-}.svg}"

    curl -L \
        "https://api.iconify.design/${name}.svg?color=%23${color}" \
        -o "$filename"
}

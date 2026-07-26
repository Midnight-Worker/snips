ph() {
    local size="$1"
    local filename="$2"
    local text="$3"
    local background="${4#\#}"
    local textcolor="${5#\#}"
    local url="https://placehold.co/${size}"

    if [[ -n "$background" || -n "$textcolor" ]]; then
        if [[ -z "$background" || -z "$textcolor" ]]; then
            echo "Fehler: Hintergrund- und Textfarbe müssen angegeben werden."
            return 1
        fi

        url+="/${background}/${textcolor}"
    fi

    url+=".png"

    if [[ -n "$text" ]]; then
        curl -L -G --data-urlencode "text=$text" "$url" -o "$filename"
    else
        curl -L "$url" -o "$filename"
    fi
}

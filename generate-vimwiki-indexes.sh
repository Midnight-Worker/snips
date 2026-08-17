#!/usr/bin/env bash

#pacman -S diffutils

set -Eeuo pipefail

# Rekursive Inhaltsverzeichnisse für ein Vimwiki mit Markdown-Dateien.
#
# Das Skript liegt am besten direkt im Wurzelordner des Wikis. Es erzeugt
# bzw. aktualisiert in jedem Unterordner eine index.md. Vorhandener eigener
# Text bleibt erhalten; nur der Bereich zwischen den AUTO-INDEX-Markierungen
# wird bei späteren Läufen ersetzt.

readonly INDEX_NAME="index.md"
readonly BEGIN_MARKER="<!-- AUTO-INDEX:BEGIN -->"
readonly END_MARKER="<!-- AUTO-INDEX:END -->"

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DRY_RUN=false
MAKE_BACKUP=false
BACKUP_DIR=""

created=0
updated=0
unchanged=0
skipped=0

usage() {
    cat <<'EOF'
Verwendung:
  ./generate-vimwiki-indexes.sh [OPTIONEN]

Optionen:
  -n, --dry-run     Nur anzeigen, welche index.md geändert würden
  -b, --backup      Vor Änderungen Sicherungskopien anlegen
  -r, --root PFAD   Einen anderen Wiki-Wurzelordner verwenden
  -h, --help        Diese Hilfe anzeigen

Beispiele:
  ./generate-vimwiki-indexes.sh --dry-run
  ./generate-vimwiki-indexes.sh --backup
  ./generate-vimwiki-indexes.sh --root /c/Users/maikt/Desktop/MeinWiki

Standardmäßig ignorierte Ordner:
  .git  .obsidian  .vimwiki-index-backups  export  node_modules
EOF
}

die() {
    printf 'Fehler: %s\n' "$*" >&2
    exit 1
}

warn() {
    printf 'WARNUNG: %s\n' "$*" >&2
}

is_ignored_directory() {
    case "$1" in
        .git|.obsidian|.vimwiki-index-backups|export|node_modules)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

escape_link_label() {
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\[/\\[}"
    value="${value//\]/\\]}"
    printf '%s' "$value"
}

# Die spitzen Klammern gehören zur Markdown-Syntax. Dadurch funktionieren
# relative Dateipfade mit Leerzeichen und Klammern ohne zusätzliche Werkzeuge.
markdown_target() {
    local value="$1"
    value="${value//%/%25}"
    value="${value//#/%23}"
    printf '<%s>' "$value"
}

relative_to_root() {
    local path="$1"

    if [[ "$path" == "$ROOT_DIR" ]]; then
        printf '.'
    else
        printf '%s' "${path#"$ROOT_DIR"/}"
    fi
}

make_generated_block() {
    local directory="$1"
    local block_file="$2"
    local child_lines
    local note_lines
    local child
    local note
    local name
    local label
    local target

    child_lines="$(mktemp)"
    note_lines="$(mktemp)"

    while IFS= read -r -d '' child; do
        name="$(basename -- "$child")"

        if is_ignored_directory "$name"; then
            continue
        fi

        label="$(escape_link_label "$name")"
        target="$(markdown_target "$name/$INDEX_NAME")"
        printf -- '- [%s](%s)\n' "$label" "$target" >> "$child_lines"
    done < <(
        find "$directory" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            -print0 |
        sort -zf
    )

    while IFS= read -r -d '' note; do
        name="$(basename -- "$note")"
        label="$(escape_link_label "${name%.*}")"
        target="$(markdown_target "$name")"
        printf -- '- [%s](%s)\n' "$label" "$target" >> "$note_lines"
    done < <(
        find "$directory" \
            -mindepth 1 \
            -maxdepth 1 \
            -type f \
            -iname '*.md' \
            ! -iname "$INDEX_NAME" \
            -print0 |
        sort -zf
    )

    {
        printf '%s\n\n' "$BEGIN_MARKER"
        printf '## Automatischer Index\n\n'

        if [[ "$directory" != "$ROOT_DIR" ]]; then
            printf -- '- [← Eine Ebene höher](%s)\n\n' \
                "$(markdown_target "../$INDEX_NAME")"
        fi

        if [[ -s "$child_lines" ]]; then
            printf '### Ordner\n\n'
            cat -- "$child_lines"
            printf '\n'
        fi

        if [[ -s "$note_lines" ]]; then
            printf '### Markdown-Dateien\n\n'
            cat -- "$note_lines"
            printf '\n'
        fi

        if [[ ! -s "$child_lines" && ! -s "$note_lines" ]]; then
            printf '_Dieser Ordner enthält derzeit keine weiteren Markdown-Dateien oder Unterordner._\n\n'
        fi

        printf '%s\n' "$END_MARKER"
    } > "$block_file"

    rm -f -- "$child_lines" "$note_lines"
}

backup_existing_index() {
    local index_file="$1"
    local relative_path
    local destination

    [[ "$MAKE_BACKUP" == true ]] || return 0

    if [[ -z "$BACKUP_DIR" ]]; then
        BACKUP_DIR="$ROOT_DIR/.vimwiki-index-backups/$(date '+%Y%m%d-%H%M%S')"
    fi

    relative_path="${index_file#"$ROOT_DIR"/}"
    destination="$BACKUP_DIR/$relative_path"
    mkdir -p -- "$(dirname -- "$destination")"
    cp -p -- "$index_file" "$destination"
}

write_index() {
    local directory="$1"
    local index_file="$directory/$INDEX_NAME"
    local block_file
    local candidate_file
    local begin_count=0
    local end_count=0
    local begin_line=0
    local end_line=0
    local title
    local relative
    local existed=false

    block_file="$(mktemp)"
    candidate_file="$(mktemp "$directory/.index.md.tmp.XXXXXX")"
    relative="$(relative_to_root "$index_file")"

    make_generated_block "$directory" "$block_file"

    if [[ -f "$index_file" ]]; then
        existed=true
        begin_count="$(grep -Fxc -- "$BEGIN_MARKER" "$index_file" || true)"
        end_count="$(grep -Fxc -- "$END_MARKER" "$index_file" || true)"

        if [[ "$begin_count" -eq 0 && "$end_count" -eq 0 ]]; then
            cp -- "$index_file" "$candidate_file"

            if [[ -s "$candidate_file" ]]; then
                printf '\n\n' >> "$candidate_file"
            fi

            cat -- "$block_file" >> "$candidate_file"
        elif [[ "$begin_count" -eq 1 && "$end_count" -eq 1 ]]; then
            begin_line="$(grep -nFx -- "$BEGIN_MARKER" "$index_file" | cut -d: -f1)"
            end_line="$(grep -nFx -- "$END_MARKER" "$index_file" | cut -d: -f1)"

            if (( begin_line >= end_line )); then
                warn "$relative: AUTO-INDEX-Markierungen stehen in falscher Reihenfolge; Datei übersprungen."
                rm -f -- "$block_file" "$candidate_file"
                skipped=$((skipped + 1))
                return
            fi

            awk \
                -v begin="$BEGIN_MARKER" \
                -v end="$END_MARKER" \
                -v block="$block_file" '
                function emit_block( line) {
                    while ((getline line < block) > 0) {
                        print line
                    }
                    close(block)
                }

                $0 == begin {
                    emit_block()
                    inside = 1
                    next
                }

                inside && $0 == end {
                    inside = 0
                    next
                }

                !inside {
                    print
                }
            ' "$index_file" > "$candidate_file"
        else
            warn "$relative: unvollständige oder mehrfache AUTO-INDEX-Markierungen; Datei übersprungen."
            rm -f -- "$block_file" "$candidate_file"
            skipped=$((skipped + 1))
            return
        fi
    else
        if [[ "$directory" == "$ROOT_DIR" ]]; then
            title="Inhaltsverzeichnis"
        else
            title="$(basename -- "$directory")"
        fi

        printf '# %s\n\n' "$title" > "$candidate_file"
        cat -- "$block_file" >> "$candidate_file"
    fi

    rm -f -- "$block_file"

    if [[ "$existed" == true ]] && cmp -s -- "$index_file" "$candidate_file"; then
        rm -f -- "$candidate_file"
        printf 'Unverändert: %s\n' "$relative"
        unchanged=$((unchanged + 1))
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        rm -f -- "$candidate_file"

        if [[ "$existed" == true ]]; then
            printf 'Würde aktualisieren: %s\n' "$relative"
            updated=$((updated + 1))
        else
            printf 'Würde erstellen:    %s\n' "$relative"
            created=$((created + 1))
        fi

        return
    fi

    if [[ "$existed" == true ]]; then
        backup_existing_index "$index_file"
        chmod --reference="$index_file" "$candidate_file" 2>/dev/null || true
        mv -f -- "$candidate_file" "$index_file"
        printf 'Aktualisiert: %s\n' "$relative"
        updated=$((updated + 1))
    else
        chmod 0644 "$candidate_file" 2>/dev/null || true
        mv -f -- "$candidate_file" "$index_file"
        printf 'Erstellt:     %s\n' "$relative"
        created=$((created + 1))
    fi
}

while (($# > 0)); do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -b|--backup)
            MAKE_BACKUP=true
            shift
            ;;
        -r|--root)
            (($# >= 2)) || die "--root benötigt einen Pfad."
            ROOT_DIR="$(cd -- "$2" 2>/dev/null && pwd -P)" ||
                die "Wiki-Wurzelordner nicht gefunden: $2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "Unbekannte Option: $1 (Hilfe: --help)"
            ;;
    esac
done

[[ -d "$ROOT_DIR" ]] || die "Wiki-Wurzelordner nicht gefunden: $ROOT_DIR"
[[ -w "$ROOT_DIR" ]] || die "Wiki-Wurzelordner ist nicht beschreibbar: $ROOT_DIR"

printf 'Wiki-Wurzel: %s\n\n' "$ROOT_DIR"

while IFS= read -r -d '' directory; do
    write_index "$directory"
done < <(
    find "$ROOT_DIR" \
        -type d \
        \( \
            -name '.git' -o \
            -name '.obsidian' -o \
            -name '.vimwiki-index-backups' -o \
            -name 'export' -o \
            -name 'node_modules' \
        \) \
        -prune -o \
        -type d \
        -print0 |
    sort -zf
)

if [[ "$DRY_RUN" == true ]]; then
    printf '\nTrockenlauf: %d würden erstellt, %d aktualisiert, %d blieben unverändert, %d übersprungen.\n' \
        "$created" "$updated" "$unchanged" "$skipped"
else
    printf '\nFertig: %d erstellt, %d aktualisiert, %d unverändert, %d übersprungen.\n' \
        "$created" "$updated" "$unchanged" "$skipped"
fi

if [[ "$MAKE_BACKUP" == true && -n "$BACKUP_DIR" ]]; then
    printf 'Sicherungen: %s\n' "$BACKUP_DIR"
fi

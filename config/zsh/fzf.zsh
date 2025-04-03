# ┌─────────────────────────────────────────────────────────────────┐
# │                      FZF KONFIGURATION                          │
# └─────────────────────────────────────────────────────────────────┘

# ===== INITIALISIERUNG =====
# Lädt die grundlegenden FZF-Funktionen und Tastenkombinationen:
# - CTRL+T: Dateien/Ordner suchen
# - CTRL+R: Befehlsverlauf durchsuchen 
# - ALT+C: In Ordner wechseln
eval "$(fzf --zsh)"

# ===== SUCHBEFEHLE =====
# Verwendet 'fd' statt 'find' für bessere Performance und Lesbarkeit
# Zeigt versteckte Dateien, aber ignoriert .git-Verzeichnisse
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# ===== PFAD-GENERIERUNG =====
# Definiert, wie Pfade für die Autovervollständigung generiert werden
_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1" }

# ===== FARBSCHEMA =====
# Dunkles, modernes Farbschema mit angenehmen Blau- und Cyan-Tönen und transparentem Hintergrund
fg="#CBE0F0"            # Haupttextfarbe (hell)
bg="-1"                 # Transparenter Hintergrund (-1)
bg_highlight="#143652"  # Hervorgehobener Hintergrund
purple="#B388FF"        # Hervorhebungsfarbe
blue="#06BCE4"          # Informationsfarbe
cyan="#2CF9ED"          # Navigationsfarbe (Cursor, Marker)

# Wendet das Farbschema auf alle FZF-Instanzen an
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# ===== VORSCHAU-EINSTELLUNGEN =====
# Zeigt Dateiinhalte mit 'bat' und Verzeichnisstrukturen mit 'eza' an
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# Konfiguriert Vorschau für CTRL+T (Dateisuche)
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"

# Konfiguriert Vorschau für ALT+C (Verzeichniswechsel)
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ===== KONTEXTABHÄNGIGE VORSCHAU =====
# Passt die Vorschau je nach Befehlskontext an
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                  "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ===== ERWEITERTE FUNKTIONEN =====
# Fügt nützliche Funktionen für die Arbeit mit FZF hinzu

# Dateien mit FZF auswählen und in Neovim öffnen (mehrere Dateien möglich)
# Nutzung: vf (vim-fuzzy)
vf() {
  local files
  # Mehrfachauswahl mit Tab/S-Tab, alle mit Alt+A auswählen
  files=($(fd --type f --hidden --strip-cwd-prefix --exclude .git | fzf --multi --bind 'alt-a:select-all' --preview "$show_file_or_dir_preview"))
  [[ -n "$files" ]] && nvim "${files[@]}"
}

# Mit FZF durch Git-Änderungen navigieren und in nvim öffnen
# Nutzung: vg (vim-git)
vg() {
  local files
  files=($(git status --porcelain | awk '{print $2}' | fzf --multi --preview "$show_file_or_dir_preview"))
  [[ -n "$files" ]] && nvim "${files[@]}"
}

# Mit FZF in Suchresultaten navigieren und in nvim öffnen
# Nutzung: vs <suchbegriff> (vim-search)
vs() {
  local file
  # Ripgrep für Volltext-Suche mit Vorschau
  local line=$(
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:${cyan}" \
        --delimiter : \
        --preview "bat --color=always {1} --highlight-line {2} --line-range $((0 > {2} - 30 ? 0 : {2} - 30)):$((0 > {2} + 30 ? 0 : {2} + 30))" \
        --preview-window "right:wrap"
  )
  local file=$(echo "$line" | cut -d: -f1)
  local linenumber=$(echo "$line" | cut -d: -f2)
  [[ -n "$file" ]] && nvim "$file" +$linenumber
}

# ===== TIPPS =====
# - CTRL+T: Dateien/Ordner durchsuchen
# - CTRL+R: Befehlsverlauf durchsuchen
# - ALT+C: In Verzeichnis wechseln
# - TAB/Shift+TAB: Mehrere Elemente auswählen
# 
# Benutzerdefinierte FZF-Befehle:
# - vf: Dateien auswählen und in nvim öffnen
# - vg: Git-geänderte Dateien durchsuchen und in nvim öffnen
# - vs <suchbegriff>: Text in Dateien suchen und Treffer in nvim öffnen 
# ┌─────────────────────────────────────────────────────────────────┐
# │                        GRUNDKONFIGURATION                        │
# └─────────────────────────────────────────────────────────────────┘
# ===== HomeBrew ====
# Homebrew für Apple Silicon (M1/M2/M3)
eval "$(/opt/homebrew/bin/brew shellenv)"
# ===== SHELL-THEME =====
# Lädt Oh-My-Posh mit dem coolen Nacht-Theme
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/coolnight.omp.json)"

# ===== ALIASES =====
# Lädt benutzerdefinierte Aliase aus separater Datei
source ~/.config/zsh/aliases

# ┌─────────────────────────────────────────────────────────────────┐
# │                      VERLAUFSKONFIGURATION                      │
# └─────────────────────────────────────────────────────────────────┘

# ===== HISTORIEN-EINSTELLUNGEN =====
# Speichert Befehle für spätere Verwendung und verbessert Workflow
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history          # Teile Verlauf zwischen Sitzungen
setopt hist_expire_dups_first # Lösche Duplikate zuerst
setopt hist_ignore_dups       # Speichere doppelte Befehle nur einmal
setopt hist_verify            # Zeige Befehle vor Ausführung an

# ===== TASTENKOMBINATIONEN =====
# Ermöglicht die Suche im Verlauf mit Pfeiltasten
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ┌─────────────────────────────────────────────────────────────────┐
# │                      ZSH-ERWEITERUNGEN                          │
# └─────────────────────────────────────────────────────────────────┘

# ===== AUTOVERVOLLSTÄNDIGUNG & HERVORHEBUNG =====
# Verbessert ZSH mit Vorschlägen und Syntax-Highlighting
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ┌─────────────────────────────────────────────────────────────────┐
# │                       TMUX-INTEGRATION                          │
# └─────────────────────────────────────────────────────────────────┘

# ===== AUTOMATISCHER START =====
# Startet tmux automatisch, wenn das Terminal groß genug ist
# Wird nicht in VSCode oder Cursor gestartet
if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && [[ "$TERM_PROGRAM" != "cursor" ]]; then
  LINES=$(tput lines)
  COLUMNS=$(tput cols)

  if (( LINES > 24 && COLUMNS > 80 )); then
    tmux attach -t main 2>/dev/null || tmux new -s main
  fi
fi

# ┌─────────────────────────────────────────────────────────────────┐
# │                      EXTERNE KONFIGURATIONEN                     │
# └─────────────────────────────────────────────────────────────────┘

# ===== FZF-KONFIGURATION =====
# Lädt alle Fuzzy Finder Einstellungen und Funktionen aus externer Datei
[ -f ~/.config/zsh/fzf.zsh ] && source ~/.config/zsh/fzf.zsh


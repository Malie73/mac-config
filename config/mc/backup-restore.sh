#!/bin/bash
# Skript zur Sicherung und Wiederherstellung der Midnight Commander Konfiguration
# Autor: marko
# Datum: $(date +%Y-%m-%d)

# Farben für Ausgabe
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Konfigurationsverzeichnisse
MC_CONFIG_DIR="$HOME/.config/mc"
HOMEBREW_SKIN_DIR="/opt/homebrew/Cellar/midnight-commander/*/share/mc/skins"

# Funktion zum Sichern der Konfiguration
backup_config() {
    echo -e "${YELLOW}Sichere Midnight Commander Konfiguration...${NC}"
    
    # Stelle sicher, dass Backup-Verzeichnis existiert
    mkdir -p "$MC_CONFIG_DIR/backup"
    
    # Kopiere wichtige Konfigurationsdateien
    cp -f "$MC_CONFIG_DIR/ini" "$MC_CONFIG_DIR/backup/"
    cp -f "$MC_CONFIG_DIR/panels.ini" "$MC_CONFIG_DIR/backup/" 2>/dev/null
    cp -f "$MC_CONFIG_DIR/syntax" "$MC_CONFIG_DIR/backup/" 2>/dev/null
    cp -fr "$MC_CONFIG_DIR/skins" "$MC_CONFIG_DIR/backup/" 2>/dev/null
    
    echo -e "${GREEN}Sicherung abgeschlossen in $MC_CONFIG_DIR/backup/${NC}"
}

# Funktion zum Wiederherstellen der Konfiguration
restore_config() {
    echo -e "${YELLOW}Stelle Midnight Commander Konfiguration wieder her...${NC}"
    
    # Prüfe, ob Backup existiert
    if [ ! -d "$MC_CONFIG_DIR/backup" ]; then
        echo "Keine Sicherung gefunden in $MC_CONFIG_DIR/backup/"
        exit 1
    fi
    
    # Stelle Konfigurationsdateien wieder her
    cp -f "$MC_CONFIG_DIR/backup/ini" "$MC_CONFIG_DIR/" 2>/dev/null
    cp -f "$MC_CONFIG_DIR/backup/panels.ini" "$MC_CONFIG_DIR/" 2>/dev/null
    cp -f "$MC_CONFIG_DIR/backup/syntax" "$MC_CONFIG_DIR/" 2>/dev/null
    
    # Stelle Skins wieder her
    mkdir -p "$MC_CONFIG_DIR/skins"
    cp -fr "$MC_CONFIG_DIR/backup/skins/"* "$MC_CONFIG_DIR/skins/" 2>/dev/null
    
    # Stelle sicher, dass das System-Skin auch verfügbar ist
    if [ -d "$HOMEBREW_SKIN_DIR" ]; then
        cp -f "$MC_CONFIG_DIR/skins/julia256-fix.ini" "$(echo $HOMEBREW_SKIN_DIR)" 2>/dev/null
        echo -e "${GREEN}Skin auch im System-Verzeichnis installiert${NC}"
    fi
    
    echo -e "${GREEN}Wiederherstellung abgeschlossen${NC}"
}

# Hauptskript
case "$1" in
    backup)
        backup_config
        ;;
    restore)
        restore_config
        ;;
    *)
        echo "Verwendung: $0 {backup|restore}"
        echo "  backup  - Sichert die aktuelle MC-Konfiguration"
        echo "  restore - Stellt die MC-Konfiguration aus der Sicherung wieder her"
        exit 1
        ;;
esac

exit 0 
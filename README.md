# Konfigurations-Backup-System

Dieses Repository enthält Skripte für die Sicherung, Synchronisierung und Wiederherstellung von Systemkonfigurationen und Anwendungseinstellungen.

## Struktur

- `backup-sync.zsh`: Skript zum Sichern und Synchronisieren von Konfigurationen
- `restore.zsh`: Skript zum Wiederherstellen von Konfigurationen und Installation von Anwendungen
- `config/`: Gesicherte Konfigurationsdateien aus dem `.config`-Verzeichnis
- `App_Settings/`: Spezifische Einstellungen für Anwendungen
  - `iTerm2/`: iTerm2-Konfigurationen
  - `MC/`: Midnight Commander Konfigurationen

## Gesicherte Konfigurationen

Das System sichert folgende Konfigurationen:

- Alle Homebrew-Pakete (normale Formeln und Casks)
- Mac App Store Apps (wenn mas installiert und der Nutzer eingeloggt ist)
- Das komplette `.config`-Verzeichnis
- `.zshrc`
- `.tmux.conf` und `.tmux`-Verzeichnis
- `.vim`-Verzeichnis
- iTerm2-Konfiguration (`.iterm2` und Plist)
- Midnight Commander-Einstellungen

## Verwendung

### Backup und Synchronisierung

Führe das Backup-/Synchronisierungsskript aus, um Änderungen an deinen Konfigurationen zu sichern:

```bash
~/git/config/backup-sync.zsh
```

Das Skript:
1. Sichert alle installierten Homebrew-Pakete
2. Synchronisiert Dotfiles und Konfigurationsverzeichnisse
3. Sichert spezifische App-Einstellungen
4. Zeigt den Git-Status an und gibt Hinweise für das Commit

Nach dem Ausführen des Skripts solltest du die Änderungen ins Git-Repository übernehmen:

```bash
cd ~/git/config
git add .
git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
git push  # Falls du ein Remote-Repository eingerichtet hast
```

### Wiederherstellung

Zum Wiederherstellen der Konfigurationen auf einem neuen System oder nach einer Neuinstallation:

```bash
~/git/config/restore.zsh
```

Das Skript:
1. Installiert Homebrew, falls nicht vorhanden
2. Installiert alle gesicherten Homebrew-Pakete
3. Stellt alle Dotfiles und Konfigurationsverzeichnisse wieder her
4. Stellt App-Einstellungen wieder her

Das Wiederherstellungsskript fragt vor jedem Hauptschritt nach Bestätigung und bietet zum Abschluss einen Systemneustart an.

## Anpassung

Du kannst die Skripte anpassen, um zusätzliche Verzeichnisse oder Einstellungen zu sichern. Bearbeite einfach die entsprechenden Abschnitte in `backup-sync.zsh` und `restore.zsh`.

## Erste Einrichtung

1. Klone dieses Repository oder erstelle es neu:
   ```bash
   mkdir -p ~/git/config
   cd ~/git/config
   # Erstelle die Skripte wie in diesem Repository
   chmod +x backup-sync.zsh restore.zsh
   ```

2. Führe das Backup-Skript erstmalig aus:
   ```bash
   ./backup-sync.zsh
   ```

3. Optional: Richte ein Remote-Git-Repository ein für zusätzliche Sicherheit:
   ```bash
   git remote add origin <dein-remote-repository-url>
   git push -u origin main
   ``` 
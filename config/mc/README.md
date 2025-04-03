# Midnight Commander Konfiguration

Diese Konfiguration enthält angepasste Einstellungen für Midnight Commander, die folgendes umfassen:

- Ein angepasstes Theme (`julia256-fix`) mit reduziertem Blaustich und angenehmerem Hintergrund
- Verbesserte Syntax-Highlighting-Farben für den internen Editor und Viewer
- Optimierte Performance

## Verwendung bei Neuinstallation

Wenn du deinen Mac neu aufsetzt, führe folgende Schritte aus:

1. Installiere Midnight Commander:
   ```
   brew install midnight-commander
   ```

2. Kopiere die Dateien im `.config/mc` Ordner (dieser Ordner) an den gleichen Ort in deinem neuen Home-Verzeichnis.

3. Kopiere das Theme zur Sicherheit auch in den System-Ordner:
   ```
   cp ~/.config/mc/skins/julia256-fix.ini /opt/homebrew/Cellar/midnight-commander/*/share/mc/skins/
   ```

4. Starte Midnight Commander und überprüfe, ob alles korrekt geladen wurde:
   ```
   mc
   ```

## Manuelles Backup erstellen

Um ein Backup der aktuellen Konfiguration zu erstellen, kannst du folgende Dateien und Ordner sichern:

- `~/.config/mc/ini` - Haupteinstellungen
- `~/.config/mc/panels.ini` - Panel-Einstellungen
- `~/.config/mc/syntax` - Syntax-Highlighting-Konfiguration
- `~/.config/mc/skins/julia256-fix.ini` - Dein angepasstes Theme

## Wichtige Einstellungen

In der `ini`-Datei sind folgende Einstellungen besonders wichtig:

1. Theme-Einstellung:
   ```
   skin=julia256-fix
   ```

2. Syntax-Highlighting:
   ```
   use_internal_edit=true
   editor_syntax_highlighting=true
   editor_syntax_highlighting_without_mouse=true
   syntax_highlighting_in_viewer=true
   auto_syntax_highlighting=true
   ```

## Farben anpassen

Das Theme ist in `~/.config/mc/skins/julia256-fix.ini` definiert. Dort kannst du beliebige Farben anpassen.

Format: `element=vordergrundfarbe;hintergrundfarbe;attribute`

- Farben: 256-Farben mit `colorXXX` (z.B. `color24` für Blau)
- Attribute: `bold`, `underline`, etc. 
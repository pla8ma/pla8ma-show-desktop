#!/usr/bin/env bash
# Installs (or updates) the Pla8ma show desktop widget for the current user.
set -euo pipefail

cd "$(dirname "$0")"

ID="io.github.pla8ma.showdesktop"

# Translations
mkdir -p plasmoid/contents/locale/de/LC_MESSAGES
msgfmt po/de.po -o "plasmoid/contents/locale/de/LC_MESSAGES/plasma_applet_${ID}.mo"

# Widget
if kpackagetool6 -t Plasma/Applet --show "$ID" >/dev/null 2>&1; then
    kpackagetool6 -t Plasma/Applet --upgrade plasmoid
else
    kpackagetool6 -t Plasma/Applet --install plasmoid
fi

echo
echo "Installed. If the widget was already in use, restart Plasma to load the new version:"
echo "  systemctl --user restart plasma-plasmashell"

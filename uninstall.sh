#!/usr/bin/env bash
# Removes the Pla8ma show desktop widget again (remove it from the panel first).
set -uo pipefail

kpackagetool6 -t Plasma/Applet --remove io.github.pla8ma.showdesktop

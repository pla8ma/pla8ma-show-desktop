# Pla8ma show desktop widget for KDE Plasma

> **Info:** highly AI-generated.

A show desktop button for KDE Plasma 6 panels: a narrow strip at the very
end of the panel that reaches across its full height. A click shows the
desktop or brings the windows back. Nothing lights up on hover; only while
the button is held it shows a lit glass box.

Optionally it can peek: resting the pointer on the strip shows the desktop
until the pointer leaves, and a click while peeking keeps it. Peeking is
off by default and can be turned on in the widget's settings.

The widget is meant for the
[Pla8ma panel](https://github.com/pla8ma/pla8ma-panel), whose widgets reach
its ends, so the strip is also hit in the outermost screen corner. In
Plasma's own panel a margin is left at the end that the strip does not
cover.

Translations: German.

## Install

It is a QML widget, so there is nothing to compile. `msgfmt` (gettext) is
needed for the translation.

```bash
./install.sh
```

Then put the widget last in the panel. If it was already in use, restart
Plasma to load the new version:

```bash
systemctl --user restart plasma-plasmashell
```

## Uninstall

Remove the widget from the panel first, then:

```bash
./uninstall.sh
```

## License

GPL-2.0-or-later.

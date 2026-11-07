/*
 * "Show desktop" strip at the very end of the taskbar.
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kwindowsystem

PlasmoidItem {
    id: root

    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    // Desktop is only shown while the pointer rests on the button.
    property bool peeking: false

    preferredRepresentation: compactRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    // Full panel thickness without the panel's margins, like the taskbar.
    // Only meant for the Pla8ma panel, whose widgets reach its ends, so the
    // strip is hit by throwing the pointer into the screen corner.
    Plasmoid.constraintHints: Plasmoid.CanFillArea
    activationTogglesExpanded: false

    toolTipMainText: i18n("Show desktop")
    // Without this Plasma shows the widget description as second line.
    toolTipSubText: ""

    Connections {
        target: Plasmoid
        function onActivated() {
            root.toggleDesktop();
        }
    }

    function toggleDesktop() {
        peekTimer.stop();
        if (peeking) {
            // Clicking while peeking keeps the desktop.
            peeking = false;
            return;
        }
        KWindowSystem.showingDesktop = !KWindowSystem.showingDesktop;
    }

    function endPeek() {
        peekTimer.stop();
        if (peeking) {
            peeking = false;
            KWindowSystem.showingDesktop = false;
        }
    }

    Timer {
        id: peekTimer
        interval: 500
        onTriggered: {
            if (!KWindowSystem.showingDesktop) {
                root.peeking = true;
                KWindowSystem.showingDesktop = true;
            }
        }
    }

    compactRepresentation: Item {
        id: button

        // A narrow strip at the very end of the taskbar.
        readonly property int stripSize: Kirigami.Units.smallSpacing * 2

        Layout.minimumWidth: root.vertical ? 0 : stripSize
        Layout.preferredWidth: Layout.minimumWidth
        Layout.maximumWidth: root.vertical ? -1 : stripSize
        Layout.minimumHeight: root.vertical ? stripSize : 0
        Layout.preferredHeight: Layout.minimumHeight
        Layout.maximumHeight: root.vertical ? stripSize : -1

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            onContainsMouseChanged: {
                if (containsMouse) {
                    if (Plasmoid.configuration.peek) {
                        peekTimer.restart();
                    }
                } else {
                    root.endPeek();
                }
            }
            onClicked: root.toggleDesktop()

            // Nothing on hover. Only while the button is held it shows a lit
            // glass box: white at different opacities inside a dark outer
            // line, brightest at the top.
            Item {
                id: pressedLook

                anchors.fill: parent
                visible: mouseArea.pressed && mouseArea.containsMouse

                // Opacities at rows 2, 14, 28 and 37 of a 40 px tall box,
                // for the fill and the light inner lines left and
                // right. On a vertical panel the gloss runs down the short
                // side, so the lines are just part of the fill.
                readonly property var fillAlphas: root.vertical ? [0.70, 0.60, 0.51, 0.51] : [0.69, 0.59, 0.51, 0.51]
                readonly property var leftAlphas: root.vertical ? fillAlphas : [0.91, 0.77, 0.57, 0.64]
                readonly property var rightAlphas: root.vertical ? fillAlphas : [0.89, 0.69, 0.63, 0.68]

                // Position of a row of the 40 px box in the gradient running from
                // y = 2 to height - 2. The top 15 rows keep their size, the
                // rest stretches.
                function stop(row) {
                    const h = height;
                    let y;
                    if (root.vertical || h < 17) {
                        y = row * h / 40;
                    } else if (row <= 15) {
                        y = row;
                    } else {
                        y = 15 + (row - 15) * (h - 17) / 23;
                    }
                    return Math.max(0, Math.min(1, (y - 1.5) / Math.max(1, h - 4)));
                }

                // Dark outer line.
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: Qt.rgba(0, 0, 0, root.vertical ? 0.47 : 0.38)
                }
                // Light inner lines.
                Rectangle {
                    x: 1
                    y: 1
                    width: parent.width - 2
                    height: 1
                    color: Qt.rgba(1, 1, 1, root.vertical ? 0.82 : 0.86)
                }
                Rectangle {
                    x: 1
                    y: parent.height - 2
                    width: parent.width - 2
                    height: 1
                    color: Qt.rgba(1, 1, 1, 0.67)
                }
                // Left line, right line, fill.
                Repeater {
                    model: 3

                    Rectangle {
                        required property int index
                        readonly property var alphas: [pressedLook.leftAlphas, pressedLook.rightAlphas, pressedLook.fillAlphas][index]

                        x: index === 0 ? 1 : (index === 1 ? pressedLook.width - 2 : 2)
                        y: 2
                        width: index === 2 ? pressedLook.width - 4 : 1
                        height: pressedLook.height - 4
                        gradient: Gradient {
                            GradientStop { position: pressedLook.stop(2); color: Qt.rgba(1, 1, 1, alphas[0]) }
                            GradientStop { position: pressedLook.stop(14); color: Qt.rgba(1, 1, 1, alphas[1]) }
                            GradientStop { position: pressedLook.stop(28); color: Qt.rgba(1, 1, 1, alphas[2]) }
                            GradientStop { position: pressedLook.stop(37); color: Qt.rgba(1, 1, 1, alphas[3]) }
                        }
                    }
                }
            }
        }
    }

    fullRepresentation: Item {}
}

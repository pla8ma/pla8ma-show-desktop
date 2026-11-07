/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_peek: peek.checked

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: peek
            Kirigami.FormData.label: i18n("Peek:")
            text: i18n("Preview the desktop when the pointer rests on the button")
        }
    }
}

import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

Window {
    width: 950
    height: 750
    visible: true
    title: qsTr("Wordle")
    color: "#363434"

    WordleGame {
        id: wordleGame
        anchors.centerIn: parent
    }
}

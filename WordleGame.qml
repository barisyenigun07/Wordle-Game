import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import "Logic.js" as Logic

Item {
    id: game
    width: 400
    height: 600
    anchors.centerIn: parent
    property int rows: 6
    property int columns: 5
    property string secretWord: Logic.getRandomWord()
    property string currentGuess: ""
    property int currentRow: 0
    property string cgreen : "#08a818"
    property string cyellow : "#ffcb0f"
    property string cgrey : "#808080"
    property string cdgrey : "#5c5b59"
    signal gameWon()
    signal gameLost()
    signal wordDoesntExist()
    signal shouldEnter5Letter()
    signal updateColor()
    focus: true

    Keys.onPressed: (event) => {
        if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z) {
            if (game.currentGuess.length < game.columns) {
                  game.currentGuess += String.fromCharCode(event.key).toUpperCase();
            }
        }
        else if (event.key === Qt.Key_Backspace) {
            game.currentGuess = game.currentGuess.slice(0, -1);
        }
        else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            submitGuess();
        }
   }

    Column {
        id: wordleGrid
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: game.rows
            Row {
                spacing: 10
                Repeater {
                    id: repcol
                    property int outerindex: index
                    model: game.columns
                    Rectangle {
                        id: rect
                        width: 50
                        height: 50
                        radius: 8
                        color: game.cdgrey
                        Text {
                            id: txt
                            anchors.centerIn: parent
                            font.pixelSize: 24
                            color: "white"
                            text: {
                                if (repcol.outerindex === currentRow) {
                                    return currentGuess.charAt((index))
                                } else {
                                    try {
                                        let letter = Logic.oldGuesses[repcol.outerindex][index]
                                        if (letter) {
                                            if (letter.charAt(1) === "G") {
                                                parent.color = game.cgreen;
                                            } else if (letter.charAt(1) === "Y") {
                                                parent.color = game.cyellow;
                                            } else {
                                                parent.color = game.cgrey;
                                            }
                                            return letter.charAt(0);
                                        }
                                    }
                                    catch (err) {
                                        return " ";
                                    }
                                }


                            }
                        }
                    }
                }
            }
        }
    }


    Column {
        id: keyboard
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter


        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
                Rectangle {
                    width: 40
                    height: 40
                    radius: 5
                    color: cdgrey
                    id: parentrect1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (game.currentGuess.length < 5) {
                                game.currentGuess += modelData;
                            }
                        }
                    }
                    Connections {
                        target: game
                        onUpdateColor: {
                            const getColor = () => {
                                if (Logic.greenLetters.includes(Logic.letters[0][index])) {
                                   return game.cgreen;
                                } else if (Logic.yellowLetters.includes(Logic.letters[0][index])) {
                                   return game.cyellow;
                                } else if (Logic.greyLetters.includes(Logic.letters[0][index])) {
                                   return game.cgrey;
                                } else {
                                   return game.cdgrey;
                                }
                            }
                            parentrect1.color = getColor();
                        }
                    }
                }
            }
        }
        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 25
            Repeater {
                model: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
                Rectangle {
                    width: 40
                    height: 40
                    radius: 5
                    color: game.cdgrey
                    id: parentrect2

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (game.currentGuess.length < 5) {
                                game.currentGuess += modelData
                            }
                        }
                    }
                    Connections {
                        target: game
                        onUpdateColor: {
                            const getColor = () => {
                                if (Logic.greenLetters.includes(Logic.letters[1][index])) {
                                   return game.cgreen;
                                } else if (Logic.yellowLetters.includes(Logic.letters[1][index])) {
                                   return game.cyellow;
                                } else if (Logic.greyLetters.includes(Logic.letters[1][index])) {
                                   return game.cgrey;
                                } else {
                                   return game.cdgrey;
                                }
                            }
                            parentrect2.color = getColor();
                        }
                    }

                }

            }
        }


        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 60

            Repeater {
                model: ["Enter", "Z", "X", "C", "V", "B", "N", "M", "Delete"]
                Rectangle {
                    id: parentrect3
                    width: (modelData === "Enter" || modelData === "Delete") ? 60 : 40
                    height: 40
                    radius: 5
                    color: game.cdgrey


                    Connections {
                        target: game
                        onUpdateColor: {
                            const getColor = () => {
                                if (Logic.greenLetters.includes(Logic.letters[2][index])) {
                                   return game.cgreen;
                                } else if (Logic.yellowLetters.includes(Logic.letters[2][index])) {
                                   return game.cyellow;
                                } else if (Logic.greyLetters.includes(Logic.letters[2][index])) {
                                   return game.cgrey;
                                } else {
                                   return game.cdgrey;
                                }
                            }
                            parentrect3.color = getColor();
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: "white"

                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData === "Enter") {
                                submitGuess();
                            }
                            else if (modelData === "Delete") {
                                game.currentGuess = game.currentGuess.slice(0, -1);
                            }
                            else {
                                game.currentGuess += modelData;
                            }
                        }
                    }
                }
            }
        }
    }
    Connections {
        target: game
        onWordDoesntExist: {
            warningDialog.text = "Entered word does not exist in the list!"
            warningDialog.open()
        }
        onShouldEnter5Letter: {
            shouldEnter5LetterDialog.text = "You should enter 5 letters!";
            shouldEnter5LetterDialog.open()
        }

        onGameWon: {
            messageDialog.text = "Congratulations! You've won!"
            messageDialog.open()
        }
        onGameLost: {
            messageDialog.text = "Game Over! The word was " + game.secretWord
            messageDialog.open()
        }
    }
    MessageDialog {
        id: messageDialog
        onAccepted: {
            Qt.quit()
        }
    }

   MessageDialog {
       id: warningDialog
   }

   MessageDialog {
       id: shouldEnter5LetterDialog
   }

   function submitGuess() {
       if (game.currentGuess.length === 5) {
           if (Logic.words.includes(game.currentGuess)) {
               let charArray = new Array(5);
               let secretWordArray = [...game.secretWord];
               for (let i = 0; i < 5; i++) {
                   if (game.currentGuess[i] === game.secretWord[i]) {
                       //green
                       charArray[i] = game.currentGuess[i] + "G";
                       secretWordArray.splice(i, 1); //to prevent extra highlighting
                       if (!Logic.greenLetters.includes(game.currentGuess[i])) {
                           //Keyboard coloring -> green
                           Logic.greenLetters.push(game.currentGuess[i]);
                           //Preventing multiple one key from entering multiple color arrays
                           if (Logic.yellowLetters.includes(game.currentGuess[i])) {                             
                               Logic.yellowLetters.splice(i, 1);
                           }
                           if (Logic.greyLetters.includes(game.currentGuess[i])) {
                               Logic.greyLetters.splice(i, 1);
                           }
                       }
                   }
                   else if (secretWordArray.includes(game.currentGuess[i])) {
                      //yellow
                       charArray[i] = game.currentGuess[i] + "Y"; // letter + (G)reen / (Y)ellow / (N)ull
                       let index = secretWordArray.indexOf(game.currentGuess[i]);
                       secretWordArray.splice(index, 1); //to prevent extra highlighting
                       if (!Logic.yellowLetters.includes(game.currentGuess[i]) && !Logic.greenLetters.includes(game.currentGuess[i])) {
                           Logic.yellowLetters.push(game.currentGuess[i]);
                           if (Logic.greyLetters.includes(game.currentGuess[i])) {
                               Logic.greyLetters.splice(i, 1); //Preventing multiple one key from entering multiple color arrays
                           }
                       }
                   }
                   else {
                       // grey / null
                       charArray[i] = game.currentGuess[i] + "N";
                       if (!Logic.yellowLetters.includes(game.currentGuess[i]) && !Logic.greenLetters.includes(game.currentGuess[i]) && !Logic.greyLetters.includes(game.currentGuess[i])) {
                           Logic.greyLetters.push(game.currentGuess[i]);
                       }
                   }
               }
               Logic.oldGuesses[game.currentRow] = charArray;
               game.currentRow++;
               if (game.currentGuess === game.secretWord) {
                   gameWon();
               }
               else if (game.currentRow > game.rows - 1) {
                   gameLost();
               }
               game.currentGuess = "";
               updateColor();
           }
           else {
               wordDoesntExist();
           }
       }
       else {
           shouldEnter5Letter();
       }
   }
}

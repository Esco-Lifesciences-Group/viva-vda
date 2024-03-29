/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    //    height: 600
    //    width: 1024
    title: "LCD Brightness"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: qsTr("LCD Brightness")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 32
                        text: slider.value + "%"
                    }//

                    SliderApp {
                        id: slider
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 500
                        stepSize: 5
                        from: 5
                        to: 100
                        padding: 0
                        value: MachineData.lcdBrightnessLevel

                        Image {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/UI/Pictures/brightness_lowest_icon.png"
                        }

                        Image {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/UI/Pictures/brightness_highest_icon.png"
                        }

                        onValueChanged: {
                            if (pressed) {
                                MachineAPI.setLcdBrightnessLevel(slider.value)
                            }//
                        }//

                        onPressedChanged: {
                            if (!pressed) {
                                //                                ////console.debug("released")
                                MachineAPI.saveLcdBrightnessLevel(slider.value);
                                MachineAPI.insertEventLog(qsTr("User: Set LCD Brightness to %1%").arg(slider.value))
                            }//
                        }//
                    }//

                    Row {
                        spacing: 10

                        ComboBoxApp {
                            id: comboBox
                            width: 150
                            height: 50
                            backgroundColor: "#0F2952"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            popupHeight: 120

                            textRole: "text"

                            model: [
                                {text: qsTr("Disable"),    value: 0},
                                {text: qsTr("1 minute"),   value: 1},
                                {text: qsTr("5 minutes"),  value: 5},
                                {text: qsTr("15 minutes"), value: 15}
                            ]

                            onActivated: {
                                /// console.debug(index)
                                /// console.debug(model[index].value)

                                let time = model[index].value
                                const timeText = model[index].text
                                MachineAPI.setLcdBrightnessDelayToDimm(time)
                                let strEvent = time ? qsTr("User: Set LCD to dim automatically in %1.").arg(timeText)
                                                    : qsTr("User: Set LCD to dim automatically is disabled.")
                                MachineAPI.insertEventLog(strEvent)
                            }

                            Component.onCompleted: {
                                let time = MachineData.lcdBrightnessDelayToDimm
                                if (time === 0) {
                                    currentIndex = 0
                                }
                                else if (time === 1) {
                                    currentIndex = 1
                                }
                                else if (time === 5) {
                                    currentIndex = 2
                                }
                                else if (time === 15) {
                                    currentIndex = 3
                                }
                            }
                        }//

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("to dim automatically")
                        }//
                    }//

                    Row{
                        spacing: 10
                        CheckBoxApp{
                            checked: MachineData.lcdEnableLockScreen
                            text: qsTr("Enable lock screen")
                            onCheckedChanged: {
                                MachineAPI.setLcdEnableLockScreen(checked)
                                MachineAPI.insertEventLog(qsTr("User: Set Enable lock screen") + " %1".arg(checked))
                            }
                        }
                    }
                }//

                TextApp{
                    anchors.bottom: parent.bottom
                    width : parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "*" + qsTr("If the lock screen is enabled, the screen will be locked when auto-dim is activated.")
                    font.pixelSize: 18
                }
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    // border.color: "#e3dac9"
                    // border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/

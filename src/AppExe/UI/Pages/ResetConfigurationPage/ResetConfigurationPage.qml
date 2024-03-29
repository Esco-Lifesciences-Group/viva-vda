/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono|Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Reset Configuration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Reset Configuration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Column{
                    anchors.centerIn: parent
                    spacing: 20

                    Column{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Export Configuration")
                            font.bold: true
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("To backup all existing configuration or parameter settings.")
                        }
                    }//
                    Column{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Import Configuration")
                            font.bold: true
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: qsTr("Import all configuration settings or parameters from external storage or previously backed-up files.") + "<br>"
                                  + qsTr("Existing configurations or settings will be replaced.")
                        }
                    }//
                }//
                TextApp{
                    anchors.centerIn: parent
                    visible: !MachineData.getSbcCurrentSerialNumberKnown()
                    font.pixelSize: 24
                    text: qsTr("Sorry, this screen is currently unavailable!")
                }//
                TextApp{
                    visible: MachineData.getSbcCurrentSerialNumberKnown()
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 16
                    text: qsTr("Data logging will not be affected.")
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
                    //border.color: "#e3dac9"
                    //border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//

                        Row{
                            spacing: 5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            ButtonBarApp {
                                visible: MachineData.getSbcCurrentSerialNumberKnown()
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
                                imageSource: "qrc:/UI/Pictures/restore-btn.png"
                                text: qsTr("Export Configuration")

                                onClicked: {
                                    //console.debug(Qt.application.name)
                                    let fileSource = "/home/root/.config/escolifesciences/%1.conf".arg(Qt.application.name)
                                    const intent = IntentApp.create("qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml",
                                                                    {
                                                                        "sourceFilePath": fileSource,
                                                                        "dontRmFile": 1,
                                                                    });
                                    startView(intent);
                                }
                            }//
                            ButtonBarApp {
                                visible: MachineData.getSbcCurrentSerialNumberKnown()
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
                                imageSource: "qrc:/UI/Pictures/backup-btn.png"
                                text: qsTr("Import Configuration")

                                onClicked: {
                                    //console.debug("this pressed")
                                    const intent = IntentApp.create("qrc:/UI/Pages/ResetConfigurationPage/ChooseConfigFilePage.qml", {})
                                    startView(intent)
                                }
                            }//
                        }
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/

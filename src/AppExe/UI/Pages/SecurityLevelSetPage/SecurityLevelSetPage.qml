/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Security Access Level"

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
                    id:headerApp
                    anchors.fill: parent
                    title: qsTr("Security Access Level")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    spacing: 10
                    anchors.centerIn: parent

                    Column {
                        spacing: 5
                        Rectangle {
                            height: 200
                            width: 200
                            color: "transparent"
                            radius: 5

                            Image {
                                anchors.fill: parent
                                id: lessSecureImage
                                source: "qrc:/UI/Pictures/lowsecure.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            Loader {
                                //                                active: props.securityAccessLevel == 0
                                active: props.securityAccessLevel === MachineAPI.MODE_SECURITY_ACCESS_LOW
                                anchors.centerIn: parent
                                sourceComponent: Image {
                                    source: "qrc:/UI/Pictures/done-green-white.png"
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    //props.securityAccessLevel = 0
                                    if(props.securityAccessLevel !== MachineAPI.MODE_SECURITY_ACCESS_LOW){
                                        //props.securityAccessLevel = MachineAPI.MODE_SECURITY_ACCESS_LOW
                                        const textSecureLevel = "<b>" + qsTr("Set security level to low?") + "</b>"
                                                              + "<br><br>"
                                                              + qsTr("Control button will not require login. User menu will require login.")
                                        viewApp.showDialogAsk(qsTr("Notification"),
                                                              textSecureLevel,
                                                              viewApp.dialogAlert,
                                                              function onAccepted(){
                                                                  MachineAPI.setSecurityAccessModeSave(MachineAPI.MODE_SECURITY_ACCESS_LOW)
                                                                  MachineAPI.insertEventLog(qsTr("User: Set security level to low"))
                                                                  viewApp.showBusyPage(qsTr("Setting up..."),
                                                                                       function onCycle(cycle){
                                                                                           if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                                                   || MachineData.securityAccessMode === MachineAPI.MODE_SECURITY_ACCESS_LOW){
                                                                                               viewApp.closeDialog()
                                                                                           }//
                                                                                       })//
                                                              })//
                                    }//
                                }//
                            }//
                        }//

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Low")
                        }//
                    }//

                    //                    Column {
                    //                        spacing: 5
                    //                        Rectangle {
                    //                            height: 200
                    //                            width: 200
                    //                            color: "transparent"
                    //                            radius: 5

                    //                            Image {
                    //                                anchors.fill: parent
                    //                                id: mediumSecureImage
                    //                                source: "qrc:/UI/Pictures/mediumsecure.png"
                    //                                fillMode: Image.PreserveAspectFit
                    //                            }

                    //                            Loader {
                    //                                //                                active: props.securityAccessLevel == 1
                    //                                active: props.securityAccessLevel === MachineAPI.MODE_SECURITY_ACCESS_MEDIUM
                    //                                anchors.centerIn: parent
                    //                                sourceComponent:Image {
                    //                                    source: "qrc:/UI/Pictures/done-green-white.png"
                    //                                }//
                    //                            }//

                    //                            MouseArea {
                    //                                anchors.fill: parent
                    //                                onClicked: {
                    //                                    //                                    props.securityAccessLevel = MachineAPI.MODE_SECURITY_ACCESS_MEDIUM

                    //                                    if(props.securityAccessLevel !== MachineAPI.MODE_SECURITY_ACCESS_MEDIUM){
                    //                                        //                                        props.securityAccessLevel = MachineAPI.MODE_SECURITY_ACCESS_MEDIUM
                    //                                        const textSecureLevel = "<b>" + qsTr("Set security level to moderate?") + "</b>"
                    //                                                              + "<br><br>"
                    //                                                              + qsTr("Control button will not require login. User menu will require login.")

                    //                                        viewApp.showDialogAsk(qsTr("Notification"),
                    //                                                              textSecureLevel,
                    //                                                              viewApp.dialogAlert,
                    //                                                              function onAccepted(){
                    //                                                                  MachineAPI.setSecurityAccessModeSave(MachineAPI.MODE_SECURITY_ACCESS_MEDIUM)
                    //                                                                  MachineAPI.insertEventLog(qsTr("User: Set security level to moderate"))

                    //                                                                  viewApp.showBusyPage(qsTr("Setting up..."),
                    //                                                                                       function onCycle(cycle){
                    //                                                                                           if (cycle >= MachineAPI.BUSY_CYCLE_1
                    //                                                                                                   || MachineData.securityAccessMode === MachineAPI.MODE_SECURITY_ACCESS_MEDIUM){

                    //                                                                                               viewApp.closeDialog()
                    //                                                                                           }
                    //                                                                                       })
                    //                                                              })
                    //                                    }//
                    //                                }//
                    //                            }//
                    //                        }//

                    //                        TextApp {
                    //                            anchors.horizontalCenter: parent.horizontalCenter
                    //                            text: qsTr("Moderate")
                    //                        }//
                    //                    }//

                    Column {
                        spacing: 5
                        Rectangle {
                            height: 200
                            width: 200
                            color: "transparent"
                            radius: 5

                            Image {
                                anchors.fill: parent
                                id: highSecureImage
                                source: "qrc:/UI/Pictures/highsecure.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            Loader {
                                active: props.securityAccessLevel === MachineAPI.MODE_SECURITY_ACCESS_HIGH
                                anchors.centerIn: parent
                                sourceComponent: Image {
                                    source: "qrc:/UI/Pictures/done-green-white.png"
                                }//
                            }//

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(props.securityAccessLevel !== MachineAPI.MODE_SECURITY_ACCESS_HIGH ){

                                        const textSecureLevel = "<b>" + qsTr("Set security level to high?") + "</b>"
                                                              + "<br><br>"
                                                              + qsTr("Both control button and user menu will require login.")

                                        viewApp.showDialogAsk(qsTr("Notification"),
                                                              textSecureLevel,
                                                              viewApp.dialogAlert,
                                                              function onAccepted() {
                                                                  MachineAPI.setSecurityAccessModeSave(MachineAPI.MODE_SECURITY_ACCESS_HIGH)
                                                                  MachineAPI.insertEventLog(qsTr("User: Set security level to high"))

                                                                  viewApp.showBusyPage(qsTr("Setting up"),
                                                                                       function onCycle(cycle){
                                                                                           if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                                                   || MachineData.securityAccessMode === MachineAPI.MODE_SECURITY_ACCESS_HIGH){
                                                                                               viewApp.closeDialog()
                                                                                           }
                                                                                       })
                                                              })//
                                    }//
                                }//
                            }//
                        }//

                        TextApp {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("High")
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int securityAccessLevel: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                ////console.debug("StackView.Active");

                props.securityAccessLevel = Qt.binding(function() {return MachineData.securityAccessMode })
                console.log("securityAccessLevel" + props.securityAccessLevel)
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

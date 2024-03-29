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
    title: "Manual Input Calibration"

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
                    title: qsTr("Manual Input Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextApp {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    text: {
                        "<h2>" + qsTr("ATTENTION!") + "</h2>" + "<br>" +
                                qsTr("The following screens are used to modify the operation of the Cabinet.") + "<br>" +
                                qsTr("This should only be accessed by a qualified certifier as part of the certification process.") + "<br>" + "<br>" +
                                qsTr("This menu should only be accessed when the fan is off,<br>otherwise fan will be automatically turned off by system.")
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

                            imageSource: "qrc:///UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/next-step.png"
                            text: qsTr("Next")

                            onClicked: {
                                MachineAPI.setOperationMaintenanceMode()

                                if (props.fanState) {
                                    MachineAPI.setFanState(MachineAPI.FAN_STATE_OFF);
                                }//

                                showBusyPage(qsTr("Please wait..."),
                                             function onCallback(cycle){
                                                 if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                         || MachineData.operationMode === MachineAPI.MODE_OPERATION_MAINTENANCE){
                                                     //                                                     if (props.operationMode == MachineAPI.MODE_OPERATION_MAINTENANCE){
                                                     var intent = IntentApp.create("qrc:/UI/Pages/ManualInputDataPage/ManualInputDataPage.qml", {})
                                                     finishView(intent)
                                                     //                                                     }
                                                 }
                                             })
                            }//
                        }//
                    }//
                }//
            }
        }//

        QtObject {
            id: props

            property int operationMode: 0
            property int fanState: 0
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                ////console.debug("StackView.Active");

                props.operationMode = Qt.binding(function(){ return MachineData.operationMode })
                props.fanState = Qt.binding(function(){ return MachineData.fanPrimaryState })
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/

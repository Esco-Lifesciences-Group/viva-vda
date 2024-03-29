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
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full Sensor Calibration"

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
                    title: qsTr("Full Sensor Calibration")
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
                        "<h2>" + qsTr("ATTENTION!") + "</h2>" +
                                "<br>" + qsTr("The following screens are used to modify the operation of the Cabinet.") +
                                "<br>" + qsTr("This should only be accessed by a qualified certifier as part of the certification process.")
                    }
                }

                //                Column {
                //                    anchors.centerIn: parent

                //                    TextApp {
                //                        anchors.horizontalCenter: parent.horizontalCenter
                //                        text: lightIntensitySlider.value + "%"
                //                    }

                //                    Slider {
                //                        id: lightIntensitySlider
                //                        anchors.horizontalCenter: parent.horizontalCenter
                //                        width: 500
                //                        stepSize: 5
                //                        from: 30
                //                        to: 100

                //                        onValueChanged: {
                //                            if (pressed) {
                //                                MachineProxy.setLightIntensity(value)
                //                            }
                //                        }
                //                    }
                //                }
            }

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
                                var intent = IntentApp.create(uri, {"navigation":"back"})
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
                                //                                MachineAPI.setOperationMaintenanceMode()
                                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Calibration)

                                var intent = IntentApp.create("qrc:/UI/Pages/FullCalibrateSensorPage/Pages/_NavigationCalibratePage.qml", {})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                ////console.debug("StackView.Active");

                //                    lightIntensitySlider.value = MachineData.lightIntensity
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

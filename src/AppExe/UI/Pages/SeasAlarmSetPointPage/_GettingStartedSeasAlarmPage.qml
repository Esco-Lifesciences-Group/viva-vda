﻿/**
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
    title: "Pressure Alarm Setpoint"

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
                    title: qsTr("Pressure Alarm Setpoint")
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
                    text: qsTr("<h2>ATTENTION!</h2>\
                        <br>The following screens are used to modify the operation of the Cabinet.\
                        <br>This should only be accessed by a qualified certifier as part of the certification process.")
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
                                //                                const calibPhase = props.airflowCalibPhase

                                //                                if (calibPhase < MachineAPI.AF_CALIB_FACTORY){

                                //                                    const message = "<b>" + qsTr("Don't allow to field sensor calibration!") + "</b>"
                                //                                                  + "<br><br>"
                                //                                                  + qsTr("Required to perform full sensor calibration first") + "."
                                //                                    showDialogMessage(qsTr(title),
                                //                                                      message,
                                //                                                      dialogAlert,
                                //                                                      function(){})
                                //                                    return
                                //                                }

                                //                                var intent = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Pages/_NavigationCalibratePage.qml", {})
                                //                                finishView(intent)
                                MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Calibration)

                                var intent = IntentApp.create("qrc:/UI/Pages/SeasAlarmSetPointPage/SeasAlarmPage.qml", {})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property int airflowCalibPhase: 0
        }//

        /// called Once but after onResume
        Component.onCompleted: {
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.airflowCalibPhase = MachineData.airflowCalibrationStatus
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

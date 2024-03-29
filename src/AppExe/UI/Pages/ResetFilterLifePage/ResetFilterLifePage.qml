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
    title: "Reset Filter Life"

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
                    title: qsTr("Reset Filter Life")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    id: currentValueColumn
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Current life left")
                        color: "#cccccc"
                    }//

                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerUsage
                        font.pixelSize: 36
                        wrapMode: Text.WordWrap
                        text:  props.lifeMeter + "%" + " (" + utils.strfMinToHumanReadableShort(props.currentMeter) + ")"
                    }//
                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerUsage
                        text: qsTr("Typical life up to 10,000 hours or 600,000 minutes") //120000  //minutes or 2000 hours
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//
                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerUsage
                        text: qsTr("Counts per minute") //120000  //minutes or 2000 hours
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//


                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm
                        font.pixelSize: 36
                        wrapMode: Text.WordWrap
                        text:  props.lifeMeter + "%" + " (%1 RPM)".arg(MachineData.filterLifeRpm)
                    }//
                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm
                        text: qsTr("Filter life 0 - 100% is corresponding to nominal fan RPM %1 - %2").arg(MachineData.filterLifeMaximumBlowerRpmMode).arg(MachineData.filterLifeMinimumBlowerRpmMode)
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//
                    TextApp {
                        visible: MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm
                        text: qsTr("Counting by nominal fan RPM") //120000  //minutes or 2000 hours
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//

                    TextApp{
                        text: qsTr("Tap here to set")
                        color: "#cccccc"
                        font.pixelSize: 16
                    }//
                }//

                MouseArea {
                    anchors.fill: currentValueColumn
                    onClicked: {
                        KeyboardOnScreenCaller.openNumpad(newValueTextField, qsTr("Reset Filter Life (0 - 100%)"))
                    }//
                }//

                TextFieldApp {
                    id: newValueTextField
                    visible: false

                    onAccepted: {
                        let val = Number(text)
                        MachineAPI.setFilterUsageMeter(val)
                        MachineAPI.insertEventLog(qsTr("Reset Filter Life to %1%").arg(val))

                        showBusyPage(qsTr("Setting up..."), function(cycle){
                            if(cycle >= MachineAPI.BUSY_CYCLE_1
                                    || MachineData.filterLifePercent === val) {
                                closeDialog()
                            }
                        })
                    }
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

                        ButtonBarApp {
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/settings-icon-35px.png"
                            text: qsTr("Settings")

                            onClicked: {
                                var intent = IntentApp.create("qrc:/UI/Pages/ResetFilterLifePage/FilterLifeSettingPage.qml", {"message":""})
                                startView(intent)
                            }
                        }//
                    }//
                }//
            }
        }//

        UtilsApp {
            id: utils
        }

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int currentMeter: 0
            property int lifeMeter: 0
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.currentMeter = Qt.binding(function(){return MachineData.filterLifeMinutes})
                props.lifeMeter = Qt.binding(function(){return MachineData.filterLifePercent})
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

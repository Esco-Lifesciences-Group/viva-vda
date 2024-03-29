/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Warmup Timer"
    
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
                    title: qsTr("Warmup Timer")
                }
            }
            
            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image{
                            source: "qrc:/UI/Pictures/postpurge-option-icon.png"
                            fillMode: Image.PreserveAspectFit
                        }
                        
                        ComboBoxApp {
                            id: comboBox
                            //enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelSupervisor
                            width: 190
                            height: 50
                            backgroundColor: enabled ? "#0F2952" : "#404244"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"
                            
                            //model: props.modelList
                            
                            onActivated: {
                                //////console.debug(index)
                                //////console.debug(model[index].value)
                                let newValue = model[index].value
                                if(MachineData.warmingUpTime !== newValue){
                                    //  props.warmupTimer = newValue
                                    //  //console.debug("Warm: ", props.warmupTimer , " min")
                                    MachineAPI.setWarmingUpTimeSave(newValue)
                                    MachineAPI.insertEventLog(qsTr("User: Set warmup time to %1").arg(model[index].text))

                                    viewApp.showBusyPage((qsTr("Setting up...")),
                                                         function onTriggered(cycle){
                                                             if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                                     || MachineData.warmingUpTime === newValue){
                                                                 viewApp.dialogObject.close()}
                                                         })
                                }
                            }
                            
                            //                            Component.onCompleted: {
                            //                                if(props.warmupTimer == 3)
                            //                                    currentIndex = 0
                            //                                else if(props.warmupTimer == 5)
                            //                                    currentIndex = 1
                            //                                else if(props.warmupTimer == 15)
                            //                                    currentIndex = 2
                            //                                else currentIndex = 0
                            //                            }
                        }//
                    }//

                    TextApp {
                        width: 500
                        minimumPixelSize: 20
                        text: qsTr("\
As the user turns on the internal fan, the warmup period follows. \
This is to ensure that the sensors, the blower, and the control system are stabilized.")
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignJustify
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
            }
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int warmupTimer: 3
            property var modelList1 : [
                {text: qsTr("3 Minutes"),   value: 180},
                {text: qsTr("5 Minutes"),   value: 300},
                {text: qsTr("15 Minutes"),  value: 900}
            ]
            property var modelList2 : [
                {text: qsTr("1 Minute"),   value: 60},
                {text: qsTr("3 Minutes"),   value: 180},
                {text: qsTr("5 Minutes"),   value: 300},
                {text: qsTr("15 Minutes"),  value: 900}
            ]
            property var modelList3: [
                {text: qsTr("Disable"),   value: 0},
                {text: qsTr("3 Minutes"),   value: 180},
                {text: qsTr("5 Minutes"),   value: 300},
                {text: qsTr("15 Minutes"),  value: 900}
            ]
            property var modelList4: [
                {text: qsTr("Disable"),   value: 0},
                {text: qsTr("1 Minute"),   value: 60},
                {text: qsTr("3 Minutes"),   value: 180},
                {text: qsTr("5 Minutes"),   value: 300},
                {text: qsTr("15 Minutes"),  value: 900}
            ]
        }

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                let constant = 0;
                let modelListSelected = []

                if(!MachineData.getInflowSensorConstant()){
                    if(!MachineData.airflowMonitorEnable)
                        modelListSelected = props.modelList4
                    else
                        modelListSelected = props.modelList2
                }
                else{
                    if(!MachineData.airflowMonitorEnable)
                        modelListSelected = props.modelList3
                    else
                        modelListSelected = props.modelList1
                    constant = 1
                }

                comboBox.model = modelListSelected

                props.warmupTimer = MachineData.warmingUpTime
                ////console.debug("Constant If:", MachineData.getInflowSensorConstant())
                ////console.debug("comboBox.count", comboBox.count)
                let currIndex = 0
                for(let i=0; i<modelListSelected.length; i++){
                    if(props.warmupTimer === modelListSelected[i]["value"]){
                        currIndex = i
                        break;
                    }//
                }//

                comboBox.currentIndex = currIndex

                //console.debug("currentIndex", currIndex)

                //                if(constant){
                //                    if(props.warmupTimer == 180)
                //                        comboBox.currentIndex = 0
                //                    else if(props.warmupTimer == 300)
                //                        comboBox.currentIndex = 1
                //                    else if(props.warmupTimer == 900)
                //                        comboBox.currentIndex = 2
                //                    else comboBox.currentIndex = 0
                //                }else{
                //                    if(props.warmupTimer == 60)//1 minute
                //                        comboBox.currentIndex = 0
                //                    else if(props.warmupTimer == 180)// 3 minutes
                //                        comboBox.currentIndex = 1
                //                    else if(props.warmupTimer == 300)// 5 minutes
                //                        comboBox.currentIndex = 2
                //                    else if(props.warmupTimer == 900)// 15 minutes
                //                        comboBox.currentIndex = 3
                //                    else comboBox.currentIndex = 0
                //                }
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

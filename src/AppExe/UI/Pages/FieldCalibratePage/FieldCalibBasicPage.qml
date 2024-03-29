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
    title: "Field Sensor Calibration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        StackViewApp {
            id: stackView
            anchors.fill: parent

            Component.onCompleted: {
                var intent = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/_GettingStartedPage.qml", {})
                stackView.push(intent.uri, {"uri": intent.uri, "intent": intent})
            }

            Connections{
                target: stackView.currentItem

                function onStartView(newIntent) {
                    ////console.debug("onStartView: " + newIntent)
                    ////console.debug("onStartView-intent: " + newIntent.uri)
                    stackView.push(newIntent.uri, {"uri": newIntent.uri, "intent": newIntent})
                }

                function onStartRootView(newIntent) {
                    ////console.debug("onstartRootView: " + newIntent)
                    ////console.debug("onstartRootView-intent: " + newIntent.uri)

                    if (stackView.depth > 1){
                        stackView.pop(null)
                    }

                    if (stackView.currentItem.uri !== newIntent.uri){
                        stackView.replace(newIntent.uri, {"uri": newIntent.uri,  "intent": newIntent})
                    } else {
                        /// IF LAST CURENT ITEM IS THE SAME WITH TARGET URI
                        /// DON'T RELOAD
                        /// put object intent from previous page to current page
                        /// in case the current view needs onViewResult
                        stackView.currentItem.intent = newIntent;
                    }
                }

                function onFinishView(intentResultFinishView) {
                    if (intentResultFinishView.uri === stackView.currentItem.uri) {
                        if (stackView.depth > 1){
                            stackView.pop()
                            stackView.currentItem.finishViewReturned(intentResultFinishView)
                            //stackView.pop()
                            //stackView.currentItem.intentResultFinishView = intentResultFinishView
                        }
                        else {
                            const extraData = IntentApp.getExtraData(intentResultFinishView)
                            let skipped = extraData["skip"] || false
                            let done = extraData["done"] || false
                            //console.debug("skip:", skipped, "done:", done)
                            props.skipped = skipped
                            props.calibDone = done

                            props.confirmBackToClose()
                            ///// Back to Main Menu
                            // let intent = IntentApp.create(uri, {})
                            // finishView(intent)
                        }
                    }
                    else {
                        /// current page want to finished
                        /// but also want to open new page
                        stackView.replace(intentResultFinishView.uri, {"uri": intentResultFinishView.uri, "intent": intentResultFinishView})
                    }//
                }//
            }//
        }//

        QtObject {
            id: props

            property int operationModeBackup: 0
            property string pgStart: "qrc:/UI/Pages/FieldCalibratePage/Basic/_GettingStartedPage.qml"
            property string pgEnd: "qrc:/UI/Pages/FieldCalibratePage/Basic/_CalibrationFinishedPage.qml"

            property bool calledFromWalcomeSetup: false
            property bool skipped: false
            property bool calibDone: false

            function confirmBackToClose(){
                const currentPage = stackView.currentItem.uri
                if ((currentPage === props.pgStart) || (currentPage === props.pgEnd)) {
                    if ((props.calledFromWalcomeSetup && (currentPage === props.pgEnd)) || props.skipped ){
                        /// give indicator to welcome setup
                        let intent1 = IntentApp.create(uri, {"welcomesetupdone": 1, "done": props.calibDone})
                        finishView(intent1)
                    }
                    else {
                        //console.debug("/// Back to Main Menu")
                        let intent2 = IntentApp.create(uri, {"done": props.calibDone})
                        finishView(intent2)
                    }
                }
                else {
                    const message = qsTr("Exit from sensor calibration?")
                    //                    let executed = false
                    showDialogAsk(qsTr(title),
                                  message,
                                  dialogAlert,
                                  function onAccepted(){
                                      // showBusyPage(qsTr("Please wait..."),
                                      //              function onCallback(cycle){
                                      //                  if(cycle === MachineAPI.BUSY_CYCLE_1 && !executed) {
                                      if(!MachineData.installationWizardActive)
                                          MachineAPI.setOperationPreviousMode()
                                      /// Back to Main Menu
                                      MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
                                      let intent1 = IntentApp.create(uri, {})
                                      finishView(intent1)
                                  }, function(){}, function(){}, false)//
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {

            //            props.operationModeBackup = MachineData.operationMode

            /// override gesture swipe action
            /// basicly dont allow gesture shortcut to home page during calibration
            viewApp.fnSwipedFromLeftEdge = function(){
                props.confirmBackToClose()
            }

            viewApp.fnSwipedFromBottomEdge = function(){
                const currentPage = stackView.currentItem.uri
                if ((currentPage === props.pgStart) || (currentPage === props.pgEnd)) {
                    if (props.calledFromWalcomeSetup && (currentPage === props.pgEnd) ){
                        /// give indicator to welcome setup
                        let intent = IntentApp.create(uri, {"welcomesetupdone": 1})
                        finishView(intent)
                    }
                    else {
                        /// Back to Main Menu
                        let intent = IntentApp.create(uri, {})
                        finishView(intent)
                    }
                }
                else {
                    const message = qsTr("Exit from sensor calibration?")
                    let executed = false
                    showDialogAsk(qsTr(title),
                                  message,
                                  dialogAlert,
                                  function onAccepted() {
                                      // showBusyPage(qsTr("Please wait..."),
                                      //              function onCallback(cycle){
                                      //                  if(cycle === MachineAPI.BUSY_CYCLE_1 && !executed) {
                                      //                      //                                                           MachineAPI.setOperationMode(props.operationModeBackup)
                                      if(!MachineData.installationWizardActive)
                                          MachineAPI.setOperationPreviousMode()
                                      MachineAPI.setInflowSensorConstantTemporary(MachineData.getInflowSensorConstant())
                                      MachineAPI.setFrontEndScreenState(MachineAPI.ScreenState_Other)
                                      const intent = IntentApp.create("", {})
                                      startRootView(intent)
                                  }, function(){}, function(){}, false)//
                }//
            }//
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                const extraData = IntentApp.getExtraData(intent)
                props.calledFromWalcomeSetup = extraData["welcomesetup"] || false

                if(props.calledFromWalcomeSetup){
                    MachineAPI.setLightState(true);
                    stackView.clear()
                    let intent1 = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/_GettingStartedPage.qml",
                                                   {"welcomesetup": true})
                    stackView.push(intent1.uri, {"uri": intent1.uri, "intent": intent1})

                    viewApp.enabledSwipedFromLeftEdge   = false
                    //viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:480;width:800}
}
##^##*/

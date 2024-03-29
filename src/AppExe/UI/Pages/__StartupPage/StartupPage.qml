/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import QtQuick.Controls 2.0
//import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import UserManageQmlApp 1.0

import ModulesCpp.Connectify 1.0
import ModulesCpp.Machine 1.0
import ModulesCpp.Settings 1.0

ViewApp {
    id: viewApp
    title: "Startup"

    property int loopCycle: 0

    signal progressBarHasFull()
    onProgressBarHasFull: {
        /// Setup
        /// Header
        /// Cabinet model name
        HeaderAppService.modelName = (MachineData.machineClassName + "<br>" + MachineData.machineModelName)
        /// HeaderAppService.modelName = "CLASS II C1" + "<br>" + "LC1"
        /// HeaderAppService.modelName = "CLASS II A2" + "<br>" + "AC2"
        /// Set time format, 12h or 24h
        HeaderAppService.timePeriod = MachineData.timeClockPeriod
        /// Alarm/Warning/Info Notification
        MachineData.alarmsStateChanged.connect(HeaderAppService.setAlert)
        /// The following sytax is to disconnect connection
        /// MachineData.alarmsStateChanged.disconnect(HeaderAppService.setAlert)

        /// set user interface language
        /// example expected /// example en#0#English
        let langCode = MachineData.language.split("#")[0]
        TranslatorText.selectLanguage(langCode);

        NetworkService.init()

        //NetworkService.connectedStatusChanged.connect(MachineAPI.setNetworkConnectedStatus)

        let intent

        if(MachineData.getSbcCurrentSerialNumberKnown()/* && false*/){
            intent = IntentApp.create("qrc:/UI/Pages/_HomePage/HomePage.qml", {})
            if (MachineData.shippingModeEnable){
                MachineAPI.setInstallationWizardActive(true)
                //intent = IntentApp.create("qrc:/UI/Pages/InstallationWizardPage/InstallationWizardPage.qml", {})
            }
        }else{
            intent = IntentApp.create("qrc:/UI/Pages/SoftwareFailedStartPage/SoftwareFailedStartPage.qml", {})
        }
        startRootView(intent)
    }

    //        Settings {
    //            id: settings

    //            property string machProfId: "NONE"
    //            Component.onCompleted: {
    //                //console.debug("machProfId:", machProfId)
    //            }
    //        }//

    background.sourceComponent: Item {}

    content.active: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

        Column {
            anchors.centerIn: parent
            spacing: 20

            Image{
                source: "qrc:/UI/Pictures/logo/esco_lifesciences_group_white.png"
            }//

            ProgressBar{
                id: startupProgressBar
                anchors.horizontalCenter: parent.horizontalCenter

                background: Rectangle {
                    implicitWidth: 512
                    implicitHeight: 10
                    radius: 5
                    clip: true
                }//

                contentItem: Item {
                    implicitWidth: 250
                    implicitHeight: 10

                    Rectangle {
                        width: startupProgressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 5
                        color: "#18AA00"
                    }//
                }//

                Behavior on value {
                    SequentialAnimation {
                        PropertyAnimation {
                            duration: 1000
                        }//
                        ScriptAction {
                            script: {
                                /// Progress
                                if(startupProgressBar.value === 1.0) {
                                    viewApp.progressBarHasFull()
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property var profileObjectActive: null
        }

        //        /// Execute This Every This Screen Active/Visible
        //        Loader {
        //            active: viewApp.stackViewStatusForeground
        //            sourceComponent: QtObject {

        //                /// onResume
        //                Component.onCompleted: {
        //                    //                    ////console.debug("StackView.Active");

        //                    //                    slider.value = MachineData.lightIntensity
        //                }//

        //                /// onPause
        //                Component.onDestruction: {
        //                    //////console.debug("StackView.DeActivating");
        //                }//
        //            }//
        //        }//

        CabinetProfilesApp {
            id: cabinetProfiles
        }//
        ReplaceablePartsDatabaseApp{
            id: rpDatabase
        }
        MaintenanceChecklistApp{
            id: prevMaint
            property var checklist:[]

            Component.onCompleted: {
                checklist = profiles[0]['checklist']
            }
        }

        /// Ensure super admin has created
        UserManageQmlApp {
            id: userManageQml

            property bool superAdminStatus: false
            onSuperAdminHasInitialized: {
                //                console.log(success)
                //                console.log(status)
                superAdminStatus = true
            }//

            onInitializedChanged: {
                initDefaultUserAccount()
            }//
        }//

        /// Event by Timer
        Timer {
            id: eventTimer
            interval: 1000
            //            running: true
            repeat: true
            onTriggered: {
                loopCycle = loopCycle + 1

                if(loopCycle == 1){
                    MachineData.initSingleton()
                    MachineAPI.initSingleton()
                    SettingsData.initSingleton()

                    MachineData.machineProfileID = String(SettingsData.valueToString("machProfId", "NONE"))
                    //console.debug("Machine profile ID", MachineData.machineProfileID)

                    startupProgressBar.value = 0.3
                }//

                if(loopCycle == 2){
                    //// Query current active machine profile
                    let profileIdActive = MachineData.machineProfileID
                    if(profileIdActive !== "NONE") {
                        for (const profileObj of cabinetProfiles.profiles) {
                            if (profileIdActive === profileObj['profilelId']){
                                //                                ////console.debug("Found")
                                props.profileObjectActive = profileObj;
                                break;
                            }//
                        }//
                    }//

                    if(props.profileObjectActive === null){
                        /// Go to cabinetProfiles selection

                        ///stop this eventTime then open next page
                        eventTimer.stop()

                        /// Decide next page decision
                        var intent = IntentApp.create("qrc:/UI/Pages/CabinetProfilePage/CabinetProfilePage.qml", {'startup':1})
                        startRootView(intent)
                    }
                    else {
                        //// Go to next phase machine startup task
                        MachineData.machineProfile = props.profileObjectActive
                        MachineData.machineClassName = props.profileObjectActive['classStr']
                        MachineData.machineModelName = props.profileObjectActive['modelStr']
                        MachineData.rpListDefault = rpDatabase.databaseDefaultLA2[0]
                        MachineData.maintenanceChecklist = prevMaint.checklist
                        MachineAPI.setup(MachineData)

                        const connectionId = "StartupPage"
                        userManageQml.init(connectionId);

                        startupProgressBar.value = 0.5
                    }//
                }//

                if (loopCycle >= 3) {
                    if (userManageQml.superAdminStatus){
                        if (MachineData.machineState == MachineAPI.MACHINE_STATE_LOOP) {

                            ///stop this eventTime then open next page
                            eventTimer.stop()
                            startupProgressBar.value = 1
                        }//
                    }
                }//
            }//
        }//

        //// Execute This Every This Screen Active/Visible/Foreground
        executeOnPageVisible: QtObject {
            /// onResume
            Component.onCompleted: {
                //                //console.debug("StackView.Active");

                viewApp.enabledSwipedFromLeftEdge   = false
                viewApp.enabledSwipedFromRightEdge  = false
                viewApp.enabledSwipedFromBottomEdge = false
                viewApp.enabledSwipedFromTopEdge    = false

                eventTimer.start()
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }

            /// PUT ANY DYNAMIC OBJECT MUST A WARE TO PAGE STATUS
            /// ANY OBJECT ON HERE WILL BE DESTROYED WHEN THIS PAGE NOT IN FOREGROUND
        }//

        //        /// Execute This Every This Screen Active/Visible
        //        Loader {
        //            active: viewApp.stackViewStatusForeground && parent.ready
        //            asynchronous: true
        //            sourceComponent: QtObject {

        //                /// onResume
        //                Component.onCompleted: {
        //                    //console.debug("StackView.Active");
        //                    viewApp.setEnableSwiped("left", false)
        //                    viewApp.setEnableSwiped("right", false)
        //                    viewApp.setEnableSwiped("bottom", false)

        //                    eventTimer.start()
        //                }//

        //                /// onPause
        //                Component.onDestruction: {
        //                    //////console.debug("StackView.DeActivating");
        //                }
        //            }//
        //        }//
    }//
}//

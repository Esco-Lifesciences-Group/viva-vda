import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.12
//import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.Settings 1.0

//import "Components" as CusComPage

ViewApp {
    id: viewApp
    title: "Cabinet Model"

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
                    title: qsTr("Cabinet Model")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                StackView {
                    id: contentStackView
                    anchors.fill: parent
                    initialItem: profileComponent
                }//

                Component {
                    id: profileComponent
                    Item{
                        id: profileItem
                        property var model: []
                        Column {
                            spacing: 20
                            anchors.centerIn: parent

                            Column{
                                spacing: 5

                                TextApp{
                                    text: qsTr("Current model") + ":"
                                }//

                                TextApp{
                                    id: currentValueText
                                    font.pixelSize: 36
                                    wrapMode: Text.WordWrap
                                    text: props.currentProfileName
                                    width: Math.min(controlMaxWidthText.width, profileItem.width)

                                    Text{
                                        id: controlMaxWidthText
                                        text: currentValueText.text
                                        font.pixelSize: 36
                                        wrapMode: Text.WordWrap
                                        visible: false
                                    }//
                                }//
                            }//

                            Column {
                                spacing: 10

                                Column {
                                    spacing: 5

                                    TextApp {
                                        text: qsTr("Change model to") + ":"
                                    }//

                                    Row {
                                        spacing: 5

                                        ComboBoxApp {
                                            id: profileComboBox
                                            model: cabinetProfiles.profiles
                                            width: 300
                                            height: 50
                                            font.pixelSize: 20
                                            popupHeight: 180
                                            textRole: "name"

                                            onActivated: {
                                                if (currentIndex) {
                                                    props.profileReq = cabinetProfiles.profiles[currentIndex]
                                                    setButton.enabled = true
                                                }
                                                else {
                                                    props.profileReq = null
                                                    setButton.enabled = false
                                                }
                                            }//
                                        }//

                                        Rectangle {
                                            visible: profileComboBox.currentIndex
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 50
                                            height: 50
                                            radius: 5
                                            color: "#404244"
                                            border.color: "#dddddd"

                                            TextApp{
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.bold: true
                                                text: "i"
                                                font.pixelSize: 30
                                            }//

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    contentStackView.push(profileDetailComponent, {'detail': props.profileReq})
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//

                            Column {
                                spacing: 10

                                Column {
                                    spacing: 5

                                    TextApp {
                                        text: qsTr("Fan speed controller") + ":"
                                    }//

                                    Row {
                                        spacing: 5

                                        ComboBoxApp {
                                            id: fanSpeedContComboBox
                                            model: props.fanSpeedCtrlModelData
                                            width: 300
                                            height: 50
                                            font.pixelSize: 20
                                            popupHeight: 180
                                            textRole: "text"

                                            onActivated: {
                                                props.fanSpeedController = Number(model[index].value)
                                                if (currentIndex !== MachineData.fanSpeedControllerBoard
                                                        && profileComboBox.currentIndex) {
                                                    setButton.enabled = true
                                                }
                                            }//
                                            Component.onCompleted: {
                                                currentIndex = MachineData.fanSpeedControllerBoard
                                            }
                                        }//
                                    }//
                                }//
                            }//
                        }//

                        TextApp {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:  "*" + qsTr("New configuration will be applied after system restart") + "."
                                   + "<br>"
                                   + qsTr("The system will restart after you tap the '%1' button.").arg(setButton.text) + "."
                            color: "#cccccc"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                        }//
                    }//
                }//

                Component {
                    id: profileDetailComponent

                    Item {
                        id: profileDetailItem

                        //                        property string detailStr: ""
                        property var detail: null

                        Loader {
                            id: detailLoader
                            anchors.centerIn: parent
                            asynchronous: true
                            sourceComponent: Row {

                                Image {
                                    source: "qrc:/UI/Pictures/back-step.png"

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            contentStackView.pop()
                                        }//
                                    }//
                                }//

                                Rectangle {
                                    //                                anchors.centerIn: parent
                                    height: profileDetailItem.height
                                    width: 500
                                    color: "#000000"
                                    border.color: "#dddddd"
                                    radius: 5

                                    ScrollView {
                                        id: scrollView
                                        anchors.fill: parent
                                        clip: true

                                        TextArea {
                                            id: ti
                                            readOnly: true
                                            padding: 5
                                            //                                text: profileDetailItem.detailStr
                                            text: "<pre>" + JSON.stringify(profileDetailItem.detail, null, "\r   ") + "</pre>"
                                            //                                selectByMouse : true
                                            font.pixelSize: 14
                                            textFormat: TextEdit.RichText
                                            wrapMode: TextInput.WrapAnywhere
                                            color: "#dddddd"
                                            background: Item{}
                                        }//
                                    }//
                                }//
                            }//

                            BusyIndicatorApp {
                                anchors.centerIn: parent
                                visible: detailLoader.status === Loader.Loading
                            }//
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
                            visible: stackViewDepth > 1

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                        Row{
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            spacing: 5
                            ButtonBarApp {
                                id: swupdateButton
                                visible: false
                                width: 194
                                imageSource: "qrc:/UI/Pictures/update.png"
                                text: qsTr("SWUpdate")

                                onClicked: {
                                    const message = qsTr("Are you sure you want to continue to update?")
                                    viewApp.showDialogAsk(qsTr("Notification"),
                                                          message,
                                                          viewApp.dialogInfo,
                                                          function onAccepted(){
                                                              ////console.debug("SBC Update Load...")
                                                              viewApp.showBusyPage(qsTr("Loading updates..."),
                                                                                   function onTriggered(cycle){
                                                                                       if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                                           let exitCodeOpenUpdater = 7
                                                                                           const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml",
                                                                                                                           {exitCode: exitCodeOpenUpdater})
                                                                                           startRootView(intent)
                                                                                       }
                                                                                   })
                                                          })//
                                }//
                            }//
                            ButtonBarApp {
                                id: setButton
                                width: 194
                                //anchors.verticalCenter: parent.verticalCenter
                                //anchors.right: parent.right
                                enabled: false

                                /// only visible from second fragment, set options
                                //                            visible: false

                                imageSource: "qrc:/UI/Pictures/checkicon.png"
                                text: qsTr("Apply")

                                onClicked: {
                                    /// pop out detail profile if it was opened
                                    if (contentStackView.depth > 1) contentStackView.pop()

                                    /// save to permanent storage
                                    const profileID =  String(props.profileReq['profilelId'])
                                    const cabinetName = String(props.profileReq['name'])
                                    SettingsData.setValue("machProfId", profileID)
                                    MachineData.machineProfileID = profileID
                                    MachineAPI.insertEventLog(qsTr("User: Set cabinet model (%1)").arg(cabinetName))

                                    if(Number(MachineData.fanSpeedControllerBoard) != Number(props.fanSpeedController)){
                                        SettingsData.setValue("fanSpdCntrlBrd", props.fanSpeedController)
                                        const str = qsTr("User: Set fan speed controller board (%1)").arg(props.fanSpeedCtrlModelData[props.fanSpeedController].text)
                                        console.debug(str)
                                        MachineAPI.insertEventLog(str)
                                    }//

                                    //console.debug("Set Profile ID", props.profileReq['profilelId'])
                                    viewApp.showBusyPage(qsTr("Setting up..."),
                                                         function onCycle(cycle){
                                                             if (cycle >= MachineAPI.BUSY_CYCLE_1
                                                                     || MachineData.machineProfileID === profileID) {
                                                                 props.currentProfileName = props.profileReq['name']

                                                                 const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {})
                                                                 startRootView(intent)
                                                             }//
                                                         })//
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        //        CusComPage.CabinetProfiles {
        //            id: cabinetProfiles
        //        }

        CabinetProfilesApp {
            id: cabinetProfiles
        }//

        //        Settings {
        //            id: settings

        //            property string machProfId: "NONE"
        //        }//

        //// Put all private property inside here
        //// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property var profileReq: null

            property string currentProfileName: qsTr("NONE")
            property int fanSpeedController: 0

            property var fanSpeedCtrlModelData: [
                {text: qsTr("RBM Board (DSI)"),     value: MachineAPI.FanSpeedController_RBM},
                {text: qsTr("Analog Output Board"), value: MachineAPI.FanSpeedController_Analog},
                {text: qsTr("PWM Output Board"),    value: MachineAPI.FanSpeedController_PWM},
                {text: qsTr("EON Serial Interface"),value: MachineAPI.FanSpeedController_EON}
            ]
        }

        /// called Once but after onResume
        Component.onCompleted: {
            if (stackViewDepth == 1){
                viewApp.fnSwipedFromLeftEdge    = function(){}
                viewApp.fnSwipedFromRightEdge   = function(){}
                viewApp.fnSwipedFromBottomEdge  = function(){}
            }//
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                //                    let currentProfile = MachineData.MachineProfileName
                //                    if(currentProfile.length === 0) currentProfile = qsTr("NONE")
                //                    props.currentProfile = currentProfile
                const extraData = IntentApp.getExtraData(intent)
                const thisOpenedFromStartupPage = extraData['startup'] || false
                if(thisOpenedFromStartupPage) {
                    swupdateButton.visible = true
                }

                let profileIdActive = MachineData.machineProfileID/*"73ba4552-4da5-11eb-ae93-0242ac130002"*/
                if(profileIdActive !== "NONE") {
                    let profileObjectActive = null;
                    for (const profileObj of cabinetProfiles.profiles) {
                        if (profileIdActive === profileObj['profilelId']){
                            //                                ////console.debug("Found")
                            profileObjectActive = profileObj;
                            break;
                        }
                    }

                    if(profileObjectActive !== null){
                        props.currentProfileName = profileObjectActive['name']
                    }
                }
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:600;width:1024}
}
##^##*/

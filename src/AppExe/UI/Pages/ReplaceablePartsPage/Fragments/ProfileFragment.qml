import QtQuick 2.14
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1

import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

import Qt.labs.settings 1.0

//import "../Components" as CusComPage

Item {
    id: control
    property bool viewOnly: false

    Rectangle{
        anchors.fill: parent
        color: "#40000000"
        z: -1
    }//

    //    RowLayout {
    //        anchors.fill: parent

    //    }//

    Column{
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -20
        Row{
            spacing: 10
            Column{
                spacing: 5
                TextApp{
                    id: unitModelText
                    text: qsTr("Unit Model")
                }
                TextFieldApp{
                    id: unitModelTextField
                    enabled: !control.viewOnly
                    width: 250
                    height: 50
                    opacity: unitModelTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: unitModelTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(unitModelTextField,  unitModelText.text)
                        }//
                    }//

                    onAccepted: {
                        if(props.isUnitModelValid(text)){
                            MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UnitModel, text)
                            props.allowReBinding = true
                        }else{
                            viewApp.showDialogMessage(unitModelText.text,
                                                      qsTr("Invalid input!"),
                                                      viewApp.dialogAlert)
                            text = props.getRpList(MachineAPI.RPList_UnitModel)
                        }
                    }//
                    Component.onCompleted: {
                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UnitModel)})
                    }//
                }//
            }//

            Column{
                spacing: 5
                TextApp{
                    id: unitModelSNText
                    text: qsTr("Serial Number")
                }
                TextFieldApp{
                    id: unitModelSNTextField
                    enabled: false
                    width: 250
                    height: 50
                    opacity: unitModelSNTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: unitModelSNTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(unitModelSNTextField,  unitModelSNText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UnitSerialNumber, text)
                        props.allowReBinding = true
                    }//
                    Component.onCompleted: {
                        text = Qt.binding(function(){return MachineData.serialNumber})
                        if(props.getRpList(MachineAPI.RPList_UnitSerialNumber) !== MachineData.serialNumber)
                            MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UnitSerialNumber, MachineData.serialNumber)
                    }//
                }//
            }//

            Column{
                spacing: 5
                TextApp{
                    id: dateText
                    text: qsTr("Date")
                }
                TextFieldApp{
                    id: dateTextField
                    enabled: false
                    width: 250
                    height: 50

                    opacity: dateTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: dateTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(dateTextField,  dateText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_DateTime, text)
                        props.allowReBinding = true
                    }//

                    Component.onCompleted: {
                        let date = new Date()
                        let dateText = Qt.formatDateTime(date, "yyyy-MM-dd")
                        //let TimeText = Qt.formatDateTime(date, "hh:mm")
                        text = dateText

                        //if(props.getRpList(MachineAPI.RPList_Date) !== dateText)
                        //    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_Date, dateText)
                        //if(props.getRpList(MachineAPI.RPList_Time) !== TimeText)
                        //    MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_Time, TimeText)
                    }//
                }//
            }//
        }//

        //        Row{
        //            spacing: 10
        //            Column{
        //                spacing: 5
        //                TextApp{
        //                    id: userManualCodeText
        //                    text: qsTr("User Manual Code")
        //                }
        //                TextFieldApp{
        //                    id: userManualCodeTextField
        //                    enabled: !control.viewOnly
        //                    width: 250
        //                    height: 50

        //                    opacity: userManualCodeTextFieldMArea.pressed ? 0.5 : 1
        //                    MouseArea{
        //                        id: userManualCodeTextFieldMArea
        //                        anchors.fill: parent
        //                        onClicked: {
        //                            KeyboardOnScreenCaller.openKeyboard(userManualCodeTextField,  userManualCodeText.text)
        //                        }//
        //                    }//

        //                    onAccepted: {
        //                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UserManualCode, text)
        //                        props.allowReBinding = true
        //                    }//
        //                    Component.onCompleted: {
        //                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UserManualCode)})
        //                    }//
        //                }//
        //            }//

        //            Column{
        //                spacing: 5
        //                TextApp{
        //                    id: userManualCodeVerText
        //                    text: qsTr("Version")
        //                }
        //                TextFieldApp{
        //                    id: userManualCodeVerTextField
        //                    enabled: !control.viewOnly
        //                    width: 250
        //                    height: 50

        //                    opacity: userManualCodeVerTextFieldMArea.pressed ? 0.5 : 1
        //                    MouseArea{
        //                        id: userManualCodeVerTextFieldMArea
        //                        anchors.fill: parent
        //                        onClicked: {
        //                            KeyboardOnScreenCaller.openKeyboard(userManualCodeVerTextField,  userManualCodeVerText.text)
        //                        }//
        //                    }//

        //                    onAccepted: {
        //                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_UserManualVersion, text)
        //                        props.allowReBinding = true
        //                    }//
        //                    Component.onCompleted: {
        //                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UserManualVersion)})
        //                    }//
        //                }//
        //            }//

        //            Column{
        //                spacing: 5
        //                TextApp{
        //                    id: electTesterText
        //                    text: qsTr("Provided by")
        //                }
        //                TextFieldApp{
        //                    id: electTesterTextField
        //                    enabled: !control.viewOnly
        //                    width: 250
        //                    height: 50

        //                    opacity: electTesterTextFieldMArea.pressed ? 0.5 : 1
        //                    MouseArea{
        //                        id: electTesterTextFieldMArea
        //                        anchors.fill: parent
        //                        onClicked: {
        //                            KeyboardOnScreenCaller.openKeyboard(electTesterTextField,  electTesterText.text)
        //                        }//
        //                    }//

        //                    onAccepted: {
        //                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalTester, text)
        //                        props.allowReBinding = true
        //                    }//

        //                    Component.onCompleted: {
        //                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalTester)})
        //                    }//
        //                }//
        //            }//
        //        }//

        Row{
            spacing: 10
            Column{
                spacing: 5
                TextApp{
                    id: electPanelText
                    text: qsTr("Electrical Panel")
                }
                TextFieldApp{
                    id: electPanelTextField
                    enabled: !control.viewOnly
                    width: 250
                    height: 50
                    opacity: electPanelTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: electPanelTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(electPanelTextField,  electPanelText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalPanel, text)
                        props.allowReBinding = true
                    }//
                    Component.onCompleted: {
                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalPanel)})
                    }//
                }//
            }//

            Column{
                spacing: 5
                TextApp{
                    id: electPanelSNText
                    text: qsTr("Serial Number")
                }
                TextFieldApp{
                    id: electPanelSNTextField
                    enabled: !control.viewOnly
                    width: 250
                    height: 50

                    opacity: electPanelSNTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: electPanelSNTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(electPanelSNTextField,  electPanelSNText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalPanelSerialNumber, text)
                        props.allowReBinding = true
                    }//
                    Component.onCompleted: {
                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalPanelSerialNumber)})
                    }//
                }//
            }//
        }//
        Row{
            spacing: 10
            Column{
                spacing: 5
                TextApp{
                    id: electTesterText
                    text: qsTr("Provided by")
                }
                TextFieldApp{
                    id: electTesterTextField
                    enabled: !control.viewOnly
                    width: 250
                    height: 50

                    opacity: electTesterTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: electTesterTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(electTesterTextField,  electTesterText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_ElectricalTester, text)
                        props.allowReBinding = true
                    }//

                    Component.onCompleted: {
                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalTester)})
                    }//
                }//
            }//
            Column{
                spacing: 5
                TextApp{
                    id: checkbyText
                    text: qsTr("Checked by")
                }
                TextFieldApp{
                    id: checkbyTextField
                    enabled: !control.viewOnly
                    width: 250
                    height: 50

                    opacity: checkbyTextFieldMArea.pressed ? 0.5 : 1
                    MouseArea{
                        id: checkbyTextFieldMArea
                        anchors.fill: parent
                        onClicked: {
                            KeyboardOnScreenCaller.openKeyboard(checkbyTextField,  checkbyText.text)
                        }//
                    }//

                    onAccepted: {
                        MachineAPI.setReplaceablePartsSettings(MachineAPI.RPList_CheckedBy, text)
                        props.allowReBinding = true
                    }//

                    Component.onCompleted: {
                        text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_CheckedBy)})
                    }//
                }//
            }//
        }
    }//

    CheckBoxApp{
        visible: !control.viewOnly
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        text: qsTr("Advanced database")
        checked: MachineData.rpExtDatabaseEnable

        property bool init: false

        onCheckedChanged: {
            if(!init) return
            if(checked){
                if(!MachineData.svnUpdateCheckForUpdateEnable
                        && UserSessionService.roleLevel == UserSessionService.roleLevelFactory){
                    viewApp.showDialogMessage(qsTr("Warning"),
                                              qsTr("Please enable the SVN Update Settings.") + "<br>" +
                                              qsTr("Go to <b>Service - Software Update - SVN Update Settings</b>.").arg("-"),
                                              viewApp.dialogAlert)
                    checked = false
                }else{
                    props.refreshAdvRpDatabase()
                }
            }
            MachineAPI.setRpExternalDatabaseEnable(checked)

            MachineAPI.insertEventLog(qsTr("User: Set RP database enable") + ": " + (checked ? "1" : "0"))
        }
        Component.onCompleted: init = true
    }

    Rectangle{
        visible: !control.viewOnly
        color: "transparent"
        width: 150
        height: 120
        border.width: 1
        border.color: "#effffd"
        radius: 5
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        ColumnLayout{
            anchors.fill: parent
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                TextApp{
                    width: parent.width
                    height: parent.height
                    text: qsTr("Reset to default")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    padding: 5
                }
            }
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                opacity: resetMA.pressed ? 0.5 : 1
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 5
                    color: "#0F2952"
                    border.width: 1
                    border.color: "#e3dac9"
                    radius: 5
                }
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/UI/Pictures/refresh.png"
                }
                MouseArea{
                    id: resetMA
                    anchors.fill: parent
                    onClicked: {
                        /// Check for the Unit Model Name
                        /// LA2-5S9 G4 10"
                        /// check only LA2-5S9
                        let unitModelValid = props.isUnitModelValid(unitModelTextField.text)

                        if(!unitModelValid){
                            viewApp.showDialogMessage(qsTr("Warning"),
                                                      qsTr("Unit Model format is invalid!"),
                                                      viewApp.dialogAlert)
                        }
                    }
                }
            }
        }
    }//

    // Settings{
    //     id: settings
    //     category: "rplist"
    //     property string formRpRevision: "FM-ELQ-35-A"
    //     property string formRpPath: "Path:\\\\192.168.0.44\\Esco Operating System\\FM-SD-SOP-WI\\Electrical QC\\FM"
    // }//

    QtObject{
        id: props

        property bool allowReBinding: false

        function refreshAdvRpDatabase(){
            MachineAPI.refreshRpExternalDatabase()
            MachineAPI.refreshRpExternalDefault()
            viewApp.showBusyPage(qsTr("Please wait..."),
                                 function(cycle){
                                     if(cycle >= 5){
                                         viewApp.closeDialog();
                                     }
                                 })
        }
        function isUnitModelValid(name){
            let unitModelName = name
            if(String(unitModelName).split(" ").length >= 2){
                let modelSize = String(unitModelName).split(" ")[0]
                if(String(modelSize).split("-").length === 2){
                    let size = String(modelSize).split("-")[1]
                    if(String(size).length === 3){
                        let ft = size.charAt(0)
                        let material = size.charAt(1)
                        let pwr = size.charAt(2)
                        console.debug(ft, material, pwr)
                        if(Number(ft) >= 2 && Number(ft) < 10
                                && ((Number(pwr) === 7) || (Number(pwr) === 8) || (Number(pwr) === 9)))
                            return true
                    }
                }
            }
            return false
        }//

        function refreshAdvRpDatabaseDone(){
            console.debug("refresh adv rp database done")
            //viewApp.closeDialog();
        }//

        function getRpList(index){
            let data = control.viewOnly ? MachineData.rpListSelected : MachineData.rpListLast
            //data.push(value)
            if(data.length <= index){
                //console.debug("RpList on index", index, "unavailaible!")
                return
            }
            return data[index]
        }//

        function resetDefaultRpList(){
            const message = qsTr("The form contents will be reset to default!") + "<br>"
                          + qsTr("Are you sure want to reset?")
            showDialogAsk(qsTr("RP Record - Add"),
                          message,
                          dialogAlert,
                          function onAccepted(){
                              MachineAPI.insertEventLog(qsTr("User: Reset RP form to default."))
                              MachineAPI.resetReplaceablePartsSettings()
                              showBusyPage(qsTr("Please wait..."),
                                           function(cycle){
                                               if(cycle === MachineAPI.BUSY_CYCLE_1){
                                                   closeDialog()
                                               }//
                                           })//
                          })//
        }//

        function refreshBinding(){
            if(!allowReBinding) return
            unitModelTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UnitModel)})
            unitModelSNTextField.text = Qt.binding(function(){return MachineData.serialNumber})
            let date = new Date()
            dateTextField.text = Qt.formatDateTime(date, "yyyy-MM-dd")
            //userManualCodeTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UserManualCode)})
            //userManualCodeVerTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_UserManualVersion)})
            electTesterTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalTester)})
            electPanelTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalPanel)})
            electPanelSNTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_ElectricalPanelSerialNumber)})
            checkbyTextField.text = Qt.binding(function(){return props.getRpList(MachineAPI.RPList_CheckedBy)})
            allowReBinding = false
        }

        Component.onCompleted: {
            MachineData.rpListLastChanged.connect(props.refreshBinding)
            MachineData.rpExtDatabaseChanged.connect(props.refreshAdvRpDatabaseDone)

            if(MachineData.rpExtDatabaseEnable){
                MachineAPI.refreshRpExternalDatabase()
                MachineAPI.refreshRpExternalDefault()
            }
        }
        Component.onDestruction: {
            MachineData.rpListLastChanged.disconnect(props.refreshBinding)
            MachineData.rpExtDatabaseChanged.disconnect(props.refreshAdvRpDatabaseDone)
        }
    }//
    //    Settings {
    //        id: settings
    //        category: "rplist"


    //        Component.onCompleted: {

    //        }//
    //    }//

    //    UtilsApp{
    //        id: utils
    //    }

}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

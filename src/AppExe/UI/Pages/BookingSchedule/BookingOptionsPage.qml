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

import BookingScheduleQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Booking Options"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// please comment for production
        //        visible: true

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
                    title: qsTr("Booking Options")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Flow {
                    anchors.centerIn: parent
                    width: 555
                    spacing: 5

                    Rectangle {
                        height: 130
                        width: 100
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.minimumHeight: 60
                                Layout.fillWidth: true
                                padding: 5
                                text: qsTr("Enable Notification")
                                wrapMode: Text.WordWrap
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                SwitchApp {
                                    id: enableSwitchApp
                                    enabled: UserSessionService.roleLevel > UserSessionService.roleLevelOperator
                                    anchors.centerIn: parent

                                    onCheckedChanged: {
                                        ////console.debug(checked)

                                        if(!initialized) return

                                        MachineAPI.setBookedScheduleNotifEnable(checked)

                                        MachineAPI.insertEventLog(qsTr("User: Set booked schedule notif. enable to %1").arg(checked))
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 130
                        width: 200
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Notify before")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                ComboBoxApp {
                                    id: periodComboBoxApp
                                    enabled: UserSessionService.roleLevel > UserSessionService.roleLevelOperator
                                    width: parent.width
                                    height: 50
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: 20

                                    textRole: "text"

                                    model: [
                                        {text: qsTr('30 minute'),   value: 30},
                                        {text: qsTr('1 hour'),      value: (1*60)},
                                        {text: qsTr('2 hours'),     value: (2*60)},
                                        {text: qsTr('4 hours'),     value: (4*60)},
                                    ]

                                    onActivated: {
                                        MachineAPI.setBookedScheduleNotifTime(model[index].value)

                                        MachineAPI.insertEventLog(qsTr("User: Set booked schedule notif. time to %1").arg(model[index].text))
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 130
                        width: 240
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Export") + " (" + qsTr("Week") + ": " + props.exportTargetWeek + ")"
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        visible: ((__hwInfo__ !== MachineAPI.HardwareInfo_RPI_ZW) ? true : false)
                                        Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/UI/Pictures/pdf-export-bt.png"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                        && UserSessionService.roleLevel != UserSessionService.roleLevelService)
                                                {
                                                    props.exportToWhat = props.exportToPdfBluetooth
                                                    bookingScheduleQmlApp.exportAsDocument()
                                                }else{
                                                    showDialogMessage(qsTr("Access Denied"),
                                                                      qsTr("You do not have permission to perform this action!"),
                                                                      dialogAlert)
                                                }
                                            }//
                                        }//
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/UI/Pictures/pdf-export-usb.png"
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                        && UserSessionService.roleLevel != UserSessionService.roleLevelService){
                                                    props.exportToWhat = props.exportToPdfUSB

                                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("USB port can be found on top of the cabinet, nearby power inlet.")
                                                    const autoclosed = false
                                                    showDialogAsk(qsTr("Booking Options"), message, dialogAlert,
                                                                  function onAccepted(){
                                                                      bookingScheduleQmlApp.exportAsDocument()
                                                                      MachineAPI.insertEventLog(qsTr("User: Generate booking schedule (export file) %1").arg("(" + qsTr("Week") + ": " + props.exportTargetWeek + ")"))
                                                                  },
                                                                  function(){}, function(){}, autoclosed)
                                                }else{
                                                    showDialogMessage(qsTr("Access Denied"),
                                                                      qsTr("You do not have permission to perform this action!"),
                                                                      dialogAlert)
                                                }//
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 100
                        width: 305
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"
                        //                        visible: false

                        ColumnLayout {
                            anchors.fill: parent

                            TextApp {
                                Layout.margins: 5
                                text: qsTr("Delete logs starting from")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        ComboBoxApp {
                                            enabled: (UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                      && UserSessionService.roleLevel != UserSessionService.roleLevelService)
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            font.pixelSize: 20

                                            textRole: "text"

                                            model: [
                                                {text: qsTr('Today (Clear All)'),value: 0},
                                                {text: qsTr('Yesterday'),        value: 1},
                                                {text: qsTr('1 week ago'),       value: 7},
                                                {text: qsTr('1 month ago'),      value: 30},
                                                {text: qsTr('1 year ago'),       value: 365},
                                            ]

                                            onActivated: {
                                                props.deleteWhereOlderThanDays = model[index].value
                                                props.deleteWhereOlderThanDaysStrf = model[index].text
                                                notifAnima.start()
                                            }//
                                        }//
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: parent.height

                                        Rectangle {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            color: "transparent"
                                            border.color: "#e3dac9"
                                            radius: 5

                                            Image {
                                                id: deleteImage
                                                source: "qrc:/UI/Pictures/trash-icon-35px.png"
                                                anchors.fill: parent
                                                fillMode: Image.PreserveAspectFit

                                                SequentialAnimation {
                                                    id: notifAnima

                                                    NumberAnimation {
                                                        target: deleteImage
                                                        property: "scale"
                                                        from: 1
                                                        to: 0.7
                                                        duration: 200
                                                        easing.type: Easing.InOutQuad
                                                        onStopped: deleteImage.scale = 1
                                                    }//

                                                    ScriptAction {
                                                        script: deleteImage.scale = 1
                                                    }//
                                                }//
                                            }//
                                        }//

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                        && UserSessionService.roleLevel != UserSessionService.roleLevelService){
                                                    const message = "<b>" + qsTr("Delete the log?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("This process is irreversible.") + "<br>" + qsTr("Delete permanently?")

                                                    showDialogAsk(qsTr(title),
                                                                  message,
                                                                  dialogAlert,
                                                                  function onAccepted(){
                                                                      ////console.debug("yes Delete")
                                                                      bookingScheduleQmlApp.deleteData()

                                                                      MachineAPI.insertEventLog(qsTr("User: Delete booking schedule logs starting from %1").arg(props.deleteWhereOlderThanDaysStrf))
                                                                  });
                                                }else{
                                                    showDialogMessage(qsTr("Access Denied"),
                                                                      qsTr("You do not have permission to perform this action!"),
                                                                      dialogAlert)
                                                }
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Rectangle {
                        height: 40
                        width: 305
                        radius: 5
                        color: "#0F2952"
                        border.color: "#e3dac9"

                        TextApp {
                            anchors.fill: parent
                            anchors.margins: 5
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Storage") + ": " + bookingScheduleQmlApp.totalRows + "/" + bookingScheduleQmlApp.getMaximumRows()
                        }//
                    }//
                }//

                TextApp{
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "*" + qsTr("The week numbering is based on ISO 8601.")
                    color: "#cccccc"
                    font.pixelSize: 16
                }

                TextApp{
                    visible: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                    text: qsTr("Backup/Restore")
                    font.underline: true
                    color: aboutSwMA.pressed ? "#06C3FF" : "#4F81D1"
                    font.pixelSize: 16
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    MouseArea{
                        id: aboutSwMA
                        anchors.fill: parent
                        onClicked: {
                            const intent = IntentApp.create("qrc:/UI/Pages/BackupRestorePage/BackupRestorePage.qml", {"db": "bookingschedule.db"})
                            startView(intent)
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

        /// Database connection
        BookingScheduleQmlApp {
            id: bookingScheduleQmlApp
            onInitializedChanged: {
                //                //console.debug("BookingScheduleQmlApp: " + initialized)
                viewApp.closeDialog()
            }//

            Component.onCompleted: {
                viewApp.showBusyPage(qsTr("Please wait..."))
                const uniqConnectionName = "UiBookingForOptions"
                init(uniqConnectionName);
            }//

            function exportAsDocument(){
                const message = qsTr("Generating") + "..."
                viewApp.showBusyPage(message)

                const _targetDate   = props.exportTargetDate;
                const _cabinetModel = MachineData.machineModelName;
                const _serialNumber = MachineData.serialNumber;
                const _exportedDate = Qt.formatDateTime(new Date, "dd-MMM-yyyy hh:mm:ss")

                exportData(_targetDate, _exportedDate, _serialNumber, _cabinetModel)
            }//

            onDataHasExported: {
                viewApp.showDialogMessage(qsTr(title),
                                          qsTr("The document has been generated"),
                                          dialogInfo,
                                          function onClosed(){
                                              let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                              if(props.exportToWhat == props.exportToPdfBluetooth){
                                                  urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                              }

                                              const intent = IntentApp.create(urlContext, {"sourceFilePath": desc})
                                              startView(intent);
                                          })
            }//

            function deleteData() {
                const message = qsTr("Deleting") + "..."
                viewApp.showBusyPage(message)

                deleteWhereOlderThanDays(props.deleteWhereOlderThanDays)
            }//

            onDeleteHasDone: {
                viewApp.showDialogMessage(qsTr(title), qsTr("The log has been deleted!"),
                                          dialogInfo,
                                          function onClosed(){
                                              MachineAPI.refreshTodayBookingSchedule()
                                          })
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int deleteWhereOlderThanDays: 0
            property string deleteWhereOlderThanDaysStrf: ""

            property string exportTargetDate: ""
            property int    exportTargetWeek: 0

            readonly property int exportToPdfUSB: 0
            readonly property int exportToPdfBluetooth: 1
            property int exportToWhat: 0
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                const extraData = IntentApp.getExtraData(intent)
                props.exportTargetDate = extraData['exportTargetDate'] || ""
                if(props.exportTargetDate.length) {
                    const theDate = new Date(props.exportTargetDate)
                    const onejan = new Date(theDate.getFullYear(), 0, 1);
                    const week = Math.ceil( (((theDate.getTime() - onejan.getTime()) / 86400000) + onejan.getDay() + 1) / 7 );

                    //                    console.log("week:" + week)
                    props.exportTargetWeek = week
                }

                const notifTime = MachineData.bookingScheduleNotifTime
                let periodIndex = 0
                switch (notifTime){
                case (1*60):
                    periodIndex = 1
                    break;
                case (2*60):
                    periodIndex = 2
                    break;
                case (4*60):
                    periodIndex = 3
                    break;
                }
                periodComboBoxApp.currentIndex = periodIndex

                enableSwitchApp.checked = MachineData.bookingScheduleNotifEnable
                enableSwitchApp.initialized = true
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
    D{i:0;autoSize:true;formeditorColor:"#808080";formeditorZoom:1.75;height:480;width:800}
}
##^##*/

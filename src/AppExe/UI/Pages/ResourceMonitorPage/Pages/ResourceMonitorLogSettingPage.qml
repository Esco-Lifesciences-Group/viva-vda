/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

import ResourceMonitorLogQmlApp 1.0

ViewApp {
    id: viewApp
    title: "System Monitor Log Options"

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
                    title: qsTr("System Monitor Log Options")
                }//
            }//

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true

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
                                Layout.margins: 5
                                text: qsTr("Enable")
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

                                        MachineAPI.setResourceMonitorLogEnable(checked)
                                        MachineAPI.setResourceMonitorLogRunning(checked)

                                        MachineAPI.insertEventLog(qsTr("User: Set system monitor log enable to %1").arg(checked))
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
                                text: qsTr("Record every")
                            }//

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                ComboBoxApp {
                                    id: periodComboBoxApp
                                    enabled: UserSessionService.roleLevel > UserSessionService.roleLevelOperator
                                    width: parent.width
                                    height: parent.height*0.6
                                    anchors.centerIn: parent
                                    font.pixelSize: 20

                                    textRole: "text"

                                    model: [
                                        {text: qsTr('1 minute'),    value: 1},
                                        {text: qsTr('5 minutes'),   value: 5},
                                        {text: qsTr('10 minutes'),  value: 10},
                                        {text: qsTr('1 hour'),      value: 60},
                                    ]

                                    onActivated: {
                                        MachineAPI.setResourceMonitorLogPeriod(model[index].value)
                                        MachineAPI.insertEventLog(qsTr("User: Set system monitor log period to %1").arg(model[index].text))
                                    }//
                                }//
                            }//

                            //                            Item {
                            //                                Layout.minimumHeight: 30
                            //                                Layout.fillWidth: true
                            //                                TextApp {
                            //                                    width: parent.width
                            //                                    height: parent.height
                            //                                    Layout.margins: 2
                            //                                    font.pixelSize: 14
                            //                                    minimumPixelSize: 10
                            //                                    text: "*" + qsTr("Only if the Fan State is ON")
                            //                                    wrapMode: Text.WordWrap
                            //                                }//
                            //                            }//
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
                                Layout.fillWidth: true
                                text: qsTr("Export")
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
                                                        /*&& UserSessionService.roleLevel != UserSessionService.roleLevelService*/)
                                                {
                                                    props.exportToWhat = props.exportToPdfBluetooth
                                                    KeyboardOnScreenCaller.openNumpad(exportNumberPageTextEdit, qsTr("Page to Export (ex. 1 or 1-10, max. 10 pages per export)"))

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
                                                        /*&& UserSessionService.roleLevel != UserSessionService.roleLevelService*/)
                                                {
                                                    props.exportToWhat = props.exportToPdfUSB

                                                    const message = "<b>" + qsTr("Have you inserted USB drive?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("USB port can be found on top of the cabinet, nearby power inlet.")
                                                    const autoclosed = false
                                                    showDialogAsk(qsTr("System Monitor Log Options"), message, dialogAlert,
                                                                  function onAccepted(){
                                                                      KeyboardOnScreenCaller.openNumpad(exportNumberPageTextEdit, qsTr("Page to Export (ex. 1 or 1-10, max. 10 pages per export)"))
                                                                  },
                                                                  function(){}, function(){}, autoclosed)
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
                                                      /*&& UserSessionService.roleLevel != UserSessionService.roleLevelService*/)
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            font.pixelSize: 20

                                            textRole: "text"

                                            model: [
                                                {text: qsTr('Today (Clear All)'),   value: 0},
                                                {text: qsTr('Yesterday'),           value: 1},
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

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                                        /*&& UserSessionService.roleLevel != UserSessionService.roleLevelService*/){
                                                    const message = "<b>" + qsTr("Delete the log?") + "</b>"
                                                                  + "<br><br>"
                                                                  + qsTr("This process is irreversible.") + "<br>" + qsTr("Delete permanently?")

                                                    showDialogAsk(qsTr(title),
                                                                  message,
                                                                  dialogAlert,
                                                                  function onAccepted(){
                                                                      ////console.debug("yes Delete")
                                                                      dbConnectForDelete.active = true
                                                                      MachineAPI.insertEventLog(qsTr("User: Delete system monitor logs starting from %1").arg(props.deleteWhereOlderThanDaysStrf))
                                                                  });
                                                }else
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
                            text: qsTr("Storage") + ": " + props.countRows + "/" + props.countRowsMax
                        }//
                    }//
                }//

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
                            const intent = IntentApp.create("qrc:/UI/Pages/BackupRestorePage/BackupRestorePage.qml", {"db": "systemmonitorlog.db"})
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
                                var intent = IntentApp.create(uri, {"prevPage":"opt"})
                                finishView(intent)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        /// Database connection for delete the log
        Loader {
            id: dbConnectForDelete
            active: false
            sourceComponent: ResourceMonitorLogQmlApp {
                id: logApp

                onInitializedChanged: {
                    //                ////console.debug("ResourceMonitorLogQmlApp: " + initialized)
                    const message = qsTr("Deleting") + "..."
                    showBusyPage(message)

                    deleteWhereOlderThanDays(props.deleteWhereOlderThanDays)
                }

                onDeleteHasDone: {
                    //                    ////console.debug(success)
                    //                    ////console.debug(totalAfterDelete)

                    MachineAPI.refreshLogRowsCount("systemmonitorlog")

                    showDialogMessage(qsTr(title), qsTr("The log has been deleted!"), dialogInfo,
                                      function onClosed(){
                                          //                                          showBusyPage(qsTr("Please wait..."), function onCallback(cycle){
                                          //                                              if(cycle >= MachineAPI.BUSY_CYCLE_1) {
                                          //                                                  closeDialog()
                                          //                                              }
                                          //                                          })
                                      })
                }

                Component.onCompleted: {
                    const uniqConnectionName = "resourceMonitorLogUIforDelete"
                    init(uniqConnectionName);
                }//
            }//
        }//

        ///TextBuffer
        TextField {
            id: exportNumberPageTextEdit
            visible: false

            onAccepted: {
                const rangePagePattern = /^\d{1,}-\d{1,}$/
                const singlePagePattern = /^\d{1,}$/

                let newInput = text
                let msg = qsTr("Invalid input!")
                let msg1 = qsTr("The maximum page number is %1.").arg(props.currentTotalPage)
                let msg2 = qsTr("The maximum number of pages is 10.")

                if (newInput.match(rangePagePattern)) {
                    //                    console.log(rangePagePattern)
                    const rangeNumber = newInput.split("-")
                    const startNumber = Number(rangeNumber[0]) || 0
                    const endNumber   = Number(rangeNumber[1]) || 0
                    //                    console.log("startNumber: " + startNumber)
                    //                    console.log("endNumber: " + endNumber)
                    if (startNumber < 1){
                        showDialogMessage(qsTr(title), msg, dialogAlert)
                        return
                    }
                    if ((startNumber > endNumber) || (endNumber > props.currentTotalPage)) {
                        if(endNumber > props.currentTotalPage)
                            msg += "<br>" + msg1
                        showDialogMessage(qsTr(title), msg, dialogAlert)
                        return
                    }
                    if ((endNumber - startNumber + 1) > 10) {
                        msg += "<br>" + msg2
                        showDialogMessage(qsTr(title), msg, dialogAlert)
                        return
                    }

                    props.startPageNumberExport = startNumber
                    props.endPageNumberExport = endNumber

                    dbConnectForExport.active = true
                }
                else if(newInput.match(singlePagePattern)) {
                    //console.log(singlePagePattern)

                    const pageNumber = Number(newInput)
                    if (pageNumber < 1){
                        showDialogMessage(qsTr(title), msg, dialogAlert)
                        return
                    }
                    if (pageNumber > props.currentTotalPage){
                        msg += "<br>" + msg1
                        showDialogMessage(qsTr(title), msg, dialogAlert)
                        return
                    }

                    props.startPageNumberExport = pageNumber
                    props.endPageNumberExport = pageNumber

                    dbConnectForExport.active = true
                }
                else {
                    text = "1"
                }//
            }//
        }//

        /// Database connection for export the log
        Loader {
            id: dbConnectForExport
            active: false
            sourceComponent: ResourceMonitorLogQmlApp {
                pagesItemPerPage: 50
                onInitializedChanged: {
                    ////console.debug("ResourceMonitorLogQmlApp: " + initialized)
                    const message = qsTr("Generating") + "..."
                    showBusyPage(message)

                    const _startPageNumber  = props.startPageNumberExport;
                    const _endPageNumber    = props.endPageNumberExport;
                    const _cabinetModel     = MachineData.machineModelName;
                    const _serialNumber     = MachineData.serialNumber;
                    const _exportedDate     = Qt.formatDateTime(new Date, "dd-MMM-yyyy hh:mm:ss")

                    exportLogs(_startPageNumber, _exportedDate, _serialNumber, _cabinetModel, _endPageNumber)
                }//

                onLogHasExported: {
                    //                    console.log("onLogHasExported: " + done)
                    //                    console.log("onLogHasExported:" + desc)

                    showDialogMessage(qsTr(title),
                                      qsTr("The document has been generated"),
                                      dialogInfo,
                                      function onClosed(){
                                          let urlContext = "qrc:/UI/Pages/FileManagerUsbCopyPage/FileManagerUsbCopierPage.qml";
                                          if(props.exportToWhat == props.exportToPdfBluetooth){
                                              urlContext = "qrc:/UI/Pages/BluetoothFileTransfer/BluetoothFileTransfer.qml"
                                          }
                                          const intent = IntentApp.create(urlContext,
                                                                          {
                                                                              "sourceFilePath": desc
                                                                          })
                                          startView(intent);
                                          dbConnectForExport.active = false
                                      })

                    const strEvent = qsTr("User: Generate system monitor logs (export file) %1.").arg(qsTr("(Page: %1-%2)").arg(props.startPageNumberExport).arg(props.endPageNumberExport))
                    MachineAPI.insertEventLog(strEvent)
                }//

                Component.onCompleted: {
                    showBusyPage(qsTr("Please wait..."))
                    const uniqConnectionName = "resourceMonitorLogUIforExport"
                    init(uniqConnectionName);
                }//
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int deleteWhereOlderThanDays: 0
            property string deleteWhereOlderThanDaysStrf: ""

            property int currentNumberPage: 0
            property int currentTotalPage:  0

            property int startPageNumberExport: 1
            property int endPageNumberExport:   1

            readonly property int exportToPdfUSB: 0
            readonly property int exportToPdfBluetooth: 1
            property int exportToWhat: 0

            property int countRows: 0
            property int countRowsMax: 0
        }//

        /// called Once but after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.countRows = Qt.binding(function(){return MachineData.resourceMonitorLogCount})
                props.countRowsMax = MachineData.resourceMonitorLogSpaceMaximum

                enableSwitchApp.checked = MachineData.resourceMonitorLogEnable
                enableSwitchApp.initialized = true

                const period = MachineData.resourceMonitorLogPeriod
                let periodIndex = 0
                switch (period){
                case 5:
                    periodIndex = 1
                    break;
                case 10:
                    periodIndex = 2
                    break;
                case 60:
                    periodIndex = 3
                    break;
                }
                periodComboBoxApp.currentIndex = periodIndex

                const extraData = IntentApp.getExtraData(intent)
                props.currentNumberPage     = extraData['currentPage']  || 1
                props.currentTotalPage      = extraData['totalPage']    || 1
                props.startPageNumberExport = extraData['currentPage']  || 1
                props.endPageNumberExport   = extraData['currentPage']  || 1

                exportNumberPageTextEdit.text = props.currentNumberPage
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/

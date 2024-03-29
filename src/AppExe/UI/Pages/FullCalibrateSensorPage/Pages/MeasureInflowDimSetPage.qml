﻿import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Inflow Measurement"

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
                    id: headerApp
                    anchors.fill: parent
                    title: qsTr("Inflow Measurement")
                }
            }

            /// BODY
            BodyItemApp {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 5

                            Item{
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5

                                    TextApp {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("Required velocity is")
                                    }//

                                    TextApp {
                                        id: acceptableValueText
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.bold: true
                                        color: "#05c46b"
                                        text: props.velocityReq.toFixed(2)
                                              + " ± "
                                              + props.velocityReqTolerant
                                              + " m/s"

                                        states: [
                                            State {
                                                when: props.measureUnit
                                                PropertyChanges {
                                                    target: acceptableValueText
                                                    text: props.velocityReq.toFixed(0)
                                                          + " ± "
                                                          + props.velocityReqTolerant
                                                          + " fpm"
                                                }
                                            }
                                        ]
                                        //                                        text: props.airflowBottomLimit
                                        //                                              + " < "
                                        //                                              + qsTr("Average")
                                        //                                              + " < "
                                        //                                              + props.airflowTopLimit
                                    }//

                                    TextApp {
                                        id: volumeRequiredText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text:  "(" + qsTr("Approx.") + " " + props.volumeReq.toFixed() + " l/s" + " " + qsTr("for each point") + ")"

                                        states: [
                                            State {
                                                when: props.measureUnit // imperial
                                                PropertyChanges {
                                                    target: volumeRequiredText
                                                    text:  "(" + qsTr("Approx.") + " " + props.volumeReq.toFixed() + " cfm" + " " + qsTr("for each point") + ")"
                                                }
                                            }
                                        ]
                                    }//
                                }//
                            }//

                            Item{
                                id: warningDamper
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true
                                visible: false

                                TextApp {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Do not adjust the damper opening!")
                                }//
                            }//

                            Item{
                                id: gridItem
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                GridLayout {
                                    anchors.fill: parent
                                    columns: 2

                                    Rectangle{
                                        id: gridBackgroundRectangle
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        Row{
                                            spacing: 5
                                            CheckBox {
                                                id: policyCheckBox
                                                height: 60
                                                width: 60
                                                font.pixelSize: 32
                                                onCheckedChanged: {
                                                    props.autoNextFillGrid = checked
                                                }
                                            }
                                            TextApp{
                                                height: 60
                                                //width: 40
                                                text: qsTr("Auto-next")
                                                verticalAlignment: Text.AlignVCenter
                                                font.pixelSize: 32
                                            }
                                        }//

                                        Flickable {
                                            id: girdFlick
                                            anchors.centerIn: parent
                                            height: gridLoader.height > gridBackgroundRectangle.height
                                                    ? gridBackgroundRectangle.height - 10 : gridLoader.height
                                            width: gridLoader.width > gridBackgroundRectangle.width
                                                   ? gridBackgroundRectangle.width - 10 : gridLoader.width
                                            clip: true
                                            contentHeight: gridLoader.height
                                            contentWidth: gridLoader.width

                                            ScrollBar.vertical: verticalScrollBar
                                            ScrollBar.horizontal: horizontalScrollBar

                                            onContentWidthChanged: {
                                                girdFlick.contentX = props.gridLastPositionX
                                                //                                                ////console.debug(girdFlick.contentX)
                                            }

                                            /// GRID
                                            Loader {
                                                id: gridLoader
                                                asynchronous: true
                                                visible: status == Loader.Ready

                                                onLoaded: {
                                                    gridLoader.item.clickedItem.connect(gridLoader.onClickedItem)
                                                }

                                                function onClickedItem(index, value, valueStrf) {
                                                    props.indexForAutoNextFillGrid = index
                                                    //                                                    props.strfForAutoNextFillGrid = valueStrf
                                                    //                                            ////console.debug(index)
                                                    bufferTextInput.text = valueStrf
                                                    bufferTextInput.lastIndexAccessed = index

                                                    KeyboardOnScreenCaller.openNumpad(bufferTextInput, "P-" + (index + 1))

                                                    // remembering teh last scrollview position
                                                    props.gridLastPositionX = girdFlick.contentX
                                                    //                                                    ////console.debug(props.gridLastPositionX)
                                                }//

                                            }//
                                        }//

                                        BusyIndicatorApp {
                                            anchors.centerIn: parent
                                            visible: gridLoader.status == Loader.Loading
                                        }//

                                        TextInput {
                                            id: bufferTextInput
                                            visible: false

                                            property int lastIndexAccessed: 0

                                            //                                        Connections {
                                            //                                            target: gridLoader.item

                                            //                                            function onClickedItem(index, value, valueStrf) {
                                            //                                                //                                        ////console.debug(index)
                                            //                                                bufferTextInput.text = valueStrf
                                            //                                                bufferTextInput.lastIndexAccessed = index

                                            //                                                KeyboardOnScreenCaller.openNumpad(bufferTextInput, "P-" + (index + 1))
                                            //                                            }//
                                            //                                        }//

                                            onAccepted: {
                                                //                                                ////console.debug(text)
                                                let valid = Number(text)
                                                if(isNaN(valid)){
                                                    showDialogMessage(qsTr("Warning"), qsTr("Value is invalid!"), dialogAlert)
                                                    return
                                                }

                                                let index = bufferTextInput.lastIndexAccessed
                                                if(props.measureUnit){
                                                    props.airflowGridItems[index]["val"] = props.getLsFromCfm(Number(text))
                                                    props.airflowGridItems[index]["valImp"] = Number(text)
                                                }
                                                else{
                                                    props.airflowGridItems[index]["val"] = Number(text)
                                                    props.airflowGridItems[index]["valImp"] = props.getCfmFromLs(Number(text))
                                                }
                                                props.airflowGridItems[index]["acc"] = 1

                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems,
                                                                                 props.measureUnit, props.openingArea)

                                                ////////////////////////////////////////////////////////////
                                                //console.debug("Auto-next:", props.autoNextFillGrid)

                                                if(props.autoNextFillGrid){

                                                    if(++props.indexForAutoNextFillGrid < props.airflowGridCount)
                                                    {
                                                        //console.debug("index", props.indexForAutoNextFillGrid)

                                                        //                                                        bufferTextInput.text = props.strfForAutoNextFillGrid
                                                        bufferTextInput.lastIndexAccessed = props.indexForAutoNextFillGrid

                                                        timerToOpenKeyBoard.start()

                                                        // remembering teh last scrollview position
                                                        props.gridLastPositionX = girdFlick.contentX
                                                        //                                                        props.gridLastPositionY = girdFlick.contentY

                                                        //                                                        props.strfForAutoNextFillGrid = ""
                                                    }else{
                                                        //console.debug("Reached maximum index!")
                                                    }
                                                }
                                                ////////////////////////////////////////////////////////////
                                            }//
                                        }//
                                    }//

                                    Rectangle{
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 10
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        /// Horizontal ScrollBar
                                        ScrollBar {
                                            id: verticalScrollBar
                                            anchors.fill: parent
                                            orientation: Qt.Horizontal
                                            policy: ScrollBar.AlwaysOn

                                            contentItem: Rectangle {
                                                implicitWidth: 5
                                                implicitHeight: 0
                                                radius: width / 2
                                                color: "#dddddd"
                                            }//
                                        }//
                                    }//

                                    Rectangle{
                                        Layout.minimumHeight: 10
                                        Layout.fillWidth: true
                                        color: "transparent"
                                        border.color: "#dddddd"
                                        radius: 5

                                        /// Horizontal ScrollBar
                                        ScrollBar {
                                            id: horizontalScrollBar
                                            anchors.fill: parent
                                            orientation: Qt.Horizontal
                                            policy: ScrollBar.AlwaysOn

                                            contentItem: Rectangle {
                                                implicitWidth: 0
                                                implicitHeight: 5
                                                radius: width / 2
                                                color: "#dddddd"
                                            }//
                                        }//
                                    }//
                                }//

                                TextApp{
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    rightPadding: 95
                                    font.pixelSize: 32
                                    text: props.measureUnit ? "cfm" : "l/s"
                                }
                            }//

                            Item{
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Repeater {
                                        model: [
                                            {color: "#e67e22", text: qsTr("Lowest")},
                                            {color: "#e74c3c", text: qsTr("Highest")},
                                            {color: "#27AE60", text: qsTr("Intermediate")},
                                            {color: "#8e44ad", text: qsTr("Done")},
                                        ]

                                        Row {
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 5

                                            Rectangle {
                                                anchors.verticalCenter: parent.verticalCenter
                                                height: 20
                                                width: 20
                                                color: modelData.color
                                            }//

                                            TextApp {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: modelData.text
                                            }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//

                    Item {
                        id: rightContentItem
                        Layout.fillHeight: true
                        Layout.minimumWidth: parent.width * 0.20

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: enabled ? "#0F2952" : "transparent"
                                border.color: "#e3dac9"
                                border.width: enabled ? 2 : 1
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    // TextApp {
                                    //     font.pixelSize: 14
                                    //     text: qsTr("Tap here to adjust")
                                    // }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Image {
                                            id: fanImage
                                            source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                            anchors.fill: parent
                                            fillMode: Image.PreserveAspectFit

                                            states: State {
                                                name: "stateOn"
                                                when: props.fanDutyCycleActual
                                                PropertyChanges {
                                                    target: fanImage
                                                    source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                }//
                                            }//
                                        }//
                                    }//

                                    TextApp {
                                        padding: 2
                                        text: qsTr("Duty Cycle:") + " " + props.fanDutyCycleActual + " %"
                                    }//

                                    TextApp {
                                        padding: 2
                                        text: qsTr("RPM:")+" " + props.fanRpmActual
                                    }//
                                }//

                                MouseArea {
                                    id: fanSpeedMouseArea
                                    anchors.fill: parent
                                    onClicked: {
                                        //                                        witBusyPageBlockApp.open()
                                    }//
                                }//

                                TextInput {
                                    id: fanSpeedBufferTextInput
                                    visible: false
                                    validator: IntValidator{bottom: 0; top: MachineData.fanSpeedMaxLimit;}

                                    Connections {
                                        target: fanSpeedMouseArea

                                        function onClicked() {
                                            //                                        ////console.debug(index)
                                            fanSpeedBufferTextInput.text = props.fanDutyCycleActual

                                            KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                        }//
                                    }//

                                    onAccepted: {
                                        let val = Number(text)
                                        if(isNaN(val)) return

                                        if(props.nominalSetting && val > 60){
                                            // Show Warning if more than 60% of ducy
                                            showDialogAsk(qsTr("Warning"),
                                                          qsTr("The nominal fan speed seems too high!"),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              MachineAPI.setFanPrimaryDutyCycle(val)
                                                              viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                                   function onTriggered(cycle){
                                                                                       if(cycle >= MachineAPI.BUSY_CYCLE_FAN){
                                                                                           viewApp.dialogObject.close() }
                                                                                   })
                                                          },
                                                          function onRejected(){
                                                              text = MachineData.fanPrimaryDutyCycle
                                                          },
                                                          function onCLosed(){
                                                              text = MachineData.fanPrimaryDutyCycle
                                                          },
                                                          true,
                                                          5,
                                                          qsTr("It's Okay"),//accept
                                                          qsTr("Cancel"))//Reject
                                        }else{
                                            MachineAPI.setFanPrimaryDutyCycle(val)
                                            viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                                 function onTriggered(cycle){
                                                                     if(cycle >= MachineAPI.BUSY_CYCLE_FAN){
                                                                         viewApp.dialogObject.close() }
                                                                 })
                                        }//
                                    }//
                                }//
                            }//

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: "transparent"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Average Volumetric")
                                    }//

                                    TextApp {
                                        text: props.measureUnit ? "cfm" : "l/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: avgTextField
                                            enabled: (props.fieldCalibration || !__osplatform__) ? true : false
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#e3dac9"

                                            background: Rectangle {
                                                id: averageBackgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                radius: 5
                                                color: avgTextField.enabled ? "#0F2952" : "transparent"
                                                border.color: "#E3DAC9"
                                                border.width: avgTextField.enabled ? 2 : 0

                                                Rectangle {
                                                    visible: !avgTextField.enabled
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//
                                                MouseArea{
                                                    id: avgTextFieldMouseArea
                                                    anchors.fill: parent
                                                }
                                            }//

                                            //states: [
                                            //    State {
                                            //        when: props.volumetric == 0
                                            //        PropertyChanges {
                                            //            target: averageBackgroundTextField
                                            //            color:  avgTextField.enabled ? "#55000000" : "transparent"
                                            //        }//
                                            //    },//
                                            //    State {
                                            //        when: props.volumetric < props.volumeReq
                                            //        PropertyChanges {
                                            //            target: averageBackgroundTextField
                                            //            color:  "#e67e22"
                                            //        }//
                                            //    },//
                                            //    State {
                                            //        when: props.volumetric > props.volumeReq
                                            //        PropertyChanges {
                                            //            target: averageBackgroundTextField
                                            //            color:  "#e74c3c"
                                            //        }//
                                            //    }//
                                            //]//

                                            Connections {
                                                target: avgTextFieldMouseArea

                                                function onClicked() {
                                                    KeyboardOnScreenCaller.openNumpad(avgTextField, qsTr("Average Volumetric") + " (%1)".arg(props.measureUnit ? "cfm" : "l/s"))
                                                }//
                                            }//
                                            onAccepted: {
                                                let valid = Number(text)
                                                if(isNaN(valid)){
                                                    showDialogMessage(qsTr("Warning"), qsTr("Value is invalid!"), dialogAlert)
                                                    return
                                                }
                                                let totalIndex = props.airflowGridCount
                                                //console.debug("totalIndex", totalIndex)
                                                for(let index=0; index<totalIndex; index++){
                                                    if(props.measureUnit){
                                                        props.airflowGridItems[index]["val"] = props.getLsFromCfm(Number(text))
                                                        props.airflowGridItems[index]["valImp"] = Number(text)
                                                    }
                                                    else{
                                                        props.airflowGridItems[index]["val"] = Number(text)
                                                        props.airflowGridItems[index]["valImp"] = props.getCfmFromLs(Number(text))
                                                    }
                                                    props.airflowGridItems[index]["acc"] = 1
                                                }
                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems,
                                                                                 props.measureUnit, props.openingArea)
                                            }//
                                        }//
                                    }//
                                }//

                                //                                MouseArea {
                                //                                    anchors.fill: parent
                                //                                    onClicked: {
                                //                                        //                                        witBusyPageBlockApp.open()
                                //                                    }//
                                //                                }//
                            }//

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: "transparent"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        Layout.fillWidth: true
                                        text: qsTr("Velocity") + ":"
                                    }//

                                    TextApp {
                                        Layout.fillWidth: true
                                        text: props.measureUnit ? "fpm" : "m/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: velocityTextField
                                            enabled: false
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"
                                            font.bold: false
                                            //                                            text: "0.03 (5%)"

                                            background: Rectangle {
                                                id: velocityBackgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                color: velocityTextField.enabled ? "#0F2952" : "transparent"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//

                                                states: [
                                                    State {
                                                        when: props.velocity == 0
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  velocityTextField.enabled ? "#0F2952" : "transparent"
                                                        }//
                                                    },//
                                                    State {
                                                        when: props.velocity < props.velocityLowestLimit
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  "#e67e22"
                                                        }//
                                                    },//
                                                    State {
                                                        when: props.velocity > props.velocityHighestLimit
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  "#e74c3c"
                                                        }//
                                                    },//
                                                    State {
                                                        when: (props.velocity < props.velocityHighestLimit) && (props.velocity > props.velocityLowestLimit)
                                                        PropertyChanges {
                                                            target: velocityTextField
                                                            color:  "#27AE60"
                                                            font.bold: true
                                                        }//
                                                    }//
                                                ]//
                                            }//
                                        }//
                                    }//
                                }//
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
                    radius: 2

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/back-step.png"
                                text: qsTr("Back")

                                onClicked: {
                                    var intent = IntentApp.create(uri, {})
                                    finishView(intent)
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/draft-w-icon.png"
                                text: qsTr("Load Previous Data")

                                onClicked: {
                                    const message = "<b>" + qsTr("Load previous data?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("Current values will be lost.")

                                    viewApp.showDialogAsk(qsTr("Inflow Measurement"),
                                                          message,
                                                          viewApp.dialogInfo,
                                                          function onAccepted(){
                                                              props.autoSaveToDraftAfterCalculated = false
                                                              helperWorkerScript.initGridFromStringify(draftSettings.drafAirflowGridStr,
                                                                                                       props.airflowGridCount,
                                                                                                       props.velocityDecimalPoint)
                                                          })
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/cancel-w-icon.png"
                                text: qsTr("Clear All")

                                onClicked: {
                                    const message = "<b>" + qsTr("Clear all values?") + "</b>"
                                                  + "<br><br>"
                                                  + qsTr("Current values and drafted values will be lost.")

                                    viewApp.showDialogAsk(qsTr("Inflow Measurement"),
                                                          message,
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              props.autoSaveToDraftAfterCalculated = true
                                                              helperWorkerScript.generateGrid(props.airflowGridCount,
                                                                                              props.velocityDecimalPoint)
                                                          })
                                }//
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                if (!props.gridAcceptedAll) {
                                    viewApp.showDialogMessage(qsTr("Inflow Measurement"),
                                                              qsTr("Please fill up all the fields!"),
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                if ((props.velocity > props.velocityHighestLimit) ||
                                        (props.velocity < props.velocityLowestLimit)) {

                                    viewApp.showDialogMessage(qsTr("Inflow Measurement"),
                                                              qsTr("Velocity result is out of range"),
                                                              viewApp.dialogAlert)
                                    return;
                                }
                                //                                let data = JSON.stringify(props.airflowGridItems)
                                //                                ////console.debug(data)
                                let result = props.getMeasureResult()
                                let intent = IntentApp.create(uri, {"pid": props.pid, "calibrateRes": result})
                                finishView(intent);
                            }//
                        }//
                    }//
                }//
            }//
        }//

        WorkerScript {
            id: helperWorkerScript
            source: "Components/WorkerScriptInflowDimHelper.mjs"

            property bool hasEstablised: false
            signal establised()

            Component.onCompleted: {
                //                ////console.debug("helperWorkerScript: establised")
                hasEstablised = true
                establised()
            }

            function generateGrid(count, decimals){
                sendMessage({"action": "generate", "count": count, "decimals": decimals})
            }//

            function initGrid(grid, count, decimals){
                sendMessage({"action": "init", "grid": grid, "count": count, "decimals": decimals})
            }//

            function initGridFromStringify(gridStringify, count, decimals){
                sendMessage({"action": "init", "gridStringify": gridStringify, "count": count, "decimals": decimals})
            }//

            function calculateGrid(airflowGridItems, meaUnit, area){
                sendMessage({"action": "calculate", "grid": airflowGridItems, "meaUnit": meaUnit, "area": area})
            }//

            onMessage: {
                //                ////console.debug(messageObject["action"])

                if (messageObject["action"] === "calculate") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {

                        let volume = messageObject["avgVal"]
                        props.volumetric = volume
                        /// update to view
                        avgTextField.text = Math.round(volume)

                        let velocity = messageObject["velVal"]
                        props.velocity = velocity
                        //                        ////console.debug(props.velocity)
                        /// update to view
                        velocityTextField.text = Number(velocity).toFixed(props.velocityDecimalPoint)

                        //                        ////console.debug(props.velocity + " - " + props.velocityHighestLimit)

                        let acceptedCount = messageObject["acceptedCount"]
                        let acceptedAll = messageObject["acceptedAll"]
                        ///
                        props.gridAcceptedCount = acceptedCount
                        props.gridAcceptedAll = acceptedAll

                        let minVal = messageObject["minVal"]
                        let maxVal = messageObject["maxVal"]
                        props.airflowGridItems = messageObject["grid"]

                        const sum = messageObject["sumVal"]
                        //                        //console.debug("sum: " + sum)
                        props.volumeTotal = sum

                        const avg = messageObject["avgVal"]
                        //                        //console.debug("avg: " + avg)
                        props.volumeAverage = avg

                        let count = messageObject["grid"].length
                        /// update to view
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "model": messageObject["grid"],
                                                 "valueMinimum": minVal,
                                                 "valueMaximum": maxVal,
                                                 "columns": count,
                                             })

                        /// Save to draft
                        if (props.autoSaveToDraftAfterCalculated) {
                            let gridStringify = messageObject["gridStringify"]
                            draftSettings.drafAirflowGridStr = gridStringify
                        }
                        //                                            ////console.debug(messageObject["gridStringify"])
                    }//
                }//

                else if (messageObject["action"] === "init") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "model": messageObject["grid"]
                                             })

                        ///show message
                        //                        viewApp.showDialogMessage(qsTr("Inflow Measurement"),
                        //                                                  qsTr("Value from temporary storage has been loaded!"),
                        //                                                  viewApp.dialogInfo)

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.measureUnit, props.openingArea)
                    }
                }

                else if (messageObject["action"] === "generate") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "model": messageObject["grid"]
                                             })

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.measureUnit, props.openingArea)
                    }//
                }//
            }//
        }//

        Timer{
            id: timerToOpenKeyBoard
            interval: 1000
            running: false
            repeat: false
            onTriggered: {
                //console.debug("Open Keyboard")

                if(props.measureUnit){
                    bufferTextInput.text = props.airflowGridItems[props.indexForAutoNextFillGrid]["valImp"]
                }
                else{
                    bufferTextInput.text = props.airflowGridItems[props.indexForAutoNextFillGrid]["val"]
                }

                KeyboardOnScreenCaller.openNumpad(bufferTextInput, "P-" + (props.indexForAutoNextFillGrid + 1))
            }//
        }//

        Settings {
            id: draftSettings
            category: props.draftName

            property string drafAirflowGridStr: ""
            //            Component.onCompleted: ////console.debug(drafDownflowGridStr)
        }//

        //        /// 0: airflow fix with tolerant, example: 0.30 ± 0.025, 60 ± 5
        //        /// 1: airflow have range, example: 0.27 - 0.35
        //        property int    airflowNominalInRange: 0

        QtObject {
            id: props

            property bool autoNextFillGrid: true
            property int indexForAutoNextFillGrid: 0
            //property string strfForAutoNextFillGrid: ""

            property string pid: "pid"

            property string draftName: ""

            property real   volumeReq: 0.0 /*+ 154*/
            property real   velocityReq: 0.0 /*+ 0.53*/
            property real   velocityReqTolerant: 0.0 /*+ 0.025*/
            property real   velocityLowestLimit: 0.0 /*+ 0.515*/
            property real   velocityHighestLimit: 0.0 /*+ 0.555*/
            //            property real   volumetricRequired: 0 + Math.ceil(velocityReq * 1000 * openingArea) // example: metric

            property int    airflowGridCount: 5
            property var    airflowGridItems: []
            property real   volumeTotal: 0
            property real   volumeAverage: 0
            property real   volumeLowest: 0
            property real   volumeHighest: 0
            property real   volumetric: 0
            property real   velocity: 0

            property int    gridAcceptedCount: 0
            property int    gridAcceptedAll: 0

            property real   openingArea: 0 /*+ 0.291*/

            /// After load from darft or clear all value, system needs to recalculate the values
            /// but don't want to save the temporary value to drart until use fill up one of any grid item
            property bool   autoSaveToDraftAfterCalculated: false

            property int    fanDutyCycleActual: 0 /*+ 45*/
            property int    fanRpmActual: 0 /*+ 900*/

            property int    fanDutyCycleInitial: 0
            //            property int    fanDutyCycleResult: 0
            //            property int    fanRpmResult: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int    measureUnit: 0
            /// Metric normally 2 digits after comma, ex: 0.30 (m/s)
            /// Imperial normally Zero digit after comma, ex: 60 (fpm)
            property int    velocityDecimalPoint: measureUnit ? 0 : 2

            property real   gridLastPositionX: 0

            property bool fieldCalibration: false

            property bool nominalSetting: false

            function getMeasureResult() {
                let result = {
                    'grid':     airflowGridItems,
                    'volume':   volumetric,
                    'volLow':   volumeLowest,
                    'volHigh':  volumeHighest,
                    'volAvg':   volumeAverage,
                    'volTotal': volumeTotal,
                    'velocity': velocity,
                    'fanDucy':  fanDutyCycleActual/*fanDutyCycleInitial*/,
                    'fanRpm':   fanRpmActual,
                }
                return result;
            }

            /// Need some logic to anticivate if the worker script not ready yet
            function initialGrid(){
                if(helperWorkerScript.hasEstablised) {
                    doInitialGrid()
                }
                else {
                    helperWorkerScript.establised.connect(doInitialGrid)
                }
            }
            function doInitialGrid(){
                props.autoSaveToDraftAfterCalculated = false
                helperWorkerScript.initGrid(props.airflowGridItems,
                                            props.airflowGridCount,
                                            props.velocityDecimalPoint)
            }
            function getLsFromCfm(cfm){
                return Math.round(cfm * 0.4719)
            }
            function getCfmFromLs(ls){
                return Math.round(ls * 2.11888)
            }
        }//

        /// Called once but after onResume
        Component.onCompleted: {
            policyCheckBox.checked = props.autoNextFillGrid
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                let extradata = IntentApp.getExtraData(intent)
                //                    ////console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        ////console.debug(extradata['pid'])
                    props.pid = extradata['pid']

                    headerApp.title = extradata['title'] + qsTr(" with Flowhood")

                    props.draftName = extradata['pid'] + "DimDraft"

                    props.measureUnit = extradata['measureUnit']

                    props.fanDutyCycleInitial = extradata['fanDutyCycle'] || 0

                    props.airflowGridItems = extradata['grid']
                    //                        ////console.debug(JSON.stringify(props.airflowGridItems))

                    let req = extradata['calibrateReq']
                    props.volumeReq =               req['volume']
                    props.velocityReq =             req['velocity']
                    props.velocityReqTolerant =     req['velocityTol']
                    props.velocityLowestLimit =     req['velocityTolLow']
                    props.velocityHighestLimit =    req['velocityTolHigh']
                    props.openingArea =             req['openingArea']
                    props.airflowGridCount =        req['gridCount']

                    props.fieldCalibration = extradata['fieldCalib'] || false

                    //                props.autoSaveToDraftAfterCalculated = false
                    //                helperWorkerScript.initGrid(props.airflowGridItems,
                    //                                            props.airflowGridCount,
                    //                                            props.velocityDecimalPoint)

                    if((props.pid === "meaifamin") || (props.pid === "meaifastb")){
                        warningDamper.visible = true
                    }
                    else{
                        if(props.pid == "meaifanom")
                            props.nominalSetting = true
                        warningDamper.visible = false
                    }
                }//

                props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })

                /// Automatically adjust the fan duty cycle to common initial duty cycle
                if (props.fanDutyCycleActual != props.fanDutyCycleInitial) {

                    MachineAPI.setFanPrimaryDutyCycle(props.fanDutyCycleInitial);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle >= MachineAPI.BUSY_CYCLE_FAN){
                                                 // generate grid
                                                 props.initialGrid()
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                }
                else {
                    // generate grid
                    props.initialGrid()
                }//
            }//

            /// onPause
            Component.onDestruction: {
                //                    ////console.debug("StackView.DeActivating - ifa");
            }//
        }//
    }//

    Component.onDestruction: {
        //        ////console.debug("onDestruction")
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/

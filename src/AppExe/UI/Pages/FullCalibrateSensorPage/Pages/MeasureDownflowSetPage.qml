﻿import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Downflow Measurement"

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
                    title: qsTr("Downflow Measurement")
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
                                        text: props.velocityReq.toFixed(2) + " ± " + props.velocityReqTolerant + " m/s"

                                        states: [
                                            State {
                                                when: props.measureUnit
                                                PropertyChanges {
                                                    target: acceptableValueText
                                                    text: props.velocityReq.toFixed(0) + " ± " + props.velocityReqTolerant + " fpm"
                                                }
                                            }
                                        ]
                                        //                                        text: props.airflowBottomLimit
                                        //                                              + " < "
                                        //                                              + qsTr("Average")
                                        //                                              + " < "
                                        //                                              + props.airflowTopLimit
                                    }//
                                }
                            }//

                            Item{
                                id: gridItem
                                Layout.fillHeight: true
                                Layout.fillWidth: true

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

                                            onContentHeightChanged: {
                                                girdFlick.contentY = props.gridLastPositionY
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
                                                    props.gridLastPositionY = girdFlick.contentY
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
                                                    props.airflowGridItems[index]["val"] = props.getMpsFromFpm(Number(text))
                                                    props.airflowGridItems[index]["valImp"] = Number(text)
                                                }
                                                else{
                                                    //If metric
                                                    let finalNum
                                                    if(Number(text) >= 1) {
                                                        finalNum = parseFloat((Number(text) / 100).toFixed(2)) //example 53 -> 53/100 -> 0.53
                                                    }
                                                    else {
                                                        finalNum = Number(text)
                                                    }

                                                    props.airflowGridItems[index]["val"] = finalNum//Number(text)
                                                    props.airflowGridItems[index]["valImp"] = props.getFpmFromMps(finalNum/*Number(text)*/)
                                                    //console.debug("final num df vel: " + finalNum)
                                                }
                                                props.airflowGridItems[index]["acc"] = 1

                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)


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
                                                        props.gridLastPositionY = girdFlick.contentY

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
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                enabled: false
                                color: enabled ? "#0F2952" : "transparent"
                                border.color: "#e3dac9"
                                border.width: enabled ? 2 : 1
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    //                                    TextApp {
                                    //                                        font.pixelSize: 14
                                    //                                        visible: false
                                    //                                        text: qsTr("Tap here to adjust")
                                    //                                    }

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
                                        text: qsTr("Duty Cycle:")+ " " + props.fanDutyCycleActual + " %"
                                    }//

                                    TextApp {
                                        padding: 2
                                        text: qsTr("RPM:")+" " + props.fanRpmActual
                                    }//
                                }//

                                MouseArea {
                                    id: fanSpeedMouseArea
                                    anchors.fill: parent
                                }//

                                TextInput {
                                    id: fanSpeedBufferTextInput
                                    visible: false
                                    validator: IntValidator{bottom: 0; top: 99;}

                                    Connections {
                                        target: fanSpeedMouseArea

                                        function onClicked() {
                                            if(((MachineData.getAirflowFactoryCalibrationState(0) === true)
                                                || props.fieldCalibration)
                                                    && (props.showChangeDcyWarning === true)){
                                                const message = "<b>" + qsTr("Are you sure you want to change the duty cycle?") + "</b>"
                                                              + "<br><br>"
                                                              + qsTr("You have to redo the inflow balancing if changing the duty cycle.")

                                                var autoClose = false
                                                viewApp.showDialogAsk(qsTr(viewApp.title),
                                                                      message,
                                                                      viewApp.dialogAlert,
                                                                      function onAccepted(){
                                                                          fanSpeedBufferTextInput.text = props.fanDutyCycleActual
                                                                          KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                                      }, function(){}, function(){}, autoClose)
                                            }
                                            else{
                                                fanSpeedBufferTextInput.text = props.fanDutyCycleActual
                                                KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                            }
                                            //                                        ////console.debug(index)
                                        }//
                                    }//

                                    onAccepted: {
                                        props.showChangeDcyWarning = false
                                        let val = Number(text)
                                        if(isNaN(val)) return

                                        MachineAPI.setFanPrimaryDutyCycle(val)

                                        viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                                             function onTriggered(cycle){
                                                                 if(cycle >= MachineAPI.BUSY_CYCLE_FAN){
                                                                     viewApp.dialogObject.close()
                                                                 }
                                                             })
                                    }//
                                }//
                            }//

                            Rectangle {
                                //                                anchors.verticalCenter: parent.verticalCenter
                                width: rightContentItem.width
                                height: rightContentItem.height / 3 - 5
                                color: /*"#0F2952"*/"transparent"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Average Velocity") + ":"
                                    }//

                                    TextApp {
                                        text: props.measureUnit ? "fpm" : "m/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: averageTextField
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
                                                color: averageTextField.enabled ? "#0F2952" : "transparent"
                                                border.color: "#E3DAC9"
                                                border.width: averageTextField.enabled ? 2 : 0

                                                Rectangle {
                                                    visible: !averageTextField.enabled
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//
                                                MouseArea{
                                                    id: averageTextFieldMouseArea
                                                    anchors.fill: parent
                                                }
                                            }//

                                            states: [
                                                State {
                                                    when: props.velocityAverage == 0
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  averageTextField.enabled ? "#0F2952" : "transparent"
                                                    }//
                                                },//
                                                State {
                                                    when: props.velocityAverage < props.velocityLowestLimit
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  "#e67e22"
                                                    }//
                                                },//
                                                State {
                                                    when: props.velocityAverage > props.velocityHighestLimit
                                                    PropertyChanges {
                                                        target: averageBackgroundTextField
                                                        color:  "#e74c3c"
                                                    }//
                                                }//
                                            ]//
                                            Connections {
                                                target: averageTextFieldMouseArea

                                                function onClicked() {
                                                    KeyboardOnScreenCaller.openNumpad(averageTextField, qsTr("Average Velocity") + " (%1)".arg(props.measureUnit ? "fpm" : "m/s"))
                                                }//
                                            }//
                                            onAccepted: {
                                                let valid = Number(text)
                                                if(isNaN(valid)){
                                                    showDialogMessage(qsTr("Warning"), qsTr("Value is invalid!"), dialogAlert)
                                                    return
                                                }
                                                let totalIndex = props.airflowGridCount

                                                for(let index = 0; index < totalIndex; index++){
                                                    if(props.measureUnit){
                                                        props.airflowGridItems[index]["val"] = props.getMpsFromFpm(Number(text))
                                                        props.airflowGridItems[index]["valImp"] = Number(text)
                                                    }
                                                    else{
                                                        props.airflowGridItems[index]["val"] = Number(text)
                                                        props.airflowGridItems[index]["valImp"] = props.getFpmFromMps(Number(text))
                                                    }
                                                    props.airflowGridItems[index]["acc"] = 1
                                                }
                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
                                            }
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
                                color: /*"#0F2952"*/"transparent"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        text: qsTr("Maximum Deviation") + ":"
                                    }//

                                    TextApp {
                                        text: props.measureUnit ? "fpm" : "m/s"
                                    }//

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        TextField {
                                            id: deviationTextField
                                            enabled: false
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 2
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            color: "#dddddd"
                                            //                                            text: "0.03 (5%)"

                                            background: Rectangle {
                                                id: deviationBackgroundTextField
                                                height: parent.height
                                                width: parent.width
                                                color: deviationTextField.enabled ? "#0F2952" : "transparent"

                                                Rectangle {
                                                    height: 1
                                                    width: parent.width
                                                    anchors.bottom: parent.bottom
                                                }//

                                                states: [
                                                    State {
                                                        when: props.velocityDeviationPercent > props.deviationMaxLimit
                                                        PropertyChanges {
                                                            target: deviationBackgroundTextField
                                                            color:  "#e74c3c"
                                                        }//
                                                    }//
                                                ]//
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

                                    viewApp.showDialogAsk(qsTr("Downflow Measurement"),
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

                                    viewApp.showDialogAsk(qsTr("Downflow Measurement"),
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

                            imageSource: "/UI/Pictures/checkicon.png"
                            text: qsTr("Set")

                            onClicked: {
                                //                                let data = JSON.stringify(props.airflowGridItems)
                                //                                ////console.debug(data)
                                if (!props.gridAcceptedAll) {
                                    viewApp.showDialogMessage(qsTr("Downflow Measurement"),
                                                              qsTr("Please fill up all the fields!"),
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                const velFromLowIsValid     = (props.velocityAverage < props.velocityLowestLimit) ? true : false
                                const velFromHighIsValid    = (props.velocityAverage > props.velocityHighestLimit) ? true : false
                                const devIsValid            = props.velocityDeviationPercent > props.deviationMaxLimit ? true : false

                                //                                ////console.debug("velFromLowIsValid: " + velFromLowIsValid + " " + props.velocityAverage + " " + props.velocityLowestLimit)
                                //                                ////console.debug("velFromHighIsValid: " + velFromHighIsValid + " " + props.velocityAverage + " " + props.velocityHighestLimit)
                                //                                ////console.debug("devIsValid: " + devIsValid)

                                if (velFromLowIsValid || velFromHighIsValid || devIsValid) {
                                    var message = devIsValid ? qsTr("The deviation is out of range.") : qsTr("The velocity is out of range.")
                                    viewApp.showDialogMessage(qsTr("Downflow Measurement"),
                                                              message,
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                let result = props.getMeasureResult()
                                let intent = IntentApp.create(uri, {"pid": props.pid, "calibrateRes": result})
                                finishView(intent);
                            }//
                        }//
                    }//
                }//
            }
        }//

        WorkerScript {
            id: helperWorkerScript
            source: "Components/WorkerScriptDonflowHelper.mjs"

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

            function calculateGrid(airflowGridItems, decimals){
                sendMessage({"action": "calculate", "grid": airflowGridItems, "decimals": decimals})
            }//

            onMessage: {
                //                ////console.debug(messageObject["action"])

                if (messageObject["action"] === "calculate") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {

                        let average = messageObject["avgVal"]
                        ///
                        props.velocityAverage = average
                        //                        ////console.debug(props.velocityAverage)

                        /// update to view
                        if(props.measureUnit)
                            average = Math.round(average)
                        else
                            average = Number(average).toFixed(2)

                        averageTextField.text = average

                        let deviation = messageObject["maxDeviationVal"]
                        let deviationPercent = messageObject["maxDeviationPrecent"]
                        if(props.measureUnit)
                            deviation = Math.round(deviation)
                        else
                            deviation = Number(deviation).toFixed(2)
                        let deviationText = deviation + " (" + deviationPercent +"%)"
                        ///
                        props.velocityDeviation = Number(deviation)
                        props.velocityDeviationPercent = deviationPercent
                        /// update to view
                        deviationTextField.text = deviationText

                        let acceptedCount = messageObject["acceptedCount"]
                        let acceptedAll = messageObject["acceptedAll"]
                        ///
                        props.gridAcceptedCount = acceptedCount
                        props.gridAcceptedAll = acceptedAll

                        let minVal = messageObject["minVal"]
                        props.velocityLowest = minVal
                        let maxVal = messageObject["maxVal"]
                        props.velocityHighest = maxVal

                        let sumVal = messageObject["sumVal"]
                        props.velocitySum = sumVal

                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"],
                                                 "valueMinimum": minVal,
                                                 "valueMaximum": maxVal,
                                             })

                        /// Save to draft
                        if (props.autoSaveToDraftAfterCalculated) {
                            let gridStringify = messageObject["gridStringify"]
                            draftSettings.drafAirflowGridStr = gridStringify
                        }
                        //////console.debug(messageObject["gridStringify"])
                    }//
                }//

                else if (messageObject["action"] === "init") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"],
                                             })

                        ///show message
                        //                        viewApp.showDialogMessage(qsTr("Downflow Measurement"),
                        //                                                  qsTr("Value from temporary storage has been loaded!"),
                        //                                                  viewApp.dialogInfo)

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
                    }
                }

                else if (messageObject["action"] === "generate") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {
                        props.airflowGridItems = messageObject["grid"]
                        gridLoader.setSource("Components/MeasureAirflowGrid.qml",
                                             {
                                                 "measureUnit": props.measureUnit,
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"]
                                             })

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint)
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

        // /// 0: airflow fix with tolerant, example: 0.30 ± 0.025, 60 ± 5
        // /// 1: airflow have range, example: 0.27 - 0.35
        // property int    airflowNominalInRange: 0

        QtObject {
            id: props

            property bool autoNextFillGrid: true
            property int indexForAutoNextFillGrid: 0
            //            property string strfForAutoNextFillGrid: ""

            property string pid: "pid"

            property string draftName: ""

            property real   velocityReq: 0.0 /*+ 0.30*/
            property real   velocityReqTolerant: 0.0 /*+ 0.025*/
            property real   velocityLowestLimit: 0.0 /*+ 0.275*/
            property real   velocityHighestLimit: 0.0 /*+ 0.325*/
            property int    deviationMaxLimit: 0 + 20

            property int    airflowGridColumns: 1
            property int    airflowGridCount: 1
            property var    airflowGridItems: []
            property real   velocitySum: 0
            property real   velocityAverage: 0
            property real   velocityLowest: 0
            property real   velocityHighest: 0
            property real   velocityDeviation: 0
            property real   velocityDeviationPercent: 0

            property int    gridAcceptedCount: 0
            property int    gridAcceptedAll: 0

            property bool   autoSaveToDraftAfterCalculated: false

            property int    fanDutyCycleActual: 0
            property int    fanRpmActual: 0

            property int    fanDutyCycleInitial: 0
            property int    fanDutyCycleResult: 0
            property int    fanRpmResult: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int    measureUnit: 0
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int    velocityDecimalPoint: measureUnit ? 0 : 2

            property real   gridLastPositionX: 0
            property real   gridLastPositionY: 0

            property bool showChangeDcyWarning: false
            property bool fieldCalibration: false

            function getMeasureResult() {
                let result = {
                    'grid':     airflowGridItems,
                    'velocity': velocityAverage,
                    'velLow':   velocityLowest,
                    'velHigh':  velocityHighest,
                    'velDev':   velocityDeviation,
                    'velDevp':  velocityDeviationPercent,
                    'velSum':   velocitySum,
                    'fanDucy':  fanDutyCycleActual,
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

            function getMpsFromFpm(fpm){
                return (Math.round(fpm * 0.508))/100
            }
            function getFpmFromMps(mps){
                return Math.round(mps * 196.85)
            }
        }

        /// Called once but after onResume
        Component.onCompleted: {
            if((MachineData.getAirflowFactoryCalibrationState(0) === true)
                    || (MachineData.getAirflowFactoryCalibrationState(2) === true) //if IF Nom/Min/Stb Has Done, must redo
                    || (MachineData.getAirflowFactoryCalibrationState(1) === true)){
                props.showChangeDcyWarning = true
            }
            else props.showChangeDcyWarning = false

            policyCheckBox.checked = props.autoNextFillGrid
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {

                let extradata = IntentApp.getExtraData(intent)
                //                    ////console.debug(JSON.stringify(extradata))
                if (extradata['pid'] !== undefined) {
                    //                        ////console.debug(JSON.stringify(extradata))

                    headerApp.title = extradata['title'] + qsTr(" with Thermo Anemometer")

                    props.pid = extradata['pid']

                    props.draftName = extradata['pid'] + "Draft"

                    props.measureUnit = extradata['measureUnit']

                    props.fanDutyCycleInitial = extradata['fanDutyCycle'] || 0

                    props.airflowGridItems = extradata['grid']
                    //                        ////console.debug(JSON.stringify(props.airflowGridItems))

                    let req = extradata['calibrateReq']
                    props.velocityReq =             req['velocity']
                    props.velocityReqTolerant =     req['velocityTol']
                    props.velocityLowestLimit =     req['velocityTolLow']
                    props.velocityHighestLimit =    req['velocityTolHigh']
                    props.deviationMaxLimit =       req['velDevp']
                    props.airflowGridCount =        req['grid']['count']
                    props.airflowGridColumns =      req['grid']['columns']

                    props.fieldCalibration = extradata['fieldCalib'] || false

                    if(props.fieldCalibration)
                        props.showChangeDcyWarning = true
                    //                        ////console.debug("gridColumn:" + props.airflowGridColumn)

                    //                helperWorkerScript.establised.connect(function(){
                    //                    props.autoSaveToDraftAfterCalculated = false
                    //                    helperWorkerScript.initGrid(props.airflowGridItems,
                    //                                                props.airflowGridCount,
                    //                                                props.velocityDecimalPoint)
                    //                })

                    //                props.autoSaveToDraftAfterCalculated = false
                    //                helperWorkerScript.initGrid(props.airflowGridItems,
                    //                                            props.airflowGridCount,
                    //                                            props.velocityDecimalPoint)
                }

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
                //////console.debug("StackView.DeActivating");
            }//
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/

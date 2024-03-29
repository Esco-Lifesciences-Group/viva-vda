import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Inflow Secondary Method"

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
                    title: qsTr("Inflow Secondary Method")
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
                                        text: qsTr("Required (converted) velocity is")
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
                                    }//

                                    TextApp {
                                        id: velPerPointText
                                        anchors.verticalCenter: parent.verticalCenter
                                        text:  "(" + qsTr("Approx.") + " " + props.velPerPointStrf + " " + qsTr("for each point") + ")"
                                    }//
                                }//
                            }//

                            Item{
                                id: warningSash
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                TextApp {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Adjust sash to a 76mm (3”) opening!")
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
                                                    props.airflowGridItems[index]["val"] = props.getMpsFromFpm(Number(text))
                                                    props.airflowGridItems[index]["valImp"] = Number(text)
                                                }
                                                else{
                                                    props.airflowGridItems[index]["val"] = Number(text)
                                                    props.airflowGridItems[index]["valImp"] = props.getFpmFromMps(Number(text))
                                                }
                                                props.airflowGridItems[index]["acc"] = 1

                                                props.autoSaveToDraftAfterCalculated = true
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint, props.correctionFactor)

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

                                        Row{
                                            anchors.bottom: parent.bottom
                                            anchors.right: parent.right
                                            TextApp{
                                                text: qsTr("Correction factor") + ":"
                                                padding: 5
                                            }
                                            TextApp{
                                                text: props.correctionFactor
                                                padding: 5
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

                                    //                                    TextApp {
                                    //                                        font.pixelSize: 14
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
                                        text: qsTr("Duty Cycle:") + " " + props.fanDutyCycleActual + " %"
                                    }//

                                    TextApp {
                                        padding: 2
                                        text: qsTr("RPM:") + " " + props.fanRpmActual
                                    }//
                                }//

                                MouseArea {
                                    id: fanSpeedMouseArea
                                    anchors.fill: parent
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

                                                for(let index=0; index < totalIndex; index++){
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
                                                helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint, props.correctionFactor)
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
                                color: "transparent"
                                border.color: "#dddddd"
                                radius: 5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    spacing: 1

                                    TextApp {
                                        Layout.fillWidth: true
                                        text: qsTr("Converted Velocity") + ":"
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
                                                        when: props.velocityConpensate == 0
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  velocityTextField.enabled ? "#0F2952" : "transparent"
                                                        }//
                                                    },//
                                                    State {
                                                        when: props.velocityConpensate < props.velocityLowestLimit
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  "#e67e22"
                                                        }//
                                                    },//
                                                    State {
                                                        when: props.velocityConpensate > props.velocityHighestLimit
                                                        PropertyChanges {
                                                            target: velocityBackgroundTextField
                                                            color:  "#e74c3c"
                                                        }//
                                                    }//
                                                ]//
                                            }//
                                        }//
                                    }//
                                }//

                                // MouseArea {
                                //     anchors.fill: parent
                                //     onClicked: {
                                //         //                                        witBusyPageBlockApp.open()
                                //     }//
                                // }//
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

                                    viewApp.showDialogAsk(qsTr("Inflow Secondary Method"),
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

                                    viewApp.showDialogAsk(qsTr("Inflow Secondary Method"),
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
                                    viewApp.showDialogMessage(qsTr("Inflow Secondary Method"),
                                                              qsTr("Please fill up all the fields!"),
                                                              viewApp.dialogAlert)
                                    return;
                                }

                                const pass = (props.velocityConpensate != 0)
                                           && (props.velocityConpensate > props.velocityLowestLimit)
                                           && (props.velocityConpensate < props.velocityHighestLimit)
                                if (!pass) {
                                    viewApp.showDialogMessage(qsTr("Inflow Secondary Method"),
                                                              qsTr("The velocity is out of range."),
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
            source: "Components/WorkerScriptInflowSecHelper.mjs"

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

            function calculateGrid(airflowGridItems, decimals, correctionFactor){
                sendMessage({"action": "calculate", "grid": airflowGridItems, "decimals": decimals, "correctionFactor": correctionFactor})
            }//

            onMessage: {
                //                ////console.debug(messageObject["action"])

                if (messageObject["action"] === "calculate") {
                    //                                        ////console.debug(messageObject["grid"])
                    if(messageObject["status"] === "finished") {

                        let sumVal = messageObject["sumVal"]
                        ///
                        props.velocityTotal = sumVal

                        let average = Number(messageObject["avgVal"])
                        /// update to view
                        if(props.measureUnit){
                            average = Math.round(average)
                            average = average.toFixed()
                        }
                        else{
                            average = average.toFixed(2)
                        }
                        props.velocityAverage = Number(average)
                        averageTextField.text = average

                        let velocity = Number(messageObject["velVal"])
                        /// update the view
                        if(props.measureUnit){
                            velocity = Math.round(velocity)
                            velocity = velocity.toFixed()
                        }
                        else{
                            velocity = velocity.toFixed(2)
                        }
                        props.velocityConpensate = Number(velocity)
                        velocityTextField.text = velocity

                        let acceptedCount = messageObject["acceptedCount"]
                        let acceptedAll = messageObject["acceptedAll"]
                        ///
                        props.gridAcceptedCount = acceptedCount
                        props.gridAcceptedAll = acceptedAll

                        let minVal = messageObject["minVal"]
                        let maxVal = messageObject["maxVal"]

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
                                                 "columns": props.airflowGridColumns,
                                                 "model": messageObject["grid"],
                                             })

                        ///show message
                        //                        viewApp.showDialogMessage(qsTr("Inflow Secondary Method"),
                        //                                                  qsTr("Value from temporary storage has been loaded!"),
                        //                                                  viewApp.dialogInfo)

                        /// then calculate
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint, props.correctionFactor)
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
                        helperWorkerScript.calculateGrid(props.airflowGridItems, props.velocityDecimalPoint, props.correctionFactor)
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
            //            property string strfForAutoNextFillGrid: ""

            property string pid: "pid"

            property string draftName: ""

            property real   velocityReq: 0.0 /*+ 0.30*/
            property real   velocityReqTolerant: 0.0 /*+ 0.025*/
            property real   velocityLowestLimit: 0.0 /*+ 0.275*/
            property real   velocityHighestLimit: 0.0 /*+ 0.325*/

            property real   velPerPoint: 0
            property string velPerPointStrf: ""

            property real   correctionFactor: 0

            property int    airflowGridColumns: 1
            property int    airflowGridCount: 1
            property var    airflowGridItems: []
            property real   velocityTotal: 0
            property real   velocityAverage: 0
            property real   velocityConpensate: 0
            property real   velocityLowest: 0
            property real   velocityHighest: 0

            property int    gridAcceptedCount: 0
            property int    gridAcceptedAll: 0

            property bool   autoSaveToDraftAfterCalculated: false

            property int    fanDutyCycleActual: 0
            property int    fanRpmActual: 0

            property int    fanDutyCycleInitial: 0
            property int    fanDutyCycleResult: 0
            property int    fanRpmResult: 0

            property real   gridLastPositionX: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int    measureUnit: 0
            /// Metric normally 2 digits after comma, ex: 0.30
            /// Imperial normally Zero digit after comma, ex: 60
            property int    velocityDecimalPoint: measureUnit ? 0 : 2

            property bool fieldCalibration: false

            property bool nominalSetting: false

            function getMeasureResult() {
                let result = {
                    'grid':     airflowGridItems,
                    'velTotal': velocityTotal,
                    'velLow':   velocityLowest,
                    'velHigh':  velocityHighest,
                    'velAvg':   velocityAverage,
                    'velocity': velocityConpensate,
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
            function getLsFromCfm(ls){
                return Math.round(ls * 2.11888)
            }
            function getCfmFromLs(cfm){
                return Math.round(cfm * 0.4719)
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

                    headerApp.title = extradata['title'] + qsTr(" with Hot Wire")

                    props.pid = extradata['pid']

                    props.draftName = extradata['pid'] + "SecDraft"

                    props.measureUnit = extradata['measureUnit']

                    props.fanDutyCycleInitial = extradata['fanDutyCycle'] || 0

                    props.airflowGridItems = extradata['grid']
                    //                        ////console.debug(JSON.stringify(props.airflowGridItems))

                    let req = extradata['calibrateReq']
                    //                        ////console.debug(JSON.stringify(req))
                    props.velocityReq =             req['velocity']
                    props.velocityReqTolerant =     req['velocityTol']
                    props.velocityLowestLimit =     req['velocityTolLow']
                    props.velocityHighestLimit =    req['velocityTolHigh']
                    props.airflowGridCount =        req['gridCount']
                    props.airflowGridColumns =      req['gridCount']
                    props.correctionFactor =        req['correctionFactor']

                    props.fieldCalibration = extradata['fieldCalib'] || false

                    props.velPerPoint = (props.velocityReq / props.correctionFactor)
                    //                        ////console.debug(props.velPerPoint)
                    if(props.measureUnit) {
                        props.velPerPointStrf = props.velPerPoint.toFixed()  + " fpm"
                    }
                    else {
                        props.velPerPointStrf = props.velPerPoint.toFixed(2)  + " m/s"
                    }

                    if(props.pid == "meaifanomsecfield"){
                        props.nominalSetting = true
                    }
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
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

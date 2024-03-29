/*
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
 *          Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "UV Scheduler"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// comment this visible property for production
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
                    title: qsTr("UV Scheduler")
                }
            }

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                RowLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Row {
                                spacing: 10

                                Item {
                                    height: 100
                                    width: 200
                                    //                    radius: 5
                                    //                    color: "#dd0F2952"
                                    //                    border.color: "#dddddd"

                                    Rectangle {
                                        id: onEnableRectangle
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        border.color: "#e3dac9"
                                        radius: 5
                                        states: [
                                            State{
                                                when: onEnableSwitch.checked
                                                PropertyChanges {
                                                    target: onEnableRectangle
                                                    color: "#1e824c"
                                                }
                                            }
                                        ]
                                    }

                                    ColumnLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        TextApp {
                                            text: qsTr("Scheduler On")
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            SwitchApp{
                                                id: onEnableSwitch
                                                anchors.centerIn: parent

                                                onCheckedChanged: {
                                                    if (!initialized) return

                                                    props.onEnableSet = checked ? 1 : 0
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Item {
                                    id: onTimeScheduleRect
                                    height: 100
                                    width: 200
                                    //                    radius: 5
                                    //                    color: "#dd0F2952"
                                    //                    border.color: "#dddddd"
                                    //                    visible: false

                                    visible: onEnableSwitch.checked
                                    //                            scale: visible ? 1.0 : 0.1
                                    //                            Behavior on scale {
                                    //                                NumberAnimation { duration: 100}
                                    //                            }

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        border.color: "#e3dac9"
                                        radius: 5
                                    }//

                                    ColumnLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        TextApp {
                                            text: qsTr("Time")
                                        }//

                                        Item {
                                            id: onUvAutoSetTimeItem
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp{
                                                id: onTimeText
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.bold: true
                                                font.pixelSize: 22
                                            }//
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            //////console.debug("Open time picker")
                                            finishViewReturned.connect(props.onReturnFromTimePickerPage)
                                            let hour = props.onTimeSet/60
                                            let minute = props.onTimeSet%60
                                            const intent = IntentApp.create("qrc:/UI/Pages/TimePickerPage/TimePickerPage.qml",
                                                                            {   "pid": "on",
                                                                                "temp": props.parameterOnHasChanged,
                                                                                "hour": hour,
                                                                                "minute": minute,
                                                                                "periodMode": props.timePeriodMode
                                                                            })
                                            startView(intent)
                                        }//
                                    }//
                                }//
                            }//

                            Item {
                                id: onRepeatScheduleRect
                                height: 100
                                width: 410
                                //                    radius: 5
                                //                    color: "#dd0F2952"
                                //                    border.color: "#dddddd"
                                //                    visible: false

                                visible: onEnableSwitch.checked
                                //                        scale: visible ? 1.0 : 0.1
                                //                        Behavior on scale {
                                //                            NumberAnimation { duration: 100}
                                //                        }

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#0F2952"
                                    border.color: "#e3dac9"
                                    radius: 5
                                }//

                                ColumnLayout{
                                    anchors.fill: parent
                                    anchors.margins: 5

                                    TextApp {
                                        text: qsTr("Repeat")
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        ComboBoxApp {
                                            id: onRepeatDayComboBox
                                            anchors.fill: parent
                                            backgroundColor: "#0F2952"
                                            backgroundBorderColor: "#dddddd"
                                            backgroundBorderWidth: 2
                                            font.pixelSize: 20
                                            anchors.verticalCenter: parent.verticalCenter
                                            textRole: "text"
                                            popupHeight: 250

                                            model: [
                                                {text: qsTr("Once")},
                                                {text: qsTr("Everyday")},
                                                {text: qsTr("Weekdays - Monday to Friday")},
                                                {text: qsTr("Weekends - Saturday & Sunday")},
                                                {text: qsTr("Weekly - Monday")},
                                                {text: qsTr("Weekly - Tuesday")},
                                                {text: qsTr("Weekly - Wednesday")},
                                                {text: qsTr("Weekly - Thursday")},
                                                {text: qsTr("Weekly - Friday")},
                                                {text: qsTr("Weekly - Saturday")},
                                                {text: qsTr("Weekly - Sunday")},
                                            ]

                                            onActivated: {
                                                //                                        console.log("onActivated")
                                                props.onRepeatSet = index < 4 ? index : 4

                                                props.onRepeatSetStrf = model[index].text

                                                if (index >= 4) {
                                                    props.onRepeatDaySet = (index - 4) + 1;
                                                }//
                                            }//

                                            //                                    Component.onCompleted: {
                                            //                                        let repeat = props.uvAutoSetDayRepeat
                                            //                                        let day = props.uvAutoSetWeeklyDay

                                            //                                        //////console.debug(repeat)
                                            //                                        //////console.debug(day)

                                            //                                        let index = repeat;
                                            //                                        if (repeat >= 4) {
                                            //                                            index = repeat + (day - 1)
                                            //                                        }//
                                            //                                        currentIndex = index
                                            //                                    }//
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                    Rectangle{
                        visible: MachineData.uvTime === 0
                        Layout.fillHeight: true
                        Layout.minimumWidth: 1
                        color: "#dddddd"
                    }
                    Item{
                        visible: MachineData.uvTime === 0
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Row {
                                spacing: 10

                                Item {
                                    height: 100
                                    width: 200
                                    //                    radius: 5
                                    //                    color: "#dd0F2952"
                                    //                    border.color: "#dddddd"

                                    Rectangle {
                                        id: offEnableRectangle
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        border.color: "#e3dac9"
                                        radius: 5
                                        states: [
                                            State{
                                                when: offEnableSwitch.checked
                                                PropertyChanges {
                                                    target: offEnableRectangle
                                                    color: "#1e824c"
                                                }
                                            }
                                        ]
                                    }

                                    ColumnLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        TextApp {
                                            text: qsTr("Scheduler Off")
                                        }//

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            SwitchApp{
                                                id: offEnableSwitch
                                                anchors.centerIn: parent

                                                onCheckedChanged: {
                                                    if (!initialized) return

                                                    props.offEnableSet = checked ? 1 : 0

                                                    //setButton.visible = true
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Item {
                                    id: offTimeScheduleRect
                                    height: 100
                                    width: 200
                                    //                    radius: 5
                                    //                    color: "#dd0F2952"
                                    //                    border.color: "#dddddd"
                                    //                    visible: false

                                    visible: offEnableSwitch.checked
                                    //                            scale: visible ? 1.0 : 0.1
                                    //                            Behavior on scale {
                                    //                                NumberAnimation { duration: 100}
                                    //                            }

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "#0F2952"
                                        border.color: "#e3dac9"
                                        radius: 5
                                    }//

                                    ColumnLayout{
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        TextApp {
                                            text: qsTr("Time")
                                        }//

                                        Item {
                                            id: offUvAutoSetTimeItem
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            TextApp{
                                                id: offTimeText
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.bold: true
                                                font.pixelSize: 22
                                            }//
                                        }//
                                    }//

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            //////console.debug("Open time picker")
                                            finishViewReturned.connect(props.onReturnFromTimePickerPage)
                                            let hour = props.offTimeSet/60
                                            let minute = props.offTimeSet%60
                                            const intent = IntentApp.create("qrc:/UI/Pages/TimePickerPage/TimePickerPage.qml",
                                                                            {   "pid": "off",
                                                                                "temp": props.parameterOffHasChanged,
                                                                                "hour": hour,
                                                                                "minute": minute,
                                                                                "periodMode": props.timePeriodMode
                                                                            })
                                            startView(intent)
                                        }//
                                    }//
                                }//
                            }//

                            Item {
                                id: offRepeatScheduleRect
                                height: 100
                                width: 410
                                //                    radius: 5
                                //                    color: "#dd0F2952"
                                //                    border.color: "#dddddd"
                                //                    visible: false

                                visible: offEnableSwitch.checked
                                //                        scale: visible ? 1.0 : 0.1
                                //                        Behavior on scale {
                                //                            NumberAnimation { duration: 100}
                                //                        }

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#0F2952"
                                    border.color: "#e3dac9"
                                    radius: 5
                                }//

                                ColumnLayout{
                                    anchors.fill: parent
                                    anchors.margins: 5

                                    TextApp {
                                        text: qsTr("Repeat")
                                    }//

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        ComboBoxApp {
                                            id: offRepeatDayComboBox
                                            anchors.fill: parent
                                            backgroundColor: "#0F2952"
                                            backgroundBorderColor: "#dddddd"
                                            backgroundBorderWidth: 2
                                            font.pixelSize: 20
                                            anchors.verticalCenter: parent.verticalCenter
                                            textRole: "text"
                                            popupHeight: 250

                                            model: [
                                                {text: qsTr("Once")},
                                                {text: qsTr("Everyday")},
                                                {text: qsTr("Weekdays - Monday to Friday")},
                                                {text: qsTr("Weekends - Saturday & Sunday")},
                                                {text: qsTr("Weekly - Monday")},
                                                {text: qsTr("Weekly - Tuesday")},
                                                {text: qsTr("Weekly - Wednesday")},
                                                {text: qsTr("Weekly - Thursday")},
                                                {text: qsTr("Weekly - Friday")},
                                                {text: qsTr("Weekly - Saturday")},
                                                {text: qsTr("Weekly - Sunday")},
                                            ]

                                            onActivated: {
                                                //                                        console.log("onActivated")
                                                props.offRepeatSet = index < 4 ? index : 4

                                                props.offRepeatSetStrf = model[index].text

                                                if (index >= 4) {
                                                    props.offRepeatDaySet = (index - 4) + 1;
                                                }//

                                                //setButton.visible = true
                                            }//

                                            //                                    Component.onCompleted: {
                                            //                                        let repeat = props.uvAutoSetDayRepeat
                                            //                                        let day = props.uvAutoSetWeeklyDay

                                            //                                        //////console.debug(repeat)
                                            //                                        //////console.debug(day)

                                            //                                        let index = repeat;
                                            //                                        if (repeat >= 4) {
                                            //                                            index = repeat + (day - 1)
                                            //                                        }//
                                            //                                        currentIndex = index
                                            //                                    }//
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
                            }//
                        }//

                        ButtonBarApp {
                            id: setButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            //visible: false

                            imageSource: "qrc:/UI/Pictures/checkicon.png"
                            text: qsTr("Save")

                            onClicked: {
                                if(props.parameterOnHasChanged){
                                    //console.debug("On setting")
                                    MachineAPI.setUVAutoTime(props.onTimeSet)
                                    MachineAPI.setUVAutoDayRepeat(props.onRepeatSet)
                                    MachineAPI.setUVAutoWeeklyDay(props.onRepeatDaySet)
                                    MachineAPI.setUVAutoEnabled(props.onEnableSet)

                                    const setStrf = "%1 -  %2".arg(props.onTimeSetStrf).arg(props.onRepeatSetStrf)
                                    const message = props.onEnableSet ? qsTr("User: UV On Scheduler enabled (%1)").arg(setStrf)
                                                                      : qsTr("User: UV On Scheduler disabled")
                                    MachineAPI.insertEventLog(message)
                                }
                                if(props.parameterOffHasChanged){
                                    //console.debug("Off setting")
                                    MachineAPI.setUVAutoTimeOff(props.offTimeSet)
                                    MachineAPI.setUVAutoDayRepeatOff(props.offRepeatSet)
                                    MachineAPI.setUVAutoWeeklyDayOff(props.offRepeatDaySet)
                                    MachineAPI.setUVAutoEnabledOff(props.offEnableSet)

                                    const setStrf = "%1 -  %2".arg(props.offTimeSetStrf).arg(props.offRepeatSetStrf)
                                    const message = props.offEnableSet ? qsTr("User: UV Off Scheduler enabled (%1)").arg(setStrf)
                                                                       : qsTr("User: UV Off Scheduler disabled")
                                    MachineAPI.insertEventLog(message)
                                }

                                showBusyPage(qsTr("Setting up..."), function(cycle){
                                    let valueSet = true
                                    if(props.parameterOnHasChanged){
                                        valueSet &= (MachineData.uvAutoSetTime        === props.onTimeSet
                                                     && MachineData.uvAutoSetDayRepeat=== props.onRepeatSet
                                                     && MachineData.uvAutoSetWeeklyDay=== props.onRepeatDaySet
                                                     && MachineData.uvAutoSetEnabled  === props.onEnableSet)

                                    }
                                    if(props.parameterOffHasChanged){
                                        valueSet &= (MachineData.uvAutoSetTimeOff        === props.offTimeSet
                                                     && MachineData.uvAutoSetDayRepeatOff=== props.offRepeatSet
                                                     && MachineData.uvAutoSetWeeklyDayOff=== props.offRepeatDaySet
                                                     && MachineData.uvAutoSetEnabledOff  === props.offEnableSet)

                                    }

                                    if (cycle >= MachineAPI.BUSY_CYCLE_1
                                            || valueSet){
                                        props.parameterOnHasChanged = 0
                                        props.parameterOffHasChanged = 0
                                        closeDialog();
                                    }
                                })
                            }//
                            Component.onCompleted: visible = Qt.binding(function(){return (props.parameterOnHasChanged > 0 || props.parameterOffHasChanged > 0)})
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp {
            id: utilsApp
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            //frontend variable
            property int onEnableSet:    -1
            property int onTimeSet:      0
            property int onRepeatSet:    0
            property int onRepeatDaySet: 0

            property string onTimeSetStrf:      ""
            property string onRepeatSetStrf:    ""

            onOnEnableSetChanged:   {if(onEnableSet != MachineData.uvAutoSetEnabled) parameterOnHasChanged |= 0x0001;else parameterOnHasChanged &= ~0x0001}
            onOnTimeSetChanged:     {if(onTimeSet != MachineData.uvAutoSetDayRepeat) parameterOnHasChanged |= 0x0002;else parameterOnHasChanged &= ~0x0002}
            onOnRepeatSetChanged:   {if(onRepeatSet != MachineData.uvAutoSetDayRepeat) parameterOnHasChanged |= 0x0004;else parameterOnHasChanged &= ~0x0004}
            onOnRepeatDaySetChanged:{if(onRepeatDaySet != MachineData.uvAutoSetWeeklyDay) parameterOnHasChanged |= 0x0008;else parameterOnHasChanged &= ~0x0008}

            property int offEnableSet:    -1
            property int offTimeSet:      0
            property int offRepeatSet:    0
            property int offRepeatDaySet: 0

            property string offTimeSetStrf:      ""
            property string offRepeatSetStrf:    ""

            onOffEnableSetChanged:   {if(offEnableSet != MachineData.uvAutoSetEnabledOff) parameterOffHasChanged |= 0x0001;else parameterOffHasChanged &= ~0x0001}
            onOffTimeSetChanged:     {if(offTimeSet != MachineData.uvAutoSetTimeOff) parameterOffHasChanged |= 0x0002;else parameterOffHasChanged &= ~0x0002}
            onOffRepeatSetChanged:   {if(offRepeatSet != MachineData.uvAutoSetDayRepeatOff) parameterOffHasChanged |= 0x0004;else parameterOffHasChanged &= ~0x0004}
            onOffRepeatDaySetChanged:{if(offRepeatDaySet != MachineData.uvAutoSetWeeklyDayOff) parameterOffHasChanged |= 0x0008;else parameterOffHasChanged &= ~0x0008}

            property int parameterOnHasChanged: 0
            property int parameterOffHasChanged: 0

            property int timePeriodMode: 24 //12h
            property string uvAutoTimeText: ""

            function onReturnFromTimePickerPage(returnIntent){
                finishViewReturned.disconnect(onReturnFromTimePickerPage)

                const extraData  = IntentApp.getExtraData(returnIntent)
                //                console.log(extraData)
                const pid        = extraData['pid']       || "on"
                const temp       = extraData['temp']      || 0
                if(pid === "on") props.parameterOnHasChanged = temp
                else props.parameterOffHasChanged = temp
                const set        = extraData['set']       || 0
                if(!set) return

                const hour       = extraData['hour']      || 0
                const minute     = extraData['minute']    || 0
                const period     = extraData['period']    || "AM" // AM or PM
                const periodMode = extraData['periodMode']|| 24 // 24 for 24h and 12 for 12h (AM/PM)

                //                console.log(hour + " " + minute + " "  + period + " " + periodMode)

                let minuteSchedule = utilsApp.formatClockHourMinuteToMinutes(hour, minute, period, periodMode)
                let clockSchedule = utilsApp.formatMinutesToClockHourMinuteFormat(minuteSchedule, periodMode)
                //                console.log(minuteSchedule + " - " + clockSchedule)

                if(pid === "on"){
                    onTimeText.text = clockSchedule
                    props.onTimeSet = minuteSchedule
                    props.onTimeSetStrf = clockSchedule
                }//
                else{
                    offTimeText.text = clockSchedule
                    props.offTimeSet = minuteSchedule
                    props.offTimeSetStrf = clockSchedule
                }//
            }//
        }//

        /// called Once but after onResume
        Component.onCompleted: {
            props.timePeriodMode = MachineData.timeClockPeriod

            const onMinutesSchedule = MachineData.uvAutoSetTime
            const offMinutesSchedule = MachineData.uvAutoSetTimeOff

            props.onTimeSet = onMinutesSchedule
            props.offTimeSet = offMinutesSchedule

            let onClockFromMinutes = utilsApp.formatMinutesToClockHourMinuteFormat(onMinutesSchedule, props.timePeriodMode)
            let offClockFromMinutes = utilsApp.formatMinutesToClockHourMinuteFormat(offMinutesSchedule, props.timePeriodMode)

            //            console.log("clockFromMinutes: " + clockFromMinutes)
            onTimeText.text = onClockFromMinutes
            offTimeText.text = offClockFromMinutes

            let onRepeat = MachineData.uvAutoSetDayRepeat
            let offRepeat = MachineData.uvAutoSetDayRepeatOff

            props.onRepeatSet = onRepeat
            props.offRepeatSet = offRepeat

            let onDay = MachineData.uvAutoSetWeeklyDay
            let offDay = MachineData.uvAutoSetWeeklyDayOff

            props.onRepeatDaySet = onDay
            props.offRepeatDaySet = offDay

            //                                    console.log(repeat)
            //                                    console.log(day)
            let onIndex = onRepeat;
            let offIndex = offRepeat;

            if (onRepeat >= 4) {
                onIndex = onRepeat + (onDay - 1)
            }//
            if (offRepeat >= 4) {
                offIndex = offRepeat + (offDay - 1)
            }//

            onRepeatDayComboBox.currentIndex = onIndex
            offRepeatDayComboBox.currentIndex = offIndex

            props.onEnableSet = MachineData.uvAutoSetEnabled
            props.offEnableSet = MachineData.uvAutoSetEnabledOff

            onEnableSwitch.checked = MachineData.uvAutoSetEnabled
            onEnableSwitch.initialized = true
            offEnableSwitch.checked = MachineData.uvAutoSetEnabledOff
            offEnableSwitch.initialized = true

            props.parameterOnHasChanged = 0
            props.parameterOffHasChanged = 0
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
            }//

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0
import "Dialog"

Item {
    id: control
    visible: false
    function open() {
        visible = true
    }

    function close() {
        visible = false
    }

    onVisibleChanged: {
        if (visible) opened()
        //else closed()
    }

    property bool autoClose: true
    property bool autoDestroy: false
    property int interval : 3000
    property string acceptedText: qsTr("OK")
    property string rejectedText: qsTr("Cancel")

    signal clickedAtBackground()
    signal accepted()
    signal rejected()

    signal opened()
    signal closed()

    property alias contentItem: dialogContentApp

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "black"
    }//

    MouseArea {
        anchors.fill: parent
        onClicked: {
            control.clickedAtBackground()
        }//
    }//

    DialogContentApp {
        id: dialogContentApp
        visible: control.visible
        acceptedText: control.acceptedText
        rejectedText: control.rejectedText
        onHeaderPressedAndHold: HeaderAppService.vendorLogoPressandHold()
    }//

    Loader {
        active: control.visible && control.autoClose

        sourceComponent: Timer {
            id: closeTimer
            interval: control.interval
            running: true
            onTriggered: {
                try {
                    control.visible = false
                    control.closed()
                    if(control.autoDestroy) control.destroy()
                }
                catch (e){

                }
            }//
        }//
    }//

    Component.onCompleted: {
        dialogContentApp.accepted.connect(control.accepted)
        dialogContentApp.rejected.connect(control.rejected)
        dialogContentApp.accepted.connect(function(){
            try {
                control.visible = false
                control.closed();
                if(control.autoDestroy) control.destroy()
            }
            catch (e){

            }})
        dialogContentApp.rejected.connect(function(){
            try {
                control.visible = false
                control.closed();
                if(control.autoDestroy) control.destroy()
            }
            catch (e){

            }
        })
    }//
}//

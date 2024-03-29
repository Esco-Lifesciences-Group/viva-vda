import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.3
import ModulesCpp.Machine 1.0

ComboBox {
    id: control

    font.pixelSize: 20

    property color currentTextColor: "#e3dac9"
    property color popupTextColor: "#e3dac9"

    property color colorArrow: "#e3dac9"

    property alias backgroundRadius: backgroundControl.radius
    property alias backgroundColor: backgroundControl.color
    property alias backgroundBorderColor: backgroundControl.border.color
    property alias backgroundBorderWidth: backgroundControl.border.width

    property alias backgroundPopupColor: popupBackground.color
    property alias backgroundPopupBorderColor: popupBackground.border.color

    property int popupHeight: 0

    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
            color: control.currentTextColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() {
                canvas.requestPaint()
            }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.colorArrow
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 5
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: "#e3dac9"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: backgroundControl
        implicitWidth: 120
        implicitHeight: 40
        border.color: "#e3dac9"
        border.width: control.visualFocus ? 2 : 1
        radius: 5
        color: "#404244"
    }

    popup: Popup {
        y: (control.height - 1) + ((__hwInfo__ === MachineAPI.HardwareInfo_BPI_M2_Z) ? ((control.popupHeight ? control.popupHeight
                                                                                                             : list.implicitHeight) + 2)
                                                                                     : 0)
        width: control.width
        height: control.popupHeight ? control.popupHeight
                                    : list.implicitHeight
        implicitHeight: list.implicitHeight
        padding: 1

        Page{
            rotation: ((__hwInfo__ === MachineAPI.HardwareInfo_BPI_M2_Z) ? 180 : 0)
            anchors.fill: parent

            contentItem: ListView {
                id: list
                clip: true
                implicitHeight: contentHeight
                spacing: 2
                //            model: control.popup.visible ? control.delegateModel : null
                model: control.popup.visible ? control.model : null
                currentIndex: control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}

                delegate: ItemDelegate {
                    height: control.height
                    width: control.width
                    contentItem: Text {
                        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
                        font: control.font
                        color: control.popupTextColor
                        elide: Text.ElideRight
                        opacity: pressed ? 0.5 : 1
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        //                    ////console.debug("Press")
                        control.currentIndex = index
                        control.activated(index);
                        control.popup.close()
                    }

                    background: Item {
                        anchors.fill: parent

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "#e3dac9"
                            height: 1
                            width: parent.width - 2
                        }
                    }
                }
            }

            background: Rectangle {
                id: popupBackground
                border.color: "#C0C0C0"
                radius: 5
                color: "#404244"
            }
        }

        Component.onCompleted: {
            if(__hwInfo__ === MachineAPI.HardwareInfo_BPI_M2_Z){
                x = control.width
                //console.debug("x, y", x, y)
            }
        }
    }
}

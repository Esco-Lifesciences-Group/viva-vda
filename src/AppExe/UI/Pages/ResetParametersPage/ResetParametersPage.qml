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

import ModulesCpp.Machine 1.0

import "Components" as LocalComp

ViewApp {
    id: viewApp
    title: "Reset Parameters"

    background.sourceComponent: Item {}
    //    background.sourceComponent: Rectangle {color: "gray"}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

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
                    title: qsTr("Reset Parameters")
                }//
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Grid {
                    id: resetOptionGrid
                    anchors.centerIn: parent
                    columns: 3
                    columnSpacing: 15
                    rowSpacing: 15

                    Repeater {
                        id: resetRepeater
                        model: ListModel{

                            ListElement {
                                textLable: qsTr("Reset UV Life Meter")
                                isChecked: 0
                            }

                            ListElement {
                                textLable: qsTr("Reset Field Calibration")
                                isChecked: 0
                            }

                            ListElement {
                                textLable: qsTr("Delete all User Accounts")
                                isChecked: 0
                            }
                        }

                        Rectangle {
                            height: 60
                            width: 250
                            color: "#cc0F2952"
                            border.color: "#e3dac9"
                            radius: 5
                            opacity: optionMouseArea.pressed ? 0.8 : 1

                            RowLayout {
                                anchors.fill: parent

                                Item {
                                    Layout.minimumWidth: height
                                    Layout.fillWidth: false
                                    Layout.fillHeight: true

                                    Image {
                                        anchors.fill: parent
                                        fillMode: Image.PreserveAspectFit
                                        source: "qrc:/UI/Pictures/restart-red-icon.png"
                                    }//
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        text: textLable
                                        wrapMode: Text.WordWrap
                                    }//
                                }//
                            }//

                            MouseArea {
                                id: optionMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    resetRepeater.model.setProperty(index, "isChecked",!isChecked)
                                }//
                            }//
                        }//
                    }//
                }//

                //                TextApp {
                //                    anchors.horizontalCenter: parent.horizontalCenter
                //                    anchors.bottom: parent.bottom
                //                    font.pixelSize: 16
                //                }
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
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
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

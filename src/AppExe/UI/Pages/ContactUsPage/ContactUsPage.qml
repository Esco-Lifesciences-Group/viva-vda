/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Conact Us"

    background.sourceComponent: Item {}

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
                    title: qsTr("Contact Us")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Image{
                    source: "qrc:/UI/Pictures/about/esco-group-map.png"
                    anchors.fill: parent
                }
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.minimumHeight: 200
                        Column{
                            anchors.centerIn: parent
                            spacing: 20
                            TextApp{
                                text: qsTr("We\'d love to hear from you!")
                                width: bodyItem.width
                                horizontalAlignment: Text.AlignHCenter
                                font.bold: true
                                font.pixelSize: 40
                                color: "#0F2952"
                            }
                            TextApp{
                                text: qsTr("Should you have any questions about products, features, services,") + "<br>" +
                                      qsTr("or technical support, please feel free to reach us.")
                                width: bodyItem.width
                                horizontalAlignment: Text.AlignHCenter
                                color: "#0F2952"
                                font.pixelSize: 24
                            }//
                        }//
                    }//
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5
                            Item{
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Column{
                                    anchors.centerIn: parent
                                    spacing: 5
                                    TextApp{
                                        text: "Esco Lifesciences Group Ltd."
                                        font.bold: true
                                        color: "#0F2952"
                                    }
                                    Rectangle{
                                        /// Spacer
                                        height: 10
                                        width: 1
                                        color: "transparent"
                                    }
                                    Row{
                                        spacing: 5
                                        Image{
                                            source: "qrc:/UI/Pictures/about/about-office.png"
                                        }
                                        TextApp{
                                            text: "21 Changi South Street 1" + "<br>" + "Singapore 486777"
                                            color: "#0F2952"
                                        }
                                    }
                                    Row{
                                        spacing: 5
                                        Image{
                                            source: "qrc:/UI/Pictures/about/about-telephone.png"
                                        }
                                        TextApp{
                                            text: "+65 6542 0833"
                                            color: "#0F2952"
                                        }
                                    }
                                    Row{
                                        spacing: 5
                                        Image{
                                            source: "qrc:/UI/Pictures/about/about-fax.png"
                                        }
                                        TextApp{
                                            text: "+65 6542 6920"
                                            color: "#0F2952"
                                        }
                                    }
                                    Row{
                                        spacing: 5
                                        Image{
                                            source: "qrc:/UI/Pictures/about/about-email.png"
                                        }
                                        TextApp{
                                            text: "mail@escolifesciences.com"
                                            color: "#0F2952"
                                        }
                                    }
                                    Row{
                                        spacing: 5
                                        Image{
                                            source: "qrc:/UI/Pictures/about/about-web.png"
                                        }
                                        TextApp{
                                            text: "www.escolifesciences.com"
                                            color: "#0F2952"
                                        }
                                    }
                                }
                            }//
                        }//
                    }//
                }//

                TextApp{
                    text: qsTr("About Software")
                    font.underline: true
                    color: aboutSwMA.pressed ? "#06C3FF" : "#0F2952"
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    MouseArea{
                        id: aboutSwMA
                        anchors.fill: parent
                        onClicked: {
                            const intent = IntentApp.create("qrc:/UI/Pages/SoftwareLicensePage/SoftwareLicensePage.qml", {})
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



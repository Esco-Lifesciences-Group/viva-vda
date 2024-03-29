/**
 *  Copyright (C) 2023 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Ahmad Qodri
**/

import QtQuick 2.0

QtObject {
    readonly property var profiles: [
        {
            "unit": "BSC",
            "checklist": {
                "daily":[
                    qsTr("Surface decontaminate the work zone"),
                    qsTr("LCD Cleaning and decontamination"),
                    qsTr("BSC power-up alarm verification"),
                    qsTr("Clean the sash window")
                ],
                "weekly":[
                    qsTr("Perform thorough surface decontamination on the drain pan"),
                    qsTr("Check the paper catch for retained materials"),
                    qsTr("Clean the UV lamp (if present) of any dust and dirt")
                ],
                "monthly":[
                    qsTr("Clean the BSC's exterior surface"),
                    qsTr("Check all service fixtures (if present) for proper operation"),
                ],
                "quarterly":[
                    qsTr("Inspect the BSC for any physical abnormalities or malfunction"),
                    qsTr("Clean stubborn stains on stainless steel surfaces with MEK")
                ],
                "annually":[
                    qsTr("Recertification"),
                    qsTr("Check the cabinet functionality"),
                    qsTr("Change UV Lamp (if present)"),
                    qsTr("LED lamp(s) functionality annual inspection"),
                    qsTr("Check the sash window (parts, nuts, screws, rope/belt, smooth movement)")
                ],
                "biennially":[],
                "quinquennially":[
                    qsTr("Replace sash motor (for motorized sash window)")
                ],
                "canopy":[
                    qsTr("Battery voltage is in good condition (nominal = 9V)"),
                    qsTr("The switch is working properly"),
                    qsTr("The proximity sensor can detect an object with a distance of 2-5 mm"),
                    qsTr("The LED and buzzer work properly"),
                    qsTr("The sensor distance to the flap surface is correct"),
                    qsTr("Visual and audible alarms are enabled when the flap is closed or the exhaust is low")
                ]
            }
        }
    ]
}

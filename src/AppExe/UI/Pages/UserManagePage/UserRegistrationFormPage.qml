import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.9

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import UserManageQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "User Registration"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        //visible: true

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
                    title: qsTr("User Registration")
                }
            }

            // BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    anchors.bottomMargin: 10

                    Item {
                        Layout.fillHeight: true
                        Layout.minimumWidth: 300

                        Flickable {
                            anchors.fill: parent
                            contentHeight: formColumn.height
                            contentWidth: formColumn.width
                            clip: true

                            flickableDirection: Flickable.VerticalFlick

                            Column {
                                id: formColumn
                                spacing: 5

                                Column {

                                    Row {
                                        TextApp {
                                            text: qsTr("Full Name")
                                            font.pixelSize: 14
                                        }

                                        TextApp {
                                            id: fullnameWarningText
                                            text: " | " +  qsTr("Invalid!")
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }//
                                    }

                                    TextFieldApp {
                                        id: fullnameTextField
                                        placeholderText: qsTr("Full Name")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  50

                                        property bool isValid: false

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(fullnameTextField, qsTr("Full Name"))
                                        }//

                                        onAccepted: {
                                            let newText = text
                                            if(newText.length < props.textMinimumLength || newText.length > props.textMaximumLength) {
                                                ////console.debug("true")
                                                fullnameWarningText.text = " | " +  qsTr("min/max length: %1/%2!").arg(props.textMinimumLength).arg(props.textMaximumLength)
                                                fullnameWarningText.visible = true
                                                //passwordWarningText.color = "#E20000"
                                                isValid = false
                                            }
                                            else {
                                                isValid = true
                                                fullnameWarningText.visible = false
                                            }//
                                        }//
                                    }//
                                }// full name

                                Column {

                                    Row{
                                        TextApp {
                                            text: qsTr("Username")
                                            font.pixelSize: 14
                                        }//

                                        TextApp {
                                            id: usernameWarningText
                                            text: ""
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }//
                                    }//


                                    TextFieldApp {
                                        id: usernameTextField
                                        placeholderText: qsTr("Username")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  20

                                        property bool isValid: false

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(usernameTextField, qsTr("Username"))
                                        }//

                                        onAccepted: {
                                            //                                            console.log("Hello")
                                            const pattern = /^[a-zA-Z0-9\-]+$/;
                                            const newText = text

                                            if(newText == "service" || newText == "factory" || newText == "guest"){
                                                isValid = false
                                                usernameWarningText.text = " | " +  qsTr("Invalid!")
                                                usernameWarningText.visible = true
                                                return
                                            }
                                            if(newText.length < props.textMinimumLength || newText.length > props.textMaximumLength)
                                            {
                                                ////console.debug("true")
                                                usernameWarningText.text = " | " +  qsTr("min/max length: %1/%2!").arg(props.textMinimumLength).arg(props.textMaximumLength)
                                                usernameWarningText.visible = true
                                                //usernameWarningText.color = "#E20000"
                                                isValid = false
                                            }
                                            else if(newText.match(pattern)) {
                                                //isValid = true
                                                //usernameWarningText.visible = false
                                                showBusyPage(qsTr("Please wait..."))
                                                userManageQml.checkUsernameAvailability(newText)
                                            }
                                            else {
                                                isValid = false
                                                usernameWarningText.text = " | " +  qsTr("Invalid!")
                                                usernameWarningText.visible = true
                                            }
                                        }
                                    }//
                                }// username

                                Column {

                                    Row{
                                        spacing: 3

                                        TextApp {
                                            text: qsTr("New Password")
                                            font.pixelSize: 14
                                        }//

                                        TextApp {
                                            id: passwordWarningText
                                            text: ""
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }//
                                    }//

                                    TextFieldApp {
                                        id: passwordTextField
                                        placeholderText: qsTr("Create Password")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength: 20

                                        property bool isValid: false

                                        background: Rectangle {
                                            id:rectanglePassword
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        echoMode: TextFieldApp.Password
                                        validator: RegExpValidator { regExp: /[0-9]+/ }

                                        onAccepted: {
                                            const pwdInput = passwordTextField.text
                                            const pwdLevel = props.calculatePasswordStrength(pwdInput)
                                            const meetComplexity = true // no need to check the complexity

                                            if(passwordTextField.text.length < props.passwordMinimumLength || passwordTextField.text.length > props.textMaximumLength)
                                            {
                                                ////console.debug("true")
                                                passwordWarningText.text = " | " +  qsTr("min/max length: %1/%2!").arg(props.passwordMinimumLength).arg(props.textMaximumLength)
                                                passwordWarningText.visible = true
                                                //passwordWarningText.color = "#E20000"
                                                isValid = false
                                            }
                                            else if(!meetComplexity){
                                                //                                                passwordWarningText.text = " | " +  qsTr("Must contain letters, numbers & special characters.")
                                                //                                                passwordWarningText.visible = true
                                                //passwordWarningText.color = "#E20000"
                                                isValid = false
                                            }
                                            else
                                            {
                                                ////console.debug("false")
                                                //                                                passwordWarningText.text = " | " + props.passwordStrengthString(pwdLevel)
                                                //                                                passwordWarningText.color = "#003EDD"
                                                //                                                passwordWarningText.visible = true
                                                isValid = true
                                            }
                                        }
                                        onPressed: {
                                            KeyboardOnScreenCaller.openNumpad(passwordTextField, qsTr("Create Password"))
                                        }//
                                    }//

                                }// New Password

                                Column {

                                    Row{
                                        spacing: 3

                                        TextApp {
                                            text: qsTr("Confirm Password")
                                            font.pixelSize: 14
                                        }

                                        TextApp {
                                            id:confirmPassWarningText
                                            text: " | " + qsTr("Not matched!")
                                            font.pixelSize: 14
                                            color: "orange"
                                            visible: false
                                            font.italic: true
                                        }
                                    }


                                    TextFieldApp {
                                        id: passwordConfirmTextField
                                        placeholderText: qsTr("Retype New Password")
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength: 20
                                        echoMode : TextFieldApp.Password
                                        validator: RegExpValidator { regExp: /[0-9]+/ }

                                        property bool isValid: false

                                        background: Rectangle {
                                            id: rectangleConfirmPass
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        onAccepted: {
                                            //props.calculatePasswordStrength(passwordConfirmTextField.text)
                                            if(passwordTextField.text == passwordConfirmTextField.text)
                                            {
                                                ////console.debug("true")
                                                confirmPassWarningText.visible = false
                                                isValid = true

                                            }
                                            else
                                            {
                                                ////console.debug("false")
                                                confirmPassWarningText.visible = true
                                                isValid = false
                                            }
                                        }//

                                        onPressed: {
                                            KeyboardOnScreenCaller.openNumpad(passwordConfirmTextField, qsTr("Retype Password"))
                                        }//
                                    }//

                                }// Confirm Password

                                Column {

                                    Row {
                                        spacing: 5

                                        TextApp{
                                            text: qsTr("Email")
                                            font.pixelSize: 14
                                        }//

                                        TextApp{
                                            id:textEmailWarning
                                            text: " | " + qsTr("Invalid!")
                                            font.pixelSize: 12
                                            font.italic: true
                                            color: "orange"

                                            visible: false
                                        }//
                                    }//

                                    TextFieldApp {
                                        placeholderText: "email@example.com"
                                        id: emailTextField
                                        width: 299
                                        height: 40
                                        font.pixelSize: 20
                                        maximumLength:  50

                                        property bool isValid: false

                                        background: Rectangle {
                                            id:rectangleEmail
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        //validator: RegExpValidator { regExp: /\w+([-+."]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }

                                        onAccepted: {
                                            //var mailformat = /^[a-zA-Z0-9.!#$%&"*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
                                            var mailformat = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; ///^[a-zA-Z0-9.!#$%&"*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
                                            if(emailTextField.text.match(mailformat)) {
                                                ////console.debug("true")
                                                textEmailWarning.visible = false
                                                isValid = true
                                            }
                                            else {
                                                textEmailWarning.visible = true
                                                isValid = false
                                            }
                                        }

                                        onPressed: {
                                            KeyboardOnScreenCaller.openKeyboard(emailTextField, qsTr("Email"))
                                        }//
                                    }//

                                }// email

                                Column {

                                    Row {
                                        TextApp{
                                            text: qsTr("User Level")
                                            font.pixelSize: 16
                                        }//
                                    }//

                                    ComboBoxApp {
                                        id: userLevelComboBox
                                        width: 299
                                        height: 40
                                        font.pixelSize: 18

                                        background: Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: "#0F2952"
                                            border.color: "#E3DAC9"
                                            border.width: 2
                                        }//

                                        model: [qsTr("Operator"), /*qsTr("Supervisor"),*/
                                            qsTr("Administrator")]

                                        //                                        onActivated: {
                                        //                                            console.log("onActivated", model[currentIndex])
                                        //                                        }
                                    }//
                                }// user level
                            }//
                        }//
                    }//

                    //term and Condition
                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent


                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Image {
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    source: "qrc:/UI/Pictures/microbiologist_team.png"
                                }//
                            }//

                            Item {
                                Layout.minimumHeight: 30
                                Layout.fillWidth: true

                                CheckBox {
                                    id: policyCheckBox
                                    text :qsTr("I confirm all provided data in the form.")
                                    height: parent.height
                                    font.pixelSize: 20

                                    contentItem: Text {
                                        text: policyCheckBox.text
                                        font: policyCheckBox.font
                                        opacity: enabled ? 1.0 : 0.3
                                        color: "#e3dac9"
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 40
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
                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }//
                        }//

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            enabled: policyCheckBox.checked

                            imageSource: "qrc:/UI/Pictures/add-user-iscon-35px.png"
                            text: qsTr("Submit")

                            onClicked: {
                                //                                //console.debug(fullnameTextField.isValid)
                                //                                //console.debug(usernameTextField.isValid)
                                //                                //console.debug(passwordTextField.isValid)
                                //                                //console.debug(passwordConfirmTextField.isValid)
                                //                                //console.debug(emailTextField.isValid)

                                if (!fullnameTextField.isValid
                                        || !usernameTextField.isValid
                                        || !passwordTextField.isValid
                                        || !passwordConfirmTextField.isValid
                                        || !emailTextField.isValid) {
                                    showDialogMessage(qsTr("User Registration"),
                                                      qsTr("There is an invalid value!"),
                                                      dialogAlert)
                                    return
                                }//

                                showBusyPage(qsTr("Please wait..."))
                                //const username  = usernameTextField.text
                                userManageQml.addUser(usernameTextField.text,
                                                      Qt.md5(passwordTextField.text),
                                                      userLevelComboBox.currentIndex+1 >= 2 ? userLevelComboBox.currentIndex+2
                                                                                            : userLevelComboBox.currentIndex+1,//skip supervisor
                                                      fullnameTextField.text,
                                                      emailTextField.text
                                                      )//
                                let detailStrf = usernameTextField.text + ", "
                                    + fullnameTextField.text + ", "
                                    + emailTextField.text + ", "
                                    + userLevelComboBox.model[userLevelComboBox.currentIndex]

                                MachineAPI.insertEventLog(qsTr("User: Add user account (%1)").arg(detailStrf))
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UserManageQmlApp {
            id: userManageQml

            delayEmitSignal: 500 // ms

            onInitializedChanged: {
                delayEmitSignal = 1000 //ms
                closeDialog()
            }

            onUsernameAvailabilityHasChecked: {
                //                //console.debug(success + " : " +  available + " : " + username)
                if(!success) {
                    showDialogMessage(qsTr("User Registration"), qsTr("Failed database communication. "), dialogAlert)
                    return
                }
                if(!available){
                    usernameWarningText.text = " | " +  qsTr("Username already taken!")
                    usernameTextField.isValid = false
                    usernameWarningText.visible = true
                }//
                else{
                    usernameTextField.isValid = true
                    usernameWarningText.visible = false
                }//
                closeDialog()
            }//

            onUserWasAdded: {
                //                console.log(success)
                if(!success) {
                    showDialogMessage(qsTr("User Registration"), qsTr("Failed database communication. "), dialogAlert)
                    return
                }

                showDialogMessage(qsTr("User Registration"), qsTr("User has been added successfully!"), dialogInfo,
                                  function onClosed(){
                                      var intent = IntentApp.create(uri, {"hiReload": true})
                                      finishView(intent)
                                  })
            }

            Component.onCompleted: {
                const connectionId = "UserRegistrationFormPage"
                init(connectionId);

                showBusyPage(qsTr("Loading..."), function(seconds){
                    //                    if((seconds === MachineAPI.BUSY_CYCLE_1) && (userManageQml.initialized)){
                    //                        closeDialog()
                    //                    }
                    //                    else if (seconds >= MachineAPI.BUSY_CYCLE_2){
                    //                        closeDialog()
                    //                    }
                })
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property int passwordMinimumLength: 4
            property int textMinimumLength: 4
            property int textMaximumLength: 16

            function isLowerCase(chr) {
                if (/[a-z]/.test(chr))
                    return 1
                return 0
            }
            function isUpperCase(chr) {
                if (/[A-Z]/.test(chr))
                    return 1
                return 0
            }
            function isLetter(chr){
                if (/[a-z]/i.test(chr))
                    return 1
                return 0
            }
            function isNumber(chr){
                return isNaN(chr) ? 0 : 1
            }
            function isSpecial(chr) {
                var regex = /[ ~`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g;
                return regex.test(chr) ? 1 : 0;
            }

            function calculatePasswordStrength(password){
                let passwordStr = String(password)
                let isHasUpperCase = 0
                let isHasLowerCase = 0
                let isLengthMoreEqual10Char = passwordStr.length >= 10 ? 1 : 0
                let isHasNumbers = 0
                let isHasSpecialChar = 0 ///(e.g. @#$%^&*()_+|~-=\`{}[]:";'<>/ etc)
                let allCharNotLetter = 0
                let allCharNotNumber = 0
                let mixNumberLetterCase = 0
                let index = 0
                var regexSpecial = /[ ~`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g;

                let seqNumberCount=0, seqLowCaseCount=0, seqUpCaseCount=0

                while(index < passwordStr.length){
                    let charPassword = passwordStr.charAt(index)
                    if(!isHasUpperCase) isHasUpperCase      = isUpperCase(charPassword)
                    if(!isHasLowerCase) isHasLowerCase      = isLowerCase(charPassword)
                    if(!isHasNumbers)   isHasNumbers        = isNumber(charPassword)
                    if(regexSpecial.test(charPassword)){
                        isHasSpecialChar  = 1
                    }
                    if(!allCharNotLetter)  allCharNotLetter = isLetter(charPassword) ? 0 : 1
                    if(!allCharNotNumber)  allCharNotNumber = isNumber(charPassword) ? 0 : 1

                    if(seqNumberCount<3){
                        if(isNumber(charPassword)) seqNumberCount++
                        else seqNumberCount = 0
                    }
                    if(seqLowCaseCount<3){
                        if(isLowerCase(charPassword)) seqLowCaseCount++
                        else seqLowCaseCount = 0
                    }
                    if(seqUpCaseCount<3){
                        if(isUpperCase(charPassword)) seqUpCaseCount++
                        else seqUpCaseCount = 0
                    }

                    index++
                }//

                if((seqNumberCount < 3 && seqLowCaseCount < 3 && seqUpCaseCount < 3) && allCharNotLetter && allCharNotNumber) mixNumberLetterCase = 1
                else mixNumberLetterCase = 0

                //                //console.debug("isHasUpperCase", isHasUpperCase)
                //                //console.debug("isHasLowerCase", isHasLowerCase)
                //                //console.debug("isLengthMoreEqual10Char", isLengthMoreEqual10Char)
                //                //console.debug("isHasNumbers", isHasNumbers)
                //                //console.debug("isHasSpecialChar", isHasSpecialChar)

                //                //console.debug("seqNumberCount", seqNumberCount)
                //                //console.debug("seqLowCaseCount", seqLowCaseCount)
                //                //console.debug("seqUpCaseCount", seqUpCaseCount)
                //                //console.debug("allCharNotLetter", allCharNotLetter)
                //                //console.debug("allCharNotNumber", allCharNotNumber)
                //                //console.debug("mixNumberLetterCase", mixNumberLetterCase)
                ///http://www.passwordmeter.com/
                ///very weak, weak, Good, Strong, Very Strong
                //1~6 (1 weakest ~ 6 strongest)

                let meetComplexity = ((isHasLowerCase || isHasUpperCase) && isHasNumbers && isHasSpecialChar)
                if(meetComplexity)
                    return (isHasUpperCase + isHasLowerCase + isLengthMoreEqual10Char + isHasNumbers + isHasSpecialChar + mixNumberLetterCase)
                else return 0
            }

            function passwordStrengthString(level){
                //console.debug("Password Level:", level)
                if(level >= 5)      return "Very strong"
                else if(level >= 4) return "Strong"
                else if(level >= 3) return "Good"
                else if(level >= 2) return "Weak"
                else                return "Very weak"
            }
        }//

        /// OnCreated
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

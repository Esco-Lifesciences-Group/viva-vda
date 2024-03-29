#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class ReplaceableCompRecordSql : public QObject
{
    Q_OBJECT
public:
    explicit ReplaceableCompRecordSql(QObject *parent = nullptr);
    ~ReplaceableCompRecordSql();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryDeleteOldestRowId();
    bool queryDeleteAtRowId(int descRowId);
    bool queryCount(int *count);

    QString lastQueryErrorStr() const;

    QString getParameterStringFromIndex(short value);
    short getParameterIndexFromString(const QString value);
    short getMaximumParameter()const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_ROWID,// show

        TH_UnitModel,
        TH_UnitSerialNumber,
        TH_Date,
        TH_Time,
        TH_UserManualCode,
        TH_UserManualVersion,
        TH_ElectricalPanel,
        TH_ElectricalPanelSerialNumber,
        TH_ElectricalTester,
        TH_SBCSet1Name,
        TH_SBCSet2Name,
        TH_SBCSet3Name,
        TH_SBCSet4Name,
        TH_SBCSet5Name,
        TH_SBCSet6Name,
        TH_SBCSet7Name,
        TH_SBCSet8Name,
        TH_SBCSet9Name,
        TH_SBCSet10Name,
        TH_SBCSet11Name,
        TH_SBCSet12Name,
        TH_SBCSet13Name,
        TH_SBCSet14Name,
        TH_SBCSet15Name,
        TH_SBCSet1Code,
        TH_SBCSet2Code,
        TH_SBCSet3Code,
        TH_SBCSet4Code,
        TH_SBCSet5Code,
        TH_SBCSet6Code,
        TH_SBCSet7Code,
        TH_SBCSet8Code,
        TH_SBCSet9Code,
        TH_SBCSet10Code,
        TH_SBCSet11Code,
        TH_SBCSet12Code,
        TH_SBCSet13Code,
        TH_SBCSet14Code,
        TH_SBCSet15Code,
        TH_SBCSet1Qty,
        TH_SBCSet2Qty,
        TH_SBCSet3Qty,
        TH_SBCSet4Qty,
        TH_SBCSet5Qty,
        TH_SBCSet6Qty,
        TH_SBCSet7Qty,
        TH_SBCSet8Qty,
        TH_SBCSet9Qty,
        TH_SBCSet10Qty,
        TH_SBCSet11Qty,
        TH_SBCSet12Qty,
        TH_SBCSet13Qty,
        TH_SBCSet14Qty,
        TH_SBCSet15Qty,
        TH_SBCSet1SN,
        TH_SBCSet2SN,
        TH_SBCSet3SN,
        TH_SBCSet4SN,
        TH_SBCSet5SN,
        TH_SBCSet6SN,
        TH_SBCSet7SN,
        TH_SBCSet8SN,
        TH_SBCSet9SN,
        TH_SBCSet10SN,
        TH_SBCSet11SN,
        TH_SBCSet12SN,
        TH_SBCSet13SN,
        TH_SBCSet14SN,
        TH_SBCSet15SN,
        TH_SBCSet1SW,
        TH_SBCSet2SW,
        TH_SBCSet3SW,
        TH_SBCSet4SW,
        TH_SBCSet5SW,
        TH_SBCSet6SW,
        TH_SBCSet7SW,
        TH_SBCSet8SW,
        TH_SBCSet9SW,
        TH_SBCSet10SW,
        TH_SBCSet11SW,
        TH_SBCSet12SW,
        TH_SBCSet13SW,
        TH_SBCSet14SW,
        TH_SBCSet15SW,
        TH_SBCSet1Check,
        TH_SBCSet2Check,
        TH_SBCSet3Check,
        TH_SBCSet4Check,
        TH_SBCSet5Check,
        TH_SBCSet6Check,
        TH_SBCSet7Check,
        TH_SBCSet8Check,
        TH_SBCSet9Check,
        TH_SBCSet10Check,
        TH_SBCSet11Check,
        TH_SBCSet12Check,
        TH_SBCSet13Check,
        TH_SBCSet14Check,
        TH_SBCSet15Check,
        TH_Sensor1Name,
        TH_Sensor2Name,
        TH_Sensor3Name,
        TH_Sensor4Name,
        TH_Sensor5Name,
        TH_Sensor1Code,
        TH_Sensor2Code,
        TH_Sensor3Code,
        TH_Sensor4Code,
        TH_Sensor5Code,
        TH_Sensor1Qty,
        TH_Sensor2Qty,
        TH_Sensor3Qty,
        TH_Sensor4Qty,
        TH_Sensor5Qty,
        TH_Sensor1SN,
        TH_Sensor2SN,
        TH_Sensor3SN,
        TH_Sensor4SN,
        TH_Sensor5SN,
        TH_Sensor1Const,
        TH_Sensor2Const,
        TH_Sensor3Const,
        TH_Sensor4Const,
        TH_Sensor5Const,
        TH_Sensor1Check,
        TH_Sensor2Check,
        TH_Sensor3Check,
        TH_Sensor4Check,
        TH_Sensor5Check,
        TH_UVLED1Name,
        TH_UVLED2Name,
        TH_UVLED3Name,
        TH_UVLED4Name,
        TH_UVLED5Name,
        TH_UVLED6Name,
        TH_UVLED1Code,
        TH_UVLED2Code,
        TH_UVLED3Code,
        TH_UVLED4Code,
        TH_UVLED5Code,
        TH_UVLED6Code,
        TH_UVLED1Qty,
        TH_UVLED2Qty,
        TH_UVLED3Qty,
        TH_UVLED4Qty,
        TH_UVLED5Qty,
        TH_UVLED6Qty,
        TH_UVLED1SN,
        TH_UVLED2SN,
        TH_UVLED3SN,
        TH_UVLED4SN,
        TH_UVLED5SN,
        TH_UVLED6SN,
        TH_UVLED1Check,
        TH_UVLED2Check,
        TH_UVLED3Check,
        TH_UVLED4Check,
        TH_UVLED5Check,
        TH_UVLED6Check,
        TH_PSU1Name,
        TH_PSU2Name,
        TH_PSU3Name,
        TH_PSU4Name,
        TH_PSU5Name,
        TH_PSU1Code,
        TH_PSU2Code,
        TH_PSU3Code,
        TH_PSU4Code,
        TH_PSU5Code,
        TH_PSU1Qty,
        TH_PSU2Qty,
        TH_PSU3Qty,
        TH_PSU4Qty,
        TH_PSU5Qty,
        TH_PSU1SN,
        TH_PSU2SN,
        TH_PSU3SN,
        TH_PSU4SN,
        TH_PSU5SN,
        TH_PSU1Check,
        TH_PSU2Check,
        TH_PSU3Check,
        TH_PSU4Check,
        TH_PSU5Check,
        TH_MCBEMI1Name,
        TH_MCBEMI2Name,
        TH_MCBEMI3Name,
        TH_MCBEMI4Name,
        TH_MCBEMI5Name,
        TH_MCBEMI1Code,
        TH_MCBEMI2Code,
        TH_MCBEMI3Code,
        TH_MCBEMI4Code,
        TH_MCBEMI5Code,
        TH_MCBEMI1Qty,
        TH_MCBEMI2Qty,
        TH_MCBEMI3Qty,
        TH_MCBEMI4Qty,
        TH_MCBEMI5Qty,
        TH_MCBEMI1SN,
        TH_MCBEMI2SN,
        TH_MCBEMI3SN,
        TH_MCBEMI4SN,
        TH_MCBEMI5SN,
        TH_MCBEMI1Check,
        TH_MCBEMI2Check,
        TH_MCBEMI3Check,
        TH_MCBEMI4Check,
        TH_MCBEMI5Check,
        TH_ContactSw1Name,
        TH_ContactSw2Name,
        TH_ContactSw3Name,
        TH_ContactSw4Name,
        TH_ContactSw5Name,
        TH_ContactSw1Code,
        TH_ContactSw2Code,
        TH_ContactSw3Code,
        TH_ContactSw4Code,
        TH_ContactSw5Code,
        TH_ContactSw1Qty,
        TH_ContactSw2Qty,
        TH_ContactSw3Qty,
        TH_ContactSw4Qty,
        TH_ContactSw5Qty,
        TH_ContactSw1SN,
        TH_ContactSw2SN,
        TH_ContactSw3SN,
        TH_ContactSw4SN,
        TH_ContactSw5SN,
        TH_ContactSw1Check,
        TH_ContactSw2Check,
        TH_ContactSw3Check,
        TH_ContactSw4Check,
        TH_ContactSw5Check,
        TH_BMotor1Name,
        TH_BMotor2Name,
        TH_BMotor3Name,
        TH_BMotor4Name,
        TH_BMotor5Name,
        TH_BMotor1Code,
        TH_BMotor2Code,
        TH_BMotor3Code,
        TH_BMotor4Code,
        TH_BMotor5Code,
        TH_BMotor1Qty,
        TH_BMotor2Qty,
        TH_BMotor3Qty,
        TH_BMotor4Qty,
        TH_BMotor5Qty,
        TH_BMotor1SNMotor,
        TH_BMotor2SNMotor,
        TH_BMotor3SNMotor,
        TH_BMotor4SNMotor,
        TH_BMotor5SNMotor,
        TH_BMotor1SNBlower,
        TH_BMotor2SNBlower,
        TH_BMotor3SNBlower,
        TH_BMotor4SNBlower,
        TH_BMotor5SNBlower,
        TH_BMotor1SW,
        TH_BMotor2SW,
        TH_BMotor3SW,
        TH_BMotor4SW,
        TH_BMotor5SW,
        TH_BMotor1Check,
        TH_BMotor2Check,
        TH_BMotor3Check,
        TH_BMotor4Check,
        TH_BMotor5Check,
        TH_CapInd1Name,
        TH_CapInd2Name,
        TH_CapInd3Name,
        TH_CapInd4Name,
        TH_CapInd5Name,
        TH_CapInd1Code,
        TH_CapInd2Code,
        TH_CapInd3Code,
        TH_CapInd4Code,
        TH_CapInd5Code,
        TH_CapInd1Qty,
        TH_CapInd2Qty,
        TH_CapInd3Qty,
        TH_CapInd4Qty,
        TH_CapInd5Qty,
        TH_CapInd1SN,
        TH_CapInd2SN,
        TH_CapInd3SN,
        TH_CapInd4SN,
        TH_CapInd5SN,
        TH_CapInd1Check,
        TH_CapInd2Check,
        TH_CapInd3Check,
        TH_CapInd4Check,
        TH_CapInd5Check,
        TH_Custom1Name,
        TH_Custom2Name,
        TH_Custom3Name,
        TH_Custom4Name,
        TH_Custom5Name,
        TH_Custom6Name,
        TH_Custom7Name,
        TH_Custom8Name,
        TH_Custom1Code,
        TH_Custom2Code,
        TH_Custom3Code,
        TH_Custom4Code,
        TH_Custom5Code,
        TH_Custom6Code,
        TH_Custom7Code,
        TH_Custom8Code,
        TH_Custom1Qty,
        TH_Custom2Qty,
        TH_Custom3Qty,
        TH_Custom4Qty,
        TH_Custom5Qty,
        TH_Custom6Qty,
        TH_Custom7Qty,
        TH_Custom8Qty,
        TH_Custom1SN,
        TH_Custom2SN,
        TH_Custom3SN,
        TH_Custom4SN,
        TH_Custom5SN,
        TH_Custom6SN,
        TH_Custom7SN,
        TH_Custom8SN,
        TH_Custom1Check,
        TH_Custom2Check,
        TH_Custom3Check,
        TH_Custom4Check,
        TH_Custom5Check,
        TH_Custom6Check,
        TH_Custom7Check,
        TH_Custom8Check,
        TH_Filter1Name,
        TH_Filter2Name,
        TH_Filter3Name,
        TH_Filter4Name,
        TH_Filter5Name,
        TH_Filter1Code,
        TH_Filter2Code,
        TH_Filter3Code,
        TH_Filter4Code,
        TH_Filter5Code,
        TH_Filter1Qty,
        TH_Filter2Qty,
        TH_Filter3Qty,
        TH_Filter4Qty,
        TH_Filter5Qty,
        TH_Filter1SN,
        TH_Filter2SN,
        TH_Filter3SN,
        TH_Filter4SN,
        TH_Filter5SN,
        TH_Filter1Size,
        TH_Filter2Size,
        TH_Filter3Size,
        TH_Filter4Size,
        TH_Filter5Size,
        TH_Filter1Airflow,
        TH_Filter2Airflow,
        TH_Filter3Airflow,
        TH_Filter4Airflow,
        TH_Filter5Airflow,
        TH_Filter1PD,
        TH_Filter2PD,
        TH_Filter3PD,
        TH_Filter4PD,
        TH_Filter5PD,
        TH_Filter1Check,
        TH_Filter2Check,
        TH_Filter3Check,
        TH_Filter4Check,
        TH_Filter5Check,

        /// User
        TH_UserName,// show
        TH_UserFullName,// show

        TH_Total//387
    };//

    QString m_tableHeaderString[TH_Total] = {
        "rowId",
        "unitModel",
        "unitSerialNumber",
        "date",
        "time",
        "userManualCode",
        "userManualVersion",
        "electricalPanel",
        "electricalPanelSerialNumber",
        "electricalTester",
        "sbcSet1Name",
        "sbcSet2Name",
        "sbcSet3Name",
        "sbcSet4Name",
        "sbcSet5Name",
        "sbcSet6Name",
        "sbcSet7Name",
        "sbcSet8Name",
        "sbcSet9Name",
        "sbcSet10Name",
        "sbcSet11Name",
        "sbcSet12Name",
        "sbcSet13Name",
        "sbcSet14Name",
        "sbcSet15Name",
        "sbcSet1Code",
        "sbcSet2Code",
        "sbcSet3Code",
        "sbcSet4Code",
        "sbcSet5Code",
        "sbcSet6Code",
        "sbcSet7Code",
        "sbcSet8Code",
        "sbcSet9Code",
        "sbcSet10Code",
        "sbcSet11Code",
        "sbcSet12Code",
        "sbcSet13Code",
        "sbcSet14Code",
        "sbcSet15Code",
        "sbcSet1Qty",
        "sbcSet2Qty",
        "sbcSet3Qty",
        "sbcSet4Qty",
        "sbcSet5Qty",
        "sbcSet6Qty",
        "sbcSet7Qty",
        "sbcSet8Qty",
        "sbcSet9Qty",
        "sbcSet10Qty",
        "sbcSet11Qty",
        "sbcSet12Qty",
        "sbcSet13Qty",
        "sbcSet14Qty",
        "sbcSet15Qty",
        "sbcSet1SN",
        "sbcSet2SN",
        "sbcSet3SN",
        "sbcSet4SN",
        "sbcSet5SN",
        "sbcSet6SN",
        "sbcSet7SN",
        "sbcSet8SN",
        "sbcSet9SN",
        "sbcSet10SN",
        "sbcSet11SN",
        "sbcSet12SN",
        "sbcSet13SN",
        "sbcSet14SN",
        "sbcSet15SN",
        "sbcSet1SW",
        "sbcSet2SW",
        "sbcSet3SW",
        "sbcSet4SW",
        "sbcSet5SW",
        "sbcSet6SW",
        "sbcSet7SW",
        "sbcSet8SW",
        "sbcSet9SW",
        "sbcSet10SW",
        "sbcSet11SW",
        "sbcSet12SW",
        "sbcSet13SW",
        "sbcSet14SW",
        "sbcSet15SW",
        "sbcSet1Check",
        "sbcSet2Check",
        "sbcSet3Check",
        "sbcSet4Check",
        "sbcSet5Check",
        "sbcSet6Check",
        "sbcSet7Check",
        "sbcSet8Check",
        "sbcSet9Check",
        "sbcSet10Check",
        "sbcSet11Check",
        "sbcSet12Check",
        "sbcSet13Check",
        "sbcSet14Check",
        "sbcSet15Check",
        "sensor1Name",
        "sensor2Name",
        "sensor3Name",
        "sensor4Name",
        "sensor5Name",
        "sensor1Code",
        "sensor2Code",
        "sensor3Code",
        "sensor4Code",
        "sensor5Code",
        "sensor1Qty",
        "sensor2Qty",
        "sensor3Qty",
        "sensor4Qty",
        "sensor5Qty",
        "sensor1SN",
        "sensor2SN",
        "sensor3SN",
        "sensor4SN",
        "sensor5SN",
        "sensor1Const",
        "sensor2Const",
        "sensor3Const",
        "sensor4Const",
        "sensor5Const",
        "sensor1Check",
        "sensor2Check",
        "sensor3Check",
        "sensor4Check",
        "sensor5Check",
        "uvLED1Name",
        "uvLED2Name",
        "uvLED3Name",
        "uvLED4Name",
        "uvLED5Name",
        "uvLED6Name",
        "uvLED1Code",
        "uvLED2Code",
        "uvLED3Code",
        "uvLED4Code",
        "uvLED5Code",
        "uvLED6Code",
        "uvLED1Qty",
        "uvLED2Qty",
        "uvLED3Qty",
        "uvLED4Qty",
        "uvLED5Qty",
        "uvLED6Qty",
        "uvLED1SN",
        "uvLED2SN",
        "uvLED3SN",
        "uvLED4SN",
        "uvLED5SN",
        "uvLED6SN",
        "uvLED1Check",
        "uvLED2Check",
        "uvLED3Check",
        "uvLED4Check",
        "uvLED5Check",
        "uvLED6Check",
        "psu1Name",
        "psu2Name",
        "psu3Name",
        "psu4Name",
        "psu5Name",
        "psu1Code",
        "psu2Code",
        "psu3Code",
        "psu4Code",
        "psu5Code",
        "psu1Qty",
        "psu2Qty",
        "psu3Qty",
        "psu4Qty",
        "psu5Qty",
        "psu1SN",
        "psu2SN",
        "psu3SN",
        "psu4SN",
        "psu5SN",
        "psu1Check",
        "psu2Check",
        "psu3Check",
        "psu4Check",
        "psu5Check",
        "mcbEMI1Name",
        "mcbEMI2Name",
        "mcbEMI3Name",
        "mcbEMI4Name",
        "mcbEMI5Name",
        "mcbEMI1Code",
        "mcbEMI2Code",
        "mcbEMI3Code",
        "mcbEMI4Code",
        "mcbEMI5Code",
        "mcbEMI1Qty",
        "mcbEMI2Qty",
        "mcbEMI3Qty",
        "mcbEMI4Qty",
        "mcbEMI5Qty",
        "mcbEMI1SN",
        "mcbEMI2SN",
        "mcbEMI3SN",
        "mcbEMI4SN",
        "mcbEMI5SN",
        "mcbEMI1Check",
        "mcbEMI2Check",
        "mcbEMI3Check",
        "mcbEMI4Check",
        "mcbEMI5Check",
        "contactSw1Name",
        "contactSw2Name",
        "contactSw3Name",
        "contactSw4Name",
        "contactSw5Name",
        "contactSw1Code",
        "contactSw2Code",
        "contactSw3Code",
        "contactSw4Code",
        "contactSw5Code",
        "contactSw1Qty",
        "contactSw2Qty",
        "contactSw3Qty",
        "contactSw4Qty",
        "contactSw5Qty",
        "contactSw1SN",
        "contactSw2SN",
        "contactSw3SN",
        "contactSw4SN",
        "contactSw5SN",
        "contactSw1Check",
        "contactSw2Check",
        "contactSw3Check",
        "contactSw4Check",
        "contactSw5Check",
        "bMotor1Name",
        "bMotor2Name",
        "bMotor3Name",
        "bMotor4Name",
        "bMotor5Name",
        "bMotor1Code",
        "bMotor2Code",
        "bMotor3Code",
        "bMotor4Code",
        "bMotor5Code",
        "bMotor1Qty",
        "bMotor2Qty",
        "bMotor3Qty",
        "bMotor4Qty",
        "bMotor5Qty",
        "bMotor1SNMotor",
        "bMotor2SNMotor",
        "bMotor3SNMotor",
        "bMotor4SNMotor",
        "bMotor5SNMotor",
        "bMotor1SNBlower",
        "bMotor2SNBlower",
        "bMotor3SNBlower",
        "bMotor4SNBlower",
        "bMotor5SNBlower",
        "bMotor1SW",
        "bMotor2SW",
        "bMotor3SW",
        "bMotor4SW",
        "bMotor5SW",
        "bMotor1Check",
        "bMotor2Check",
        "bMotor3Check",
        "bMotor4Check",
        "bMotor5Check",
        "capInd1Name",
        "capInd2Name",
        "capInd3Name",
        "capInd4Name",
        "capInd5Name",
        "capInd1Code",
        "capInd2Code",
        "capInd3Code",
        "capInd4Code",
        "capInd5Code",
        "capInd1Qty",
        "capInd2Qty",
        "capInd3Qty",
        "capInd4Qty",
        "capInd5Qty",
        "capInd1SN",
        "capInd2SN",
        "capInd3SN",
        "capInd4SN",
        "capInd5SN",
        "capInd1Check",
        "capInd2Check",
        "capInd3Check",
        "capInd4Check",
        "capInd5Check",
        "custom1Name",
        "custom2Name",
        "custom3Name",
        "custom4Name",
        "custom5Name",
        "custom6Name",
        "custom7Name",
        "custom8Name",
        "custom1Code",
        "custom2Code",
        "custom3Code",
        "custom4Code",
        "custom5Code",
        "custom6Code",
        "custom7Code",
        "custom8Code",
        "custom1Qty",
        "custom2Qty",
        "custom3Qty",
        "custom4Qty",
        "custom5Qty",
        "custom6Qty",
        "custom7Qty",
        "custom8Qty",
        "custom1SN",
        "custom2SN",
        "custom3SN",
        "custom4SN",
        "custom5SN",
        "custom6SN",
        "custom7SN",
        "custom8SN",
        "custom1Check",
        "custom2Check",
        "custom3Check",
        "custom4Check",
        "custom5Check",
        "custom6Check",
        "custom7Check",
        "custom8Check",
        "filter1Name",
        "filter2Name",
        "filter3Name",
        "filter4Name",
        "filter5Name",
        "filter1Code",
        "filter2Code",
        "filter3Code",
        "filter4Code",
        "filter5Code",
        "filter1Qty",
        "filter2Qty",
        "filter3Qty",
        "filter4Qty",
        "filter5Qty",
        "filter1SN",
        "filter2SN",
        "filter3SN",
        "filter4SN",
        "filter5SN",
        "filter1Size",
        "filter2Size",
        "filter3Size",
        "filter4Size",
        "filter5Size",
        "filter1Airflow",
        "filter2Airflow",
        "filter3Airflow",
        "filter4Airflow",
        "filter5Airflow",
        "filter1PD",
        "filter2PD",
        "filter3PD",
        "filter4PD",
        "filter5PD",
        "filter1Check",
        "filter2Check",
        "filter3Check",
        "filter4Check",
        "filter5Check",
        "userName",
        "userFullName"
    };//
};//


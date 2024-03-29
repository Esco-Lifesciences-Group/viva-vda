#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QJsonArray>

#include "MachineEnums.h"

class QThread;
class QTimer;
class MachineBackend;
class MachineData;

class QQmlEngine;
class QJSEngine;

class MachineProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count
               READ getCount
               NOTIFY countChanged)

    Q_ENUM(MachineEnums::EnumItemMachineState)
    Q_ENUM(MachineEnums::EnumItemSashState)
    Q_ENUM(MachineEnums::EnumItemFanState)
    Q_ENUM(MachineEnums::EnumMotorSashState)
    Q_ENUM(MachineEnums::EnumAirflowCalibState)
    Q_ENUM(MachineEnums::EnumMeasurementUnitState)
    Q_ENUM(MachineEnums::EnumOperationModeState)
    Q_ENUM(MachineEnums::EnumTempAmbientState)
    Q_ENUM(MachineEnums::EnumAlarmState)
    Q_ENUM(MachineEnums::EnumAlarmSashState)
    Q_ENUM(MachineEnums::EnumSecurityAccessState)
    Q_ENUM(MachineEnums::ExternalResourcePathCode)
    Q_ENUM(MachineEnums::GeneralPurposeEnums)
    //    Q_ENUM(MachineEnums::PreventiveMaintenance)
    Q_ENUM(MachineEnums::PreventiveMaintenanceCode)
    Q_ENUM(MachineEnums::ReplaceableTableHeaderEnums)
    Q_ENUM(MachineEnums::ScreenState)
    Q_ENUM(MachineEnums::CalibrationStateField)
    Q_ENUM(MachineEnums::CalibrationStateFactory)
    Q_ENUM(MachineEnums::ResourceMonitor)
    Q_ENUM(MachineEnums::EnumDigitalState)
    Q_ENUM(MachineEnums::FilterLifeCalculationMode)
    Q_ENUM(MachineEnums::PointCalib)
    Q_ENUM(MachineEnums::CalibrationMode)
    Q_ENUM(MachineEnums::FanSpeedController)
    Q_ENUM(MachineEnums::InflowGridPoint)
    Q_ENUM(MachineEnums::DownflowGridPoint)
    Q_ENUM(MachineEnums::CertifParamString)
    Q_ENUM(MachineEnums::CertifParamInteger)
    Q_ENUM(MachineEnums::HardwareInfo)

public:
    explicit MachineProxy(QObject *parent = nullptr);
    ~MachineProxy() override;

    static QObject *singletonProvider(QQmlEngine *qmlEngine, QJSEngine *);

    int getCount() const;

signals:

    void countChanged(int count);

public slots:
    void initSingleton();
    void setup(QObject *pData);
    void stop();

    void setMachineProfileID(const QString &value);
    /// API for general
    void setLcdTouched();

    void setLcdBrightnessLevel(short value);
    void setLcdBrightnessDelayToDimm(short value);
    void saveLcdBrightnessLevel(short value);
    void setLcdEnableLockScreen(bool value);

    void saveLanguage(const QString &value);

    void setTimeZone(const QString &value);
    void setDateTime(const QString &value);

    void saveTimeClockPeriod(short value);

    void deleteFileOnSystem(const QString &path);

    void setMuteVivariumState(short value);
    void setMuteAlarmState(short value);
    void setMuteAlarmTime(short value);
    void setMuteAlarmTimeAtFullyOpened(int value);

    void setBuzzerState(bool value);
    void setBuzzerBeep();

    void setSignedUser(const QString &username, const QString &fullname, short userLevel);
    void setUserLastLogin(const QString &username, const QString &fullname);
    void deleteUserLastLogin(const QString &username);

    /// API for Cabinet operational
    void setOperationModeSave(short value);
    void setOperationMaintenanceMode();
    void setOperationPreviousMode();

    /// API for Security Access
    void setSecurityAccessModeSave(short value);

    /// API for Certification Date Reminder
    void setDateCertificationReminder(const QString &value);

    void setMeasurementUnit(short value);

    void setSerialNumber(const QString &value);

    //// FAN
    void setFanState(short value);
    void setFanPrimaryDutyCycle(short value);
    //
    void setFanPrimaryNominalDutyCycleFactory(short value);
    void setFanPrimaryNominalRpmFactory(int value);
    void setFanPrimaryMinimumDutyCycleFactory(short value);
    void setFanPrimaryMinimumRpmFactory(int value);
    void setFanPrimaryStandbyDutyCycleFactory(short value);
    void setFanPrimaryStandbyRpmFactory(int value);
    //
    void setFanPrimaryNominalDutyCycleField(short value);
    void setFanPrimaryNominalRpmField(int value);
    void setFanPrimaryMinimumDutyCycleField(short value);
    void setFanPrimaryMinimumRpmField(int value);
    void setFanPrimaryStandbyDutyCycleField(short value);
    void setFanPrimaryStandbyRpmField(int value);

    void setLightIntensity(short lightIntensity);
    void saveLightIntensity(short lightIntensity);

    void setLightState(short lightState);

    void setSocketInstalled(short value);
    void setSocketState(short socketState);

    void setGasInstalled(short value);
    void setGasState(short gasState);

    void setUvInstalled(short value);
    void setUvState(short uvState);
    void setUvTimeSave(int minutes);

    void setWarmingUpTimeSave(short seconds);
    void setPostPurgeTimeSave(short seconds);

    void setSashMotorizeInstalled(short value);
    void setSashWindowMotorizeState(short sashMotorizeState);

    void setSeasFlapInstalled(short value);

    void setSeasBuiltInInstalled(short value);
    void setSeasPressureDiffPaLowLimit(int value);
    void setSeasPressureDiffPaOffset(int value);

    //////////
    void setAirflowMonitorEnable(bool airflowMonitorEnable);

    //INFLOW
    void setInflowSensorConstantTemporary(short value);
    //
    void setInflowSensorConstant(short value);
    void setInflowTemperatureCalib(short value, int adc);
    //
    void setInflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointFactory(int point, int value);
    void setInflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointFactory(int point, int value);
    //
    void setInflowAdcPointField(int pointZero, int pointMin, int pointNom);
    void setInflowAdcPointField(int point, int value);
    void setInflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setInflowVelocityPointField(int point, int value);
    //
    void setInflowLowLimitVelocity(short value);
    //
    void saveInflowMeaDimNominalGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    void saveInflowMeaDimMinimumGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    void saveInflowMeaDimStandbyGrid(const QJsonArray grid, int total,
                                     int average, int volume, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);
    //
    void saveInflowMeaSecNominalGrid(const QJsonArray grid, int total,
                                     int average, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);

    void saveInflowMeaSecMinimumGrid(const QJsonArray grid, int total,
                                      int average, int velocity,
                                      int ducy, int rpm,
                                     int calibMode = 0);

    void saveInflowMeaSecStandbyGrid(const QJsonArray grid, int total,
                                     int average, int velocity,
                                     int ducy, int rpm,
                                     int calibMode = 0);

    //
    //DOWNFLOW
    //    void saveDownflowSensorConstant(short ifaConstant);
    //
    //    void saveDownflowAdcPointFactory(int pointZero, int pointMin, int pointNom);
    //    void setDownflowAdcPointField(int pointZero, int pointMin, int pointNom);
    //    void setDownflowAdcPointField(int point, int value);
    void setDownflowVelocityPointFactory(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointFactory(int point, int value);
    //    void saveDownflowTemperatureFactory(short ifaTemperatureFactory, int adc);
    //
    //    void saveDownflowAdcPointField(short point, int adc);
    void setDownflowVelocityPointField(int pointZero, int pointMin, int pointNom);
    void setDownflowVelocityPointField(int point, int value);
    //    void saveDownflowTemperatureField(short value, int adc);
    //
    void saveDownflowMeaNominalGrid(const QJsonArray grid,
                                    int total,
                                    int velocity, int velocityLowest, int velocityHighest,
                                    int deviation, int deviationp,
                                    int fullField = 0);
    //
    void initAirflowCalibrationStatus(short value);
    void initFanConfigurationStatus(short value);
    void setAirflowFactoryCalibrationState(int index, bool state);
    //    void setAirflowFactorySecondaryCalibrationState(int index, bool state);
    //    void setAdcFactoryCalibrationState(int index, bool state);
    void setAirflowFieldCalibrationState(int index, bool state);

    /// DATALOG
    void setDataLogEnable(bool dataLogEnable);
    void setDataLogRunning(bool dataLogRunning);
    void setDataLogPeriod(short dataLogPeriod);
    void setDataLogCount(int dataLogCount);

    /// Resource Monitor Log
    void setResourceMonitorLogEnable(bool value);
    void setResourceMonitorLogRunning(bool value);
    void setResourceMonitorLogPeriod(short value);
    void setResourceMonitorLogCount(int value);

    ///MODBUS
    void setModbusSlaveID(short slaveId);
    void setModbusAllowingIpMaster(const QString &ipAddr);
    void setModbusAllowSetFan(bool value);
    void setModbusAllowSetLight(bool value);
    void setModbusAllowSetLightIntensity(bool value);
    void setModbusAllowSetSocket(bool value);
    void setModbusAllowSetGas(bool value);
    void setModbusAllowSetUvLight(bool value);

    /// EVENTLOG
    void insertEventLog(const QString &eventText);

    ///UV AUTO SET
    /// ON
    void setUVAutoEnabled(int uvAutoSetEnabled);
    void setUVAutoTime(int uvAutoSetTime);
    void setUVAutoDayRepeat(int uvAutoSetDayRepeat);
    void setUVAutoWeeklyDay(int uvAutoSetWeeklyDay);
    /// OFF
    void setUVAutoEnabledOff(int uvAutoSetEnabledOff);
    void setUVAutoTimeOff(int uvAutoSetTimeOff);
    void setUVAutoDayRepeatOff(int uvAutoSetDayRepeatOff);
    void setUVAutoWeeklyDayOff(int uvAutoSetWeeklyDayOff);

    /// LIGHT AUTO SET
    /// ON
    void setLightAutoEnabled(int value);
    void setLightAutoTime(int value);
    void setLightAutoDayRepeat(int value);
    void setLightAutoWeeklyDay(int value);
    /// OFF
    void setLightAutoEnabledOff(int value);
    void setLightAutoTimeOff(int value);
    void setLightAutoDayRepeatOff(int value);
    void setLightAutoWeeklyDayOff(int value);

    /// SOCKET AUTO SET
    /// ON
    void setSocketAutoEnabled(int value);
    void setSocketAutoTime(int value);
    void setSocketAutoDayRepeat(int value);
    void setSocketAutoWeeklyDay(int value);
    /// OFF
    void setSocketAutoEnabledOff(int value);
    void setSocketAutoTimeOff(int value);
    void setSocketAutoDayRepeatOff(int value);
    void setSocketAutoWeeklyDayOff(int value);

    /// FAN AUTO SET
    /// ON
    void setFanAutoEnabled(int fanAutoSetEnabled);
    void setFanAutoTime(int fanAutoSetTime);
    void setFanAutoDayRepeat(int fanAutoSetDayRepeat);
    void setFanAutoWeeklyDay(int fanAutoSetWeeklyDay);
    /// OFF
    void setFanAutoEnabledOff(int fanAutoSetEnabledOff);
    void setFanAutoTimeOff(int fanAutoSetTimeOff);
    void setFanAutoDayRepeatOff(int fanAutoSetDayRepeatOff);
    void setFanAutoWeeklyDayOff(int fanAutoSetWeeklyDayOff);

    /// ESCO LOCK SERVICE
    void setEscoLockServiceEnable(int escoLockServiceEnable);

    /// CABINET DISPLAY NAME
    void setCabinetDisplayName(const QString &cabinetDisplayName);

    /// CABINET FAN PIN
    void setFanPIN(const QString &fanPIN);

    /// FAN USAGE
    void setFanUsageMeter(int minutes);

    /// UV USAGE
    void setUvUsageMeter(int minutes);

    /// FILTER USAGE
    void setFilterUsageMeter(int minutes);
    void setFilterLifeCalculationMode       (int value);
    void setFilterLifeMinimumBlowerUsageMode (int value);
    void setFilterLifeMaximumBlowerUsageMode (int value);
    void setFilterLifeMinimumBlowerRpmMode   (int value);
    void setFilterLifeMaximumBlowerRpmMode   (int value);

    /// SASH CYCLE METER
    void setSashCycleMeter(int sashCycleMeter);

    /// Sensor Environtmental Temperature Limitation
    void setEnvTempHighestLimit(int envTempHighestLimit);
    void setEnvTempLowestLimit(int envTempLowestLimit);

    /// Particle Sensor
    void setParticleCounterSensorInstalled(bool particleCounterSensorInstalled);

    void setWatchdogResetterState(bool state);

    void refreshLogRowsCount(const QString &table);
    void reInitializeLogger(const QString &table);

    void setShippingModeEnable(bool shippingModeEnable);

    void setCurrentSystemAsKnown(bool value);

    void readSbcCurrentFullMacAddress();

    void setAlarmPreventMaintStateEnable(ushort pmCode, bool value);
    void setAlarmPreventMaintStateAck(ushort pmCode, bool value, bool snooze);
    void resetPreventMaintAckDate(ushort pmCode);
    void setAlarmPreventMaintStateRemindBefore(ushort pmCode, int value);

    ///
    void setEth0ConName(const QString &value);
    void setEth0Ipv4Address(const QString &value);
    void setEth0ConEnabled(bool value);
    void setWiredNetworkHasbeenConfigured(bool value);
    void initWiredConnectionStaticIP();

    void setSvnUpdateHasBeenApplied();
    void setSvnUpdateCheckEnable(bool value);
    void setSvnUpdateCheckPeriod(int value);
    void checkSoftwareVersionHistory();

    void setAlarmExperimentTimerIsOver(short value);

    //    void initReplaceablePartsSettings();
    void setReplaceablePartsSettings(short index, const QString &value);
    void setReplaceablePartsSelected(short descRowId);
    void setKeyboardStringOnAcceptedEvent(const QString &value);
    void resetReplaceablePartsSettings();
    void setReplaceablePartsSettingsFromSelectedRecord();

    void insertReplaceableComponentsForm();

    void requestEjectUsb(const QString &usbName);
    void setFrontEndScreenState(short value);
    void setInstallationWizardActive(bool value);

    void setSomeSettingsAfterExtConfigImported();

    void setAllOutputShutdown();

    void setFilterLifeDisplayEnabled(bool state);

    void setAirflowOutTempEnable(bool value);

    void setSensorConstCorrEnable(bool value);
    void setSensorConstCorrHighZone(int value);
    void setSensorConstCorrLowZone(int value);

    void setLogoutTime(int value);
    void setCFR21Part11Enable(bool value);

    void resetPowerFailureNotification();

    void setFanSpeedControllerBoard(short value);

    void setPropogateComposeEventGesture(bool value);

    void resetFieldSensorCalibration();

    void setFilterLifeReminderSnoozed(bool value);
    void setUvReplacementReminderSnoozed(bool value);
    void setAdvancedAirflowAlarmEnable(bool value);

    void refreshAirflowCalibrationGrid();

    void setCertificationParametersInt(short index, int value);
    void setCertificationParametersStr(short index, const QString &value);

     void refreshTodayBookingSchedule();
     void setBookedScheduleNotifEnable(bool value);
     void setBookedScheduleNotifTime(int value);
     void setBookedScheduleNotifCollapse(bool value);
     void setBookedScheduleAcknowledge(const QString &time, bool value);

     void setExperimentTimerAlwaysShow(bool value);

     void setNetworkConnectedStatus(short value);
	 
	 void setFanSpeedMaximumLimit(int value);
     void setFanSpeedFullEnable(bool value);

     void setRpExternalDatabaseEnable(bool value);
     void refreshRpExternalDatabase();
     void refreshRpExternalDefault();
     void checkValidityOfRpList();

private slots:
    void doStopping();

private:
    QScopedPointer<QTimer>          m_timerEventForMachineState;
    QScopedPointer<QThread>         m_threadForMachineState;
    QScopedPointer<MachineBackend>  m_machineBackend;

    MachineData*                    pMachineData;
    int m_count;
};


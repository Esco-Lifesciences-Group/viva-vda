#ifndef BLOWERREGALECM_H
#define BLOWERREGALECM_H

#include "../ClassDriver.h"
#include <QtSerialPort/QSerialPort>

class BlowerRegalECM : public ClassDriver
{
    Q_OBJECT
public:
    BlowerRegalECM(QObject *parent = nullptr);
    ~BlowerRegalECM();

    enum BlowerEcmDirection {
        BLOWER_REGAL_ECM_DIRECTION_CLW,
        BLOWER_REGAL_ECM_DIRECTION_CCW
    };

    enum BlowerRbmDsiDemandMode {TORQUE_DEMMAND_BRDM, AIRVOLUME_DEMMAND_BRDM};

    void setSerialComm(QSerialPort * serial);

    int getFirmwareVersion(QString &versionStr);
    int getProgramVersion(int *pversion);
    int getECMControlRev(int *ctrlrev);
    int getECMControlType(int *ctrltype);
    int getECMSerialNumber(int *serialNumber);
    int getSpeed(int *rpm);
    int getDemand(int *demand);
    int getVoltage(int *voltage);
    int getStatusByte(int *otmp, int *ramp, int *start, int *run, int *cutbk, int *stall, int *ras, int *brake);
    int getStatusAdditionalInfo(int *rbc, int *brownout, int *osc, int *reverseRotation);
    int getHistory(int *powerLevel, int *mfrMode);
    int gatShaftPower(int *shaftPower);
    int getControlTemperature(int *controlTemperature);

    int getTotalPowerTime(int* seconds);

    int getTorque(int *torque);

    int setAirflowDemand(int newVal);
    int setSpeedDemand(int newVal);
    int setTorqueDemand(int newVal);
    int setAirflowScaling(int newVal);
    int setDirection(int newVal);
    int setSlewRate(int newVal);
    int setBlowerContant(double A1, double A2, double A3, double A4);
    int setCutbackSlope(int newVal);
    int setCutbackSpeed(int newVal);
    int setBrakeOnOff(int newVal);
    int setSpeedLoopConstants(int Kp, int Ki, int Kd);
    int stop();
    int start();
    int runBlowerDemoParameter();

    int setAddressModule(uchar newVal);
    int setAddressConditional(int newVal);

    int torqueValToPercent(int newVal);
    int torquePercentToVal(int newVal);

    int airVolumeCfmToPercent(int newVal, int scale);
    int airVolumePercentToCfm(int newVal, int scale);
    void setDemandMode(unsigned char value);
    unsigned char getDemandMode() const;

private:
    QSerialPort * serialComm; //forwardPointer
    char m_protocolVersion;
    unsigned char m_demandMode = 0;
    void generateChecksum(QByteArray &byte, QByteArray& checksum);
    bool isChecksumValid(QByteArray byte);

    QByteArray intToQByte16(int newVal);

    void debugPrintCommand(const QString &title, const QByteArray &cmd);

    bool isPortValid() const;
};

#endif // BLOWERREGALECM_H

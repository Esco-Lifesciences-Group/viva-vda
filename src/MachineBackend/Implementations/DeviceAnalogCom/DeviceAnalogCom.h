#pragma once

#include <QDebug>

#include "../ClassManager.h"
#include "BoardIO/Drivers/AOmcp4725/AOmcp4725.h"

class DeviceAnalogCom : public ClassManager
{
    Q_OBJECT
public:
    explicit DeviceAnalogCom(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;

    void setSubBoard(AOmcp4725 *board);

    void setState(int state);
    int getState() const;

    void setInterlock(short interlock);
    short getInterlock() const;

    int adcMin() const;
    void setAdcMin(int adcMin);

    int adcMax() const;
    void setAdcMax(int adcMax);

    int stateMin() const;
    void setStateMin(int stateMin);

    int stateMax() const;
    void setStateMax(int stateMax);
    void setStateLimit(int value);

    int adcToState(int adc);
    int stateToAdc(int state);
    int mapToVal(int val, int inMin, int inMax, int outMin, int outMax);

    bool dummyStateEnable() const;
    void setDummyStateEnable(bool dummyStateEnable);

    short dummyState() const;
    void setDummyState(short dummyState);

    void setIdStr(QString value);

//    void setBoardAvailableStatus(bool value);

signals:
    void stateChanged(int newVal);

    void adcChanged(int newVal);

    void interlockChanged(short interlock);

private:
    AOmcp4725  *pBoard;

    int m_state;
    int m_adc;
    int m_adcRequest;

    short m_interlocked;

    int m_adcMin;
    int m_adcMax;
    int m_stateMin;
    int m_stateMax;

    int m_stateLimit = 100;

    bool m_dummyStateEnable = false;
    short m_dummyState = 0;

    QString m_idStr = "";
//    bool m_boardAvailable = false;

};


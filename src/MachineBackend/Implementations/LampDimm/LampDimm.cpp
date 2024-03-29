#include "LampDimm.h"

#define LAMP_DIMM_AO_ADC_MIN     1000
#define LAMP_DIMM_AO_ADC_MAX     4095
#define LAMP_DIMM_PERCENT_MIN    10
#define LAMP_DIMM_PERCENT_MAX    100

LampDimmManager::LampDimmManager(QObject *parent)
    : ClassManager (parent)
{
    pSubModule          = nullptr;
    m_intensity         = 0;
    m_adc               = 0;
    m_adcRequest        = 0;
}

void LampDimmManager::routineTask(int parameter)
{
    Q_UNUSED(parameter)
    int ival;
    //actual value from board
    pSubModule->getRegBufferDAC(&ival);

#ifdef QT_DEBUG
    if(m_dummyStateEnable){
        ival = intensityToAdc(m_dummyState);
    }
#endif

    //conevert ADC to percent
    if(m_adc != ival){
        m_adc = ival;
        m_intensity = adcToIntensity(m_adc);

        emit adcChanged(m_adc);
        emit intensityChanged(m_intensity);

        //        qDebug() << "LampDimmManager::m_adc " << m_adc;
        //        qDebug() << "LampDimmManager::m_intensity " << m_intensity;
    }

    //send req intensity as a adc to board
    if(m_adcRequest != m_adc){
        pSubModule->setDAC(m_adcRequest, true);

#ifdef QT_DEBUG
        if(m_dummyStateEnable){
            m_dummyState = adcToIntensity(m_adc);
        }
#endif
    }
}

void LampDimmManager::setSubModule(AOmcp4725 *obj)
{
    pSubModule = obj;
}

void LampDimmManager::setIntensity(int val)
{
    m_adcRequest = intensityToAdc(val);
    //    printf("LampDimmManager::setIntensity Val: %d - ADC: %d\n", val, m_adcRequest);
    //    fflush(stdout);
}

int LampDimmManager::adcToIntensity(int adc)
{
    //    return qRound(((float)(adc - LAMP_DIMM_AO_ADC_MIN)) * par2);
    return mapToVal(adc,
                    LAMP_DIMM_AO_ADC_MIN,
                    LAMP_DIMM_AO_ADC_MAX,
                    LAMP_DIMM_PERCENT_MIN,
                    LAMP_DIMM_PERCENT_MAX);
}

int LampDimmManager::intensityToAdc(int percent)
{
    //    return qRound(((float)(percent - LAMP_DIMM_PERCENT_MIN)) * par1);
    return mapToVal(percent,
                    LAMP_DIMM_PERCENT_MIN,
                    LAMP_DIMM_PERCENT_MAX,
                    LAMP_DIMM_AO_ADC_MIN,
                    LAMP_DIMM_AO_ADC_MAX);
}

int LampDimmManager::mapToVal(int val, int inMin, int inMax, int outMin, int outMax)
{
    if((inMax - inMin) != 0)
        return qRound(((float)(val - inMin)) * ((float)(outMax - outMin)) / ((float)(inMax - inMin))  + outMin);
    return 0;
}

short LampDimmManager::dummyState() const
{
    return m_dummyState;
}

void LampDimmManager::setDummyState(short dummyState)
{
    m_dummyState = dummyState;
}

bool LampDimmManager::dummyStateEnable() const
{
    return m_dummyStateEnable;
}

void LampDimmManager::setDummyStateEnable(bool dummyStateEnable)
{
    m_dummyStateEnable = dummyStateEnable;
}

#pragma once

enum ALARM_LOG_CODE {
    ALC_SASH_WINDOW_OK = 100,
    ALC_SASH_WINDOW_UNSAFE,
    ALC_SASH_WINDOW_FULLY_OPEN,
    ALC_SASH_WINDOW_ERROR,
    ALC_INFLOW_ALARM_OK = 200,
    ALC_INFLOW_ALARM_LOW,
    ALC_DOWNFLOW_ALARM_OK = 300,
    ALC_DOWNFLOW_ALARM_LOW,
    ALC_DOWNFLOW_ALARM_HIGH,
    ALC_SEAS_OK = 400,
    ALC_SEAS_HIGH,
    ALC_SEAS_FLAP_OK = 500,
    ALC_SEAS_FLAP_LOW,
    ALC_ENV_TEMP_OK = 600,
    ALC_ENV_TEMP_LOW,
    ALC_ENV_TEMP_HIGH,
    ALC_STB_FAN_OFF_INACTIVE = 700,
    ALC_STB_FAN_OFF_ACTIVE,
    ALC_SASH_MOTOR_OK = 800,
    ALC_SASH_MOTOR_LOCKED,
    ALC_FRONT_PANEL_OK = 900,
    ALC_FRONT_PANEL_ALARM,
    ALC_SASH_MOTOR_DOWN_STUCK_OK = 1000,
    ALC_SASH_MOTOR_DOWN_STUCK_ALARM,
	ALC_EXP_TIMER_OVER_OK = 1100,
    ALC_EXP_TIMER_OVER_ALARM,
    ALC_POWER_FAILURE_OK = 1200,
    ALC_POWER_FAILURE_ALARM,
    ALC_MODULE_OK = 1300,
    ALC_MODULE_ALARM,
};
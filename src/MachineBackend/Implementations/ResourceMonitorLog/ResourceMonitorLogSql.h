#pragma once
#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class ResourceMonitorLogSql : public QObject
{
public:
    explicit ResourceMonitorLogSql(QObject *parent = nullptr);
    ~ResourceMonitorLogSql();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    //    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryDeleteOldestRowId();
    bool queryCount(int *count);

    QString lastQueryErrorStr() const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_DATELOG,
        TH_TIMELOG,
        TH_CPU_USAGE,
        TH_MEM_USAGE,
        TH_CPU_TEMP,
        TH_SD_CARD_LIFE
    };
};

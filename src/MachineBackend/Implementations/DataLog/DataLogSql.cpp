#include "DataLogSql.h"
#include <QProcess>

#define DEFAULT_CONNECTION_NAME             "DATALOG_DB"
#define DEFAULT_DB_LOCATION                 "datalog.db"

#define DB_QUERY_INIT                       "\
CREATE TABLE IF NOT EXISTS datalog_V3 \
(date TEXT,\
 time TEXT,\
 temp TXT,\
 ifa TXT,\
 dfa TXT,\
 adcIfa INT,\
 pressure TXT,\
 fanRPM INT,\
 fanDcy INT,\
 username TXT,\
 userfullname TXT)"

#define DB_QUERY_ADD                        "INSERT INTO datalog_V3 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

#define DB_QUERY_DELETE                     "DELETE FROM datalog_V3"
#define DB_QUERY_DELETE_OLDEST_ROWID        "DELETE FROM datalog_V3 WHERE ROWID = (SELECT ROWID FROM datalog_V3 ORDER BY ROWID LIMIT 1)"
#define DB_QUERY_COUNT_ROWS                 "SELECT COUNT(*) FROM datalog_V3"

//#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_ASC        "SELECT * FROM datalog_V3 ORDER BY ROWID ASC LIMIT :limit OFFSET :offset;"
//#define DB_QUERY_SELECT_WITH_OFFSET_LIMIT_DESC       "SELECT * FROM datalog_V3 ORDER BY ROWID DESC LIMIT :limit OFFSET :offset;"

//#define DB_QUERY_SELECT                     "SELECT * FROM datalog_V3"

DataLogSql::DataLogSql(QObject *parent) : QObject(parent)
{

}

DataLogSql::~DataLogSql()
{
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool DataLogSql::init(const QString &uniqConnectionName, const QString &fileName)
{
    qDebug () << __FUNCTION__ << thread();

    m_connectionName = uniqConnectionName.isEmpty() ? DEFAULT_CONNECTION_NAME : uniqConnectionName;

    QSqlDatabase m_dataBase;
    m_dataBase = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

    QString targetLocation = fileName;
    if(fileName.isEmpty()) {
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
        targetLocation = dataPath + "/" + DEFAULT_DB_LOCATION;
        //        qDebug() << defaultTargetLocation;
    }
    m_dataBase.setDatabaseName(targetLocation);

    if(m_dataBase.open()){
        QSqlQuery query(QSqlDatabase::database(m_connectionName));
        if(query.exec(DB_QUERY_INIT)){
            return true;
        }
    }else{
        /// fix the timestamps of the file
        /// if the reason is corrupted file
#ifdef __linux__
        QProcess qprocess;
        qprocess.start("touch", QStringList() << targetLocation);
        qprocess.waitForFinished();
#endif

        /// Try to re open the database
        if(m_dataBase.open()){
            QSqlQuery query(QSqlDatabase::database(m_connectionName));
            if(query.exec(DB_QUERY_INIT)){
                return true;
            }
        }
    }
    //    qDebug() << m_dataBase.lastError().text();
    m_queryLastErrorStr = m_dataBase.lastError().text();
    return false;
}

bool DataLogSql::queryInsert(const QVariantMap data)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_ADD);
    Q_UNUSED(prepared);
    //    qDebug() << prepared;

    query.addBindValue(data["date"].toString());
    query.addBindValue(data["time"].toString());
    query.addBindValue(data["temp"].toString());
    query.addBindValue(data["ifa"].toString());
    query.addBindValue(data["dfa"].toString());
    query.addBindValue(data["adcIfa"].toInt());
    query.addBindValue(data["pressure"].toString());
    query.addBindValue(data["fanRPM"].toInt());
    query.addBindValue(data["fanDcy"].toInt());
    query.addBindValue(data["username"].toString());
    query.addBindValue(data["userfullname"].toString());

    //    qDebug() << query.lastQuery();

    if(query.exec()) {
        success = true;
    }
    //    else {
    //        //        qDebug() << "error";
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

//bool DataLogSql::querySelect(QVariantList *data, const QString &dbQueryConfig)
//{
//    qDebug () << __FUNCTION__ << thread();

//    QSqlQuery query(QSqlDatabase::database(m_connectionName));

//    QString statement(DB_QUERY_SELECT);
//    statement.append(dbQueryConfig);
//    bool prepared = query.prepare(statement);
//    Q_UNUSED(prepared)
//    //    qDebug() << prepared << query.lastQuery();

//    bool success = false;
//    if(query.exec()){
//        success = true;
//        while(query.next()){
//            QVariantList dataItem;

//            dataItem.push_back(query.value(TableHeaderEnum::TH_DATELOG));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_TIMELOG));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_TEMP));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_IFA));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_DFA));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_ADC_IFA));
//            dataItem.push_back(query.value(TableHeaderEnum::TH_FAN_RPM));

//            data->push_back(dataItem);
//        }
//    }
//    //    else{
//    //        qWarning() << __func__ << query.lastError().text();
//    //    }
//    m_queryLastErrorStr = query.lastError().text();
//    return success;
//}

bool DataLogSql::queryDelete(const QString &dbQueryConfig)
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE);
    statement.append(dbQueryConfig);
    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    //    else{
    //        qWarning() << __func__  << query.lastError();
    //    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool DataLogSql::queryDeleteOldestRowId()
{
    qDebug () << __FUNCTION__ << thread();

    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    QString statement(DB_QUERY_DELETE_OLDEST_ROWID);

    qDebug() << statement;

    bool prepared = query.prepare(statement);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
    }
    else{
        qWarning() << __func__  << query.lastError();
    }
    qDebug() << success;
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

bool DataLogSql::queryCount(int *count)
{
    bool success = false;

    QSqlQuery query(QSqlDatabase::database(m_connectionName));

    bool prepared = query.prepare(DB_QUERY_COUNT_ROWS);
    Q_UNUSED(prepared)

    if(query.exec()){
        success = true;
        query.next();
        *count = query.value(0).toInt();
    }
    m_queryLastErrorStr = query.lastError().text();
    return success;
}

QString DataLogSql::lastQueryErrorStr() const
{
    return m_queryLastErrorStr;
}

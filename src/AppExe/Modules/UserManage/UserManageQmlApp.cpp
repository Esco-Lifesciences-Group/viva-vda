#include "UserManageQmlApp.h"
#include <QThread>
#include <QEventLoop>
#include <QDate>
#include <QCryptographicHash>

UserManageQmlApp::UserManageQmlApp(QObject *parent) : QObject(parent)
{

}

bool UserManageQmlApp::getInitialized() const
{
    return m_initialized;
}

void UserManageQmlApp::setInitialized(bool initialized)
{
    if (m_initialized == initialized)
        return;

    m_initialized = initialized;
    emit initializedChanged(m_initialized);
}

bool UserManageQmlApp::getLastQueryError() const
{
    return m_lastQueryError;
}

void UserManageQmlApp::init(const QString &uniqConnectionName, const QString &fileName)
{
    // sanity check dont allow to double created the instance
    if (m_pThread != nullptr) return;

    m_pThread = QThread::create([&, uniqConnectionName, fileName](){
        //        qDebug() << "m_pThread::create" << thread();

        //        m_pSql = new UserManageSql();
        m_pSql.reset(new UserManageSql());
        bool initialized = m_pSql->init(uniqConnectionName, fileName);

        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);

        setInitialized(initialized);

        QEventLoop loop;
        //        connect(this, &UserManageSql::destroyed, &loop, &QEventLoop::quit);
        loop.exec();

        //        qDebug() << "m_pThread::end";
    });

    //// Tells the thread's event loop to exit with return code 0 (success).
    connect(this, &UserManageQmlApp::destroyed, m_pThread, &QThread::quit);
    //    connect(m_pThread, &QThread::finished, m_pThread, [&](){
    //        qDebug() << "Thread has finished";
    //    });
    connect(m_pThread, &QThread::finished, m_pThread, &QThread::deleteLater);
    //    connect(m_pThread, &QThread::destroyed, m_pThread, [&](){
    //        qDebug() << "Thread will destroying";
    //    });
    m_pThread->start();
}

void UserManageQmlApp::initDefaultUserAccount()
{
    //    QMetaObject::invokeMethod(m_pSql, [&](){
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&](){
        //        qDebug() << __func__ << thread();

        QString options = QString(" WHERE username='super'");
        QString options1 = QString(" WHERE username='admin'");
        QString options2 = QString(" WHERE username='operator'");

        QVariantList dataBuffer, dataBuffer1, dataBuffer2;
        int statusCreation = 0;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        m_pSql->querySelect(&dataBuffer1, options1);
        m_pSql->querySelect(&dataBuffer2, options2);

        bool adminExist = dataBuffer1.length() > 0;
        bool operatorExist = dataBuffer2.length() > 0;

        setLastQueryError(!done);

        if(done) {
            if (!dataBuffer.length()) {
                /// no super admin yet, let's create new
                QVariantMap data;

                /// Create super admin
                data.clear();
                QString password = QString(QCryptographicHash::hash("0005", QCryptographicHash::Md5).toHex());
                data.insert("username", "super");
                data.insert("password", password);
                data.insert("role",     USER_LEVEL_SUPERADMIN);
                data.insert("active",   1);
                data.insert("fullname", "Super Administrator");
                data.insert("email",    "superadmin@mail.com");
                data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                done = m_pSql->queryInsert(data);

                if(!adminExist){
                    data.clear();
                    password = QString(QCryptographicHash::hash("0001", QCryptographicHash::Md5).toHex());
                    data.insert("username", "admin");
                    data.insert("password", password);
                    data.insert("role",     USER_LEVEL_ADMIN);
                    data.insert("active",   1);
                    data.insert("fullname", "Administrator");
                    data.insert("email",    "admin@mail.com");
                    data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                    done = m_pSql->queryInsert(data);
                }//

                //                data.clear();
                //                password = QString(QCryptographicHash::hash("0001", QCryptographicHash::Md5).toHex());
                //                data.insert("username", "supervisor");
                //                data.insert("password", password);
                //                data.insert("role",     USER_LEVEL_SUPERVISOR);
                //                data.insert("active",   1);
                //                data.insert("fullname", "Supervisor");
                //                data.insert("email",    "supervisor@mail.com");
                //                data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                //                done = m_pSql->queryInsert(data);

                if(!operatorExist){
                    /// Create operator
                    data.clear();
                    password = QString(QCryptographicHash::hash("0000", QCryptographicHash::Md5).toHex());
                    data.insert("username", "operator");
                    data.insert("password", password);
                    data.insert("role",     USER_LEVEL_OPERATOR);
                    data.insert("active",   1);
                    data.insert("fullname", "Operator");
                    data.insert("email",    "operator@mail.com");
                    data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

                    done = m_pSql->queryInsert(data);
                }//


                setLastQueryError(!done);
                if(!done) {
                    qWarning() << m_pSql->lastQueryErrorStr();
                }
                else {
                    statusCreation = 1; // create new
                }
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        emit superAdminHasInitialized(done, statusCreation);
    });
}

void UserManageQmlApp::addUser(const QString username,
                               const QString password,
                               int role,
                               const QString fullName,
                               const QString email)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, password, role, fullName, email](){
        //        qDebug() << __func__ << thread();

        QVariantMap data;
        data.insert("username", username);
        data.insert("password", password);
        data.insert("role",     role);
        data.insert("active",   1);
        data.insert("fullname", fullName);
        data.insert("email",    email);
        data.insert("createdAt", QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss"));

        bool done = m_pSql->queryInsert(data);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userWasAdded(done, fullName);
    });

}

void UserManageQmlApp::updateUserExcludePassword(const QString username,
                                                 int role,
                                                 const QString fullName,
                                                 const QString email)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, role, fullName, email](){
        qDebug() << __func__ << thread();

        bool done = true;
        done &= m_pSql->queryUpdateUserRole(role, username);
        qDebug() << done;
        done &= m_pSql->queryUpdateUserFullname(fullName, username);
        qDebug() << done;
        done &= m_pSql->queryUpdateUserEmail(email, username);
        qDebug() << done;

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userUpdatedExcludePassword(done, username);
        emit userUpdated(done, username);
    });
}

void UserManageQmlApp::updateUserIncludePassword(const QString username, const QString newUsername,
                                                 const QString password,
                                                 int role,
                                                 const QString fullName,
                                                 const QString email)
{
    qDebug() << __FUNCTION__ << username << newUsername << password << role << fullName << email;

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username, newUsername, password, role, fullName, email](){
        qDebug() << __func__ << thread();


        bool done = true;
        done &= m_pSql->queryUpdateUserPassword(password, username);
        done &= m_pSql->queryUpdateUserRole(role, username);
        done &= m_pSql->queryUpdateUserFullname(fullName, username);
        done &= m_pSql->queryUpdateUserEmail(email, username);
        if(username != newUsername)
            done &= m_pSql->queryUpdateUserUsername(newUsername, username);

        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userUpdatedIncludePassword(done, username);
        emit userUpdated(done, username);
    });
}

void UserManageQmlApp::selectDescendingWithPagination(short limit, short pageNumber)
{
    qDebug() << __func__ << limit << pageNumber << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, limit, pageNumber](){
        qDebug() << __func__ << thread();

        int count = 0;
        m_pSql->queryCount(&count);

        short offset = (limit * pageNumber) - limit;
        QString options = QString().asprintf(" ORDER BY ROWID DESC LIMIT %d OFFSET %d", limit, offset);

        QVariantList dataBuffer, dataReady;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantMap item;
            QVariantList itemTemp;
            for(int i=0; i < dataBuffer.length(); i++){
                item.clear();
                itemTemp.clear();

                itemTemp = dataBuffer.at(i).toList();
                //                qDebug() << itemTemp.length();

                item.insert("username", itemTemp.at(TH_USERNAME));
                item.insert("password", itemTemp.at(TH_PASSWORD));
                item.insert("role",     itemTemp.at(TH_ROLE));
                item.insert("active",   itemTemp.at(TH_ACTIVE));
                item.insert("fullname", itemTemp.at(TH_FULLNAME));
                item.insert("email",    itemTemp.at(TH_EMAIL));
                item.insert("createdAt",itemTemp.at(TH_CREATED_AT));
                item.insert("lastLogin",itemTemp.at(TH_LAST_LOGIN));

                dataReady.append(item);
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit selectHasDone(done, dataReady, count);
    });
}

void UserManageQmlApp::selectUserByUsername(const QString username)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();

        int count = 0;
        m_pSql->queryCount(&count);

        QString options = QString(" WHERE username='%1'").arg(username);

        QVariantList dataBuffer;
        QVariantMap item;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(done) {
            /// Reconstructing every item to JSON/VariantMaplist
            /// so, QML Listview ease to present the data
            QVariantList itemTemp;
            if(dataBuffer.length() > 0){

                itemTemp = dataBuffer.at(0).toList();
                //                qDebug() << itemTemp.length();

                item.insert("username", itemTemp.at(TH_USERNAME));
                item.insert("password", itemTemp.at(TH_PASSWORD));
                item.insert("role",     itemTemp.at(TH_ROLE));
                item.insert("active",   itemTemp.at(TH_ACTIVE));
                item.insert("fullname", itemTemp.at(TH_FULLNAME));
                item.insert("email",    itemTemp.at(TH_EMAIL));
                item.insert("createdAt",itemTemp.at(TH_CREATED_AT));
                item.insert("lastLogin",itemTemp.at(TH_LAST_LOGIN));
            }
        }
        else {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit userSelectedByUsernameHasExecuted(done, dataBuffer.length(), item);
    });
}

void UserManageQmlApp::deleteByUsername(const QString username)
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();

        QString options = QString(" WHERE username='%1'").arg(username);
        bool done = m_pSql->queryDelete(options);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void UserManageQmlApp::deleteAll()
{
    qDebug() << __func__ << thread();

    QMetaObject::invokeMethod(m_pSql.data(),
                              [&](){
        qDebug() << __func__ << thread();

        bool done = m_pSql->queryDelete();
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// get the total rows after delete
        int count = 0;
        m_pSql->queryCount(&count);

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit deleteHasDone(done, count);
    });
}

void UserManageQmlApp::checkUsernameAvailability(const QString username)
{
    QMetaObject::invokeMethod(m_pSql.data(),
                              [&, username](){
        qDebug() << __func__ << thread();


        QString options = QString(" WHERE username='%1'").arg(username);

        QVariantList dataBuffer;
        bool done = m_pSql->querySelect(&dataBuffer, options);
        setLastQueryError(!done);
        if(!done) {
            qWarning() << m_pSql->lastQueryErrorStr();
        }

        /// give some dalay to make ui more interactive
        if(m_delayEmitSignal>0) QThread::msleep(m_delayEmitSignal);
        emit usernameAvailabilityHasChecked(done, dataBuffer.length() == 0, username);
    });
}

void UserManageQmlApp::setLastQueryError(bool lastQueryError)
{
    if (m_lastQueryError == lastQueryError)
        return;

    m_lastQueryError = lastQueryError;
    emit lastQueryErrorChanged(m_lastQueryError);
}

int UserManageQmlApp::getDelayEmitSignal() const
{
    return m_delayEmitSignal;
}

void UserManageQmlApp::setDelayEmitSignal(int delayEmitSignal)
{
    m_delayEmitSignal = delayEmitSignal;
}

#include "FileDirUtils.h"
#include <QDir>
#include <QFileInfo>
#include <QUrl>
#include <QDebug>
#include <QStandardPaths>

FileDirUtils::FileDirUtils(QObject *parent) : QObject(parent)
{

}

bool FileDirUtils::getBussy() const
{
    return m_bussy;
}

bool FileDirUtils::link(const QString &source, const QString &target)
{
    return QFile::link(source, target);
}

bool FileDirUtils::clearDir(const QString &path)
{
    bool allAreDeleted = false;

    QDir dir(path);

    if (dir.isEmpty()) return true;

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    for (QString dirItem : dir.entryList()) {
        allAreDeleted = dir.remove(dirItem);
    }

    dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    for (QString dirItem: dir.entryList()){
        QDir subDir(dir.absoluteFilePath(dirItem));
        allAreDeleted = subDir.removeRecursively();
    }

    return allAreDeleted;
}

bool FileDirUtils::isExist(const QString &path)
{
    //    qDebug() << path;
    return QFileInfo::exists(path);
}

void FileDirUtils::clearDirAsync(const QString &path)
{
    if(!m_thread.isNull()) if(m_thread->isRunning()) return;

    m_thread.reset(QThread::create([=]{

        //        qDebug() << __FUNCTION__ << QThread::currentThreadId();
        //        QThread::sleep(5);

        bool areItemDeleted = clearDir(path);
        emit clearDirFinished(areItemDeleted);

    }));

    QObject::connect(m_thread.data(), &QThread::started, [=]{
        setBussy(true);
    });
    QObject::connect(m_thread.data(), &QThread::finished, [=]{
        setBussy(false);
    });
    //    QObject::connect(m_thread.data(), &QThread::finished, [=]{
    //        qDebug() << "m_thread has finished";
    //    });
    //    QObject::connect(m_thread.data(), &QThread::destroyed, [=]{
    //        qDebug() << "m_thread will destroyed";
    //    });

    m_thread->start();
}

void FileDirUtils::setBussy(bool bussy)
{
    if (m_bussy == bussy)
        return;

    m_bussy = bussy;
    emit bussyChanged(m_bussy);
}

void FileDirUtils::mkpath(const QString &path)
{
    //qDebug() << path << QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir dir(path);
    if(!dir.exists()){
        if(dir.mkpath("."))
            qDebug() << path << "is not exits!, created new!";
        else
            qDebug() << "failed to create a directory!";
    }else{
        qDebug() << path << "is exits!";
    }
}

void FileDirUtils::initAvailableFileOnDir(const QString &path)
{
    short count = 0;
    QStringList strList = QStringList();

    QDir dir(path);

    if (!dir.isEmpty()){

        dir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
        for (QString dirItem : dir.entryList()) {
            //allAreDeleted = dir.remove(dirItem);
            count++;
            strList << dirItem;
        }//

        qDebug() << strList;
        //        dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
        //        for (QString dirItem: dir.entryList()){
        //            QDir subDir(dir.absoluteFilePath(dirItem));
        //            allAreDeleted = subDir.removeRecursively();
        //        }
    }//

    emit availableFilesOnDir(count, strList);
}

QString FileDirUtils::qurlToLocalFile(const QString urlString)
{
    const QUrl url(urlString);
    return url.toLocalFile();
}

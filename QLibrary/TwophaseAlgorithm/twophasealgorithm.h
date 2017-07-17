#ifndef TWOPHASEALGORITHM_H
#define TWOPHASEALGORITHM_H

#include <QObject>
#include <QtConcurrent/QtConcurrentRun>
#include <QFuture>
#include <QFutureWatcher>
#include <QTime>

#include "androidtwophase.h"

class TwophaseAlgorithm : public QObject
{
    Q_OBJECT

public:
    explicit TwophaseAlgorithm(QObject *parent = 0);
    ~TwophaseAlgorithm();

    Q_INVOKABLE void initTables();
    Q_INVOKABLE void solveCube(const QString &facelets, const int &maxDepth, const int &timeOut, const int &timeMin);
    Q_INVOKABLE void verifyCube(const QString &facelets);

signals:
    void tablesInitialized(const int &msecs);
    void cubeSolved(const QString &solution, const int &msecs);
    void cubeVerified(const int &result);

private slots:
    void watcherTablesInitialized();
    void watcherCubeSolved();
    void watcherCubeVerified();

private:
    AndroidTwophase *m_twophase;
    QTime m_solveTimer;
    QTime m_initTimer;

    QFuture<void> *m_initTablesFuture;
    QFutureWatcher<void> *m_initTablesWatcher;

    QFuture<QString> *m_solveCubeFuture;
    QFutureWatcher<QString> *m_solveCubeWatcher;

    QFuture<int> *m_verifyCubeFuture;
    QFutureWatcher<int> *m_verifyCubeWatcher;
};

#endif // TWOPHASEALGORITHM_H

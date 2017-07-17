#include "twophasealgorithm.h"
#include <QDebug>

TwophaseAlgorithm::TwophaseAlgorithm(QObject *parent) :
    QObject(parent)
{
    m_twophase = new AndroidTwophase();

    m_initTablesFuture = new QFuture<void>;
    m_initTablesWatcher = new QFutureWatcher<void>;
    connect(m_initTablesWatcher, SIGNAL(finished()),
            this, SLOT(watcherTablesInitialized()));

    m_solveCubeFuture = new QFuture<QString>;
    m_solveCubeWatcher = new QFutureWatcher<QString>;
    connect(m_solveCubeWatcher, SIGNAL(finished()),
               this, SLOT(watcherCubeSolved()));

    m_verifyCubeFuture = new QFuture<int>;
    m_verifyCubeWatcher = new QFutureWatcher<int>;
    connect(m_verifyCubeWatcher, SIGNAL(finished()),
               this, SLOT(watcherCubeVerified()));
}

TwophaseAlgorithm::~TwophaseAlgorithm()
{
    if(m_twophase != 0)
        delete m_twophase;

    if(m_solveCubeFuture != 0)
        delete m_solveCubeFuture;
    if(m_solveCubeWatcher != 0)
        delete m_solveCubeWatcher;

    if(m_solveCubeFuture != 0)
        delete m_solveCubeFuture;
    if(m_initTablesWatcher != 0)
        delete m_initTablesWatcher;

    if(m_verifyCubeFuture != 0)
        delete m_verifyCubeFuture;
    if(m_verifyCubeWatcher != 0)
        delete m_verifyCubeWatcher;
}

void TwophaseAlgorithm::initTables()
{
    m_initTimer.restart();
    *m_initTablesFuture = QtConcurrent::run(this->m_twophase, &AndroidTwophase::initTables);
    m_initTablesWatcher->setFuture(*m_initTablesFuture);
}

void TwophaseAlgorithm::solveCube(const QString &facelets, const int &maxDepth, const int &timeOut, const int &timeMin)
{
    m_solveTimer.restart();
    *m_solveCubeFuture = QtConcurrent::run(this->m_twophase, &AndroidTwophase::solveCube, facelets, maxDepth, timeOut, timeMin);
    m_solveCubeWatcher->setFuture(*m_solveCubeFuture);
}

void TwophaseAlgorithm::verifyCube(const QString &facelets)
{
    *m_verifyCubeFuture = QtConcurrent::run(this->m_twophase, &AndroidTwophase::verifyCube, facelets);
    m_verifyCubeWatcher->setFuture(*m_verifyCubeFuture);
}

void TwophaseAlgorithm::watcherTablesInitialized()
{
    int msecs = m_initTimer.elapsed();
    emit tablesInitialized(msecs);
}

void TwophaseAlgorithm::watcherCubeSolved()
{
    int msecs = m_solveTimer.elapsed();
    QString solution = m_solveCubeFuture->result();
    emit cubeSolved(solution, msecs);
}

void TwophaseAlgorithm::watcherCubeVerified()
{
    int result = m_verifyCubeFuture->result();
    emit cubeVerified(result);
}



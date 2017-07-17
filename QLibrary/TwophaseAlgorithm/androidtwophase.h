#ifndef ANDROIDTWOPHASE_H
#define ANDROIDTWOPHASE_H

#include <jni.h>

class AndroidTwophase
{
public:
    AndroidTwophase();
    ~AndroidTwophase();

    void initTables();
    QString solveCube(const QString &facelets, const int &maxDepth, const int &timeOut, const int &timeMin) const;
    int verifyCube(const QString &facelets) const;

private:
    jobject m_twophaseObject;
};

#endif // ANDROIDTWOPHASE_H

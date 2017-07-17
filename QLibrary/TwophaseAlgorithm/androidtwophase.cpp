#include <QDebug>

#include "androidtwophase.h"

static JavaVM* s_javaVM = 0;
static jclass s_androidTwophaseClassID = 0;
static jmethodID s_androidTwophaseConstructorMethodID = 0;
static jmethodID s_androidTwophaseSolveCubeMethodID = 0;
static jmethodID s_androidTwophaseVerifyCubeMethodID = 0;
static jmethodID s_androidTwophaseInitTablesMethodID = 0;
static jmethodID s_androidTwophaseReleaseMethodID = 0;

AndroidTwophase::AndroidTwophase()
{
    JNIEnv* env;
    // Qt is running in a different thread than Java UI, so you always Java VM *MUST* be attached to current thread
    if (s_javaVM->AttachCurrentThread(&env, NULL)<0)
    {
        qCritical()<<"AttachCurrentThread failed";
        return;
    }

    // Create a new instance of QSimpleAudioPlayer
    m_twophaseObject = env->NewGlobalRef(env->NewObject(s_androidTwophaseClassID, s_androidTwophaseConstructorMethodID));
    if (!m_twophaseObject)
    {
        qCritical()<<"Can't create twophase";
        return;
    }

    // Don't forget to detach from current thread
    s_javaVM->DetachCurrentThread();
}

AndroidTwophase::~AndroidTwophase()
{
    if (!m_twophaseObject)
        return;

    JNIEnv* env;
    if (s_javaVM->AttachCurrentThread(&env, NULL)<0)
    {
        qCritical()<<"AttachCurrentThread failed";
        return;
    }

    if (!env->CallBooleanMethod(m_twophaseObject, s_androidTwophaseReleaseMethodID))
        qCritical()<<"Releasing twophase object failed";

    s_javaVM->DetachCurrentThread();
}

QString AndroidTwophase::solveCube(const QString &facelets, const int &maxDepth, const int &timeOut, const int &timeMin) const
{
    if (!m_twophaseObject)
        return "No Twophase Object";

    JNIEnv* env;
    if (s_javaVM->AttachCurrentThread(&env, NULL)<0)
    {
        qCritical()<<"AttachCurrentThread failed";
        return "AttachCurrentThread failed";
    }
    jstring str_facelets = env->NewString(reinterpret_cast<const jchar*>(facelets.constData()), facelets.length());

    jstring ret = (jstring) env->CallObjectMethod(m_twophaseObject, s_androidTwophaseSolveCubeMethodID, str_facelets, (jint) maxDepth, (jint) timeOut, (jint) timeMin);
    const char *js = env->GetStringUTFChars(ret, NULL);
    std::string cs(js);
    env->ReleaseStringUTFChars(ret, js);
    QString solution = QString::fromStdString(cs);

    env->DeleteLocalRef(str_facelets);
    s_javaVM->DetachCurrentThread();
    return solution;
}

int AndroidTwophase::verifyCube(const QString &facelets) const
{
    if (!m_twophaseObject)
        return -1;

    JNIEnv* env;
    if (s_javaVM->AttachCurrentThread(&env, NULL)<0)
    {
        qCritical()<<"AttachCurrentThread failed";
        return -1;
    }
    jstring str_facelets = env->NewString(reinterpret_cast<const jchar*>(facelets.constData()), facelets.length());

    jint verifyRet = (jint) env->CallIntMethod(m_twophaseObject, s_androidTwophaseVerifyCubeMethodID, str_facelets);

    env->DeleteLocalRef(str_facelets);
    s_javaVM->DetachCurrentThread();
    return verifyRet;
}

void AndroidTwophase::initTables()
{
    if (!m_twophaseObject)
        return;

    JNIEnv* env;
    if (s_javaVM->AttachCurrentThread(&env, NULL)<0)
    {
        qCritical()<<"AttachCurrentThread failed";
        return;
    }
    env->CallBooleanMethod(m_twophaseObject, s_androidTwophaseInitTablesMethodID);
    s_javaVM->DetachCurrentThread();
}


// this method is called immediately after the module is load
JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
{
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
        qCritical()<<"Can't get the enviroument";
        return -1;
    }

    s_javaVM = vm;
    // search for our class
    jclass clazz=env->FindClass("cs/min2phaseWrapper/SimpleTwophaseWrapper");
    if (!clazz)
    {
        qCritical()<<"Can't find SimpleTwophaseWrapper class";
        return -1;
    }
    // keep a global reference to it
    s_androidTwophaseClassID = (jclass)env->NewGlobalRef(clazz);

    // search for its contructor
    s_androidTwophaseConstructorMethodID = env->GetMethodID(s_androidTwophaseClassID, "<init>", "()V");
    if (!s_androidTwophaseConstructorMethodID)
    {
        qCritical()<<"Can't find SimpleTwophaseWrapper class contructor";
        return -1;
    }

    // search for SolveCube method
    s_androidTwophaseSolveCubeMethodID = env->GetMethodID(s_androidTwophaseClassID, "SolveCube", "(Ljava/lang/String;III)Ljava/lang/String;");
    if (!s_androidTwophaseSolveCubeMethodID)
    {
        qCritical()<<"Can't find SolveCube method";
        return -1;
    }

    // search for VerifyCube method
    s_androidTwophaseVerifyCubeMethodID = env->GetMethodID(s_androidTwophaseClassID, "VerifyCube", "(Ljava/lang/String;)I");
    if (!s_androidTwophaseVerifyCubeMethodID)
    {
        qCritical()<<"Can't find VerifyCube method";
        return -1;
    }

    // search for InitTables method
    s_androidTwophaseInitTablesMethodID = env->GetMethodID(s_androidTwophaseClassID, "InitTables", "()V");
    if (!s_androidTwophaseInitTablesMethodID)
    {
        qCritical()<<"Can't find InitTables method";
        return -1;
    }

    return JNI_VERSION_1_6;
}

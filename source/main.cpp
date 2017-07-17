#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QCamera>
#include <QDebug>

#include "imageprocessor.h"

#include "../QLibrary/BluetoothClient/bluetoothclient.h"
#include "../QLibrary/QImageItem/qimageitem.h"
#include "../QLibrary/TwophaseAlgorithm/twophasealgorithm.h"


AndroidTwophase *g_twophase;

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // De-comment this to trace all imports
    /*QByteArray data = "1";
    qputenv("QML_IMPORT_TRACE", data);*/

    qmlRegisterType<BluetoothClient>("CubeSolverApp", 1, 0, "BluetoothClient");
    qmlRegisterType<QImageItem>("CubeSolverApp", 1, 0, "QImageItem");
    qmlRegisterType<TwophaseAlgorithm>("CubeSolverApp", 1, 0, "TwophaseAlgorithm");


    QQmlApplicationEngine engine;


    /*qDebug() << "Create Camera";
    QCamera *camera = new QCamera;
    MyVideoSurface *mySurface = new MyVideoSurface();
    camera->setViewfinder(mySurface);
    camera->start();
    qDebug() << "Camera started";*/


    ImageProcessor *processor = new ImageProcessor();
    engine.rootContext()->setContextProperty("ImageProcessor", processor);

    engine.addImportPath("qrc:/");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

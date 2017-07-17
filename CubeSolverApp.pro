TARGET      = CubeSolverApp
TEMPLATE    = app
QT          += qml quick widgets multimedia bluetooth

SOURCES     += source/main.cpp \
            source/imageprocessor.cpp \
            QLibrary/BluetoothClient/bluetoothclient.cpp \
            QLibrary/QImageItem/qimageitem.cpp \
            QLibrary/TwophaseAlgorithm/androidtwophase.cpp \
            QLibrary/TwophaseAlgorithm/twophasealgorithm.cpp

HEADERS     += source/imageprocessor.h \
            QLibrary/BluetoothClient/bluetoothclient.h \
            QLibrary/QImageItem/qimageitem.h \
            QLibrary/TwophaseAlgorithm/androidtwophase.h \
            QLibrary/TwophaseAlgorithm/twophasealgorithm.h

OTHER_FILES += main.qml \
            Cube.qml \
            android/AndroidManifest.xml \
            android/src/cs/min2phaseWrapper/SimpleTwophaseWrapper.java

RESOURCES   += qml.qrc

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
include(deployment.pri)

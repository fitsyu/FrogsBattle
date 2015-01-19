TEMPLATE = app

QT += qml quick multimedia sensors

SOURCES += main.cpp \
    gameengine.cpp \
    mission.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml \
    bar-descriptor.xml

HEADERS += \
    gameengine.h \
    mission.h

#INCLUDEPATH += "/usr/include/qt5/"

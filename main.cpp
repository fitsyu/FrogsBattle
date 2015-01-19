#include "gameengine.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlProperty>
#include <QDebug>
#include <QQuickWindow>
#include <QQuickItem>
#include <QQmlContext>
//#include <Qt3D/Qt3D>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:///Main.qml")));

//    QList<QQmlError> errors;
//    engine.importPlugin ("/opt/Qt5.3.0/5.3/gcc_64/imports/Qt/labs/gestures/libqmlgesturesplugin.so",
//                         "Qt.labs.gestures", &errors);
//    qDebug () << errors;

    QObject* rootObject =engine.rootObjects ().first ();


    QQuickWindow *rootWindow = qobject_cast<QQuickWindow*>(rootObject);

    GameEngine *dbugr = new GameEngine(rootWindow);
    dbugr->setEngine (&engine);
    engine.rootContext()->setContextProperty ("GameEngine", dbugr);

    return app.exec();
}

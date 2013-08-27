#include <QtGui/QApplication>

#include <QtDeclarative>

#include "qmlapplicationviewer.h"
#include "windowactions.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qmlRegisterType<WindowActions>("org.mhmtipek.hey", 1, 0, "WindowActions");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/Hey/main.qml"));
    viewer.showExpanded();

    return app->exec();
}

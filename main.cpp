#include "LoginBackend.h"
#include "ProgressBackend.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QVariant>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("MTHK");
    QGuiApplication::setApplicationName("widgets");

    QQmlApplicationEngine engine;
    auto *loginBackend = new LoginBackend(&engine);
    QQmlEngine::setObjectOwnership(loginBackend, QQmlEngine::CppOwnership);
    engine.rootContext()->setContextProperty("LoginBackend", loginBackend);

    auto *progressBackend = new ProgressBackend(&engine);
    QQmlEngine::setObjectOwnership(progressBackend, QQmlEngine::CppOwnership);
    engine.rootContext()->setContextProperty("ProgressBackend", progressBackend);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    QObject::connect(&app, &QCoreApplication::aboutToQuit, &engine, [&engine]() {
        engine.rootContext()->setContextProperty("LoginBackend", QVariant());
        engine.rootContext()->setContextProperty("ProgressBackend", QVariant());
    });
    engine.loadFromModule("widgets", "Main");

    return QGuiApplication::exec();
}

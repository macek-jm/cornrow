#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSurfaceFormat>

#include "BodePlotModel.h"
#include "BusyIndicatorModel.h"
#include "Config.h"
#include "EqChart.h"
#include "IoModel.h"
#include "Model.h"
#include "PhaseChart.h"
#include "PresetModel.h"
//#include "SoftClipChart.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QSurfaceFormat format;
    format.setSamples(8);
    QSurfaceFormat::setDefaultFormat(format);

    QGuiApplication app(argc, argv);

    auto config = Config::init(Config::Type::Low);
    auto model = Model::init(*config);
    auto bodePlot = BodePlotModel::init(*config);
    Q_UNUSED(model)
    Q_UNUSED(bodePlot)

    qmlRegisterType<BusyIndicatorModel>("Cornrow.BusyIndicatorModel", 1, 0, "CornrowBusyIndicatorModel");
    qmlRegisterType<EqChart>("Cornrow.EqChart", 1, 0, "CornrowEqChart");
    qmlRegisterType<PhaseChart>("Cornrow.PhaseChart", 1, 0, "CornrowPhaseChart");
    //qmlRegisterType<SoftClipChart>("Cornrow.SoftClipChart", 1, 0, "CornrowSoftClipChart");
    qmlRegisterSingletonType<Config>("Cornrow.Configuration", 1, 0, "CornrowConfiguration", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return Config::instance();
    });
    qmlRegisterSingletonType<Model>("Cornrow.Model", 1, 0, "CornrowModel", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return Model::instance();
    });
    qmlRegisterSingletonType<BodePlotModel>("Cornrow.BodePlotModel", 1, 0, "CornrowBodePlotModel", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return BodePlotModel::instance();
    });
    qmlRegisterSingletonType<IoModel>("Cornrow.IoModel", 1, 0, "CornrowIoModel", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return IoModel::instance();
    });
    qmlRegisterSingletonType<PresetModel>("Cornrow.PresetModel", 1, 0, "CornrowPresetModel", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return PresetModel::instance();
    });

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

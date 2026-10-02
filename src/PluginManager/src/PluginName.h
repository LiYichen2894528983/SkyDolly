#ifndef PLUGINNAME_H
#define PLUGINNAME_H

#include <QCoreApplication>
#include <QString>

inline QString translatedPluginName(const QString &name)
{
    static const char *const names[] = {
        QT_TRANSLATE_NOOP("PluginName", "CSV (Comma-Separated Values)"),
        QT_TRANSLATE_NOOP("PluginName", "Formation"),
        QT_TRANSLATE_NOOP("PluginName", "GPX (GPS Exchange Format)"),
        QT_TRANSLATE_NOOP("PluginName", "IGC (International Gliding Commission)"),
        QT_TRANSLATE_NOOP("PluginName", "JSON (JavaScript Object Notation)"),
        QT_TRANSLATE_NOOP("PluginName", "KML (Keyhole Markup Language)"),
        QT_TRANSLATE_NOOP("PluginName", "Location"),
        QT_TRANSLATE_NOOP("PluginName", "Logbook"),
        QT_TRANSLATE_NOOP("PluginName", "Path Creator (all simulators)"),
        QT_TRANSLATE_NOOP("PluginName", "SDLOG (Sky Dolly Logbook)"),
        QT_TRANSLATE_NOOP("PluginName", "SimConnect (Microsoft Flight Simulator)"),
        QT_TRANSLATE_NOOP("PluginName", "Template")
    };
    for (const char *source : names) {
        if (name == QLatin1StringView(source)) {
            return QCoreApplication::translate("PluginName", source);
        }
    }
    return name;
}

#endif

#include <QSettings>
#include "Language.h"

QString Language::getLanguage()
{
    const QString language = QSettings().value("UI/Language", "zh_CN").toString();
    return language == "en" ? language : QStringLiteral("zh_CN");
}

bool Language::setLanguage(const QString &language)
{
    if (language != "en" && language != "zh_CN") {
        return false;
    }
    QSettings settings;
    settings.setValue("UI/Language", language);
    settings.sync();
    return settings.status() == QSettings::NoError;
}

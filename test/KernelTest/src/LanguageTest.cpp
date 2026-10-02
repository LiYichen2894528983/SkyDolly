#include <QTest>
#include <QSettings>
#include <QTemporaryDir>
#include <Kernel/Language.h>

class LanguageTest : public QObject
{
    Q_OBJECT
private slots:
    void selectionPersists()
    {
        QTemporaryDir directory;
        QVERIFY(directory.isValid());
        QSettings::setDefaultFormat(QSettings::IniFormat);
        QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, directory.path());
        QCoreApplication::setOrganizationName("SkyDollyLanguageTest");
        QCoreApplication::setApplicationName("LanguageTest");
        QCOMPARE(Language::getLanguage(), QString("zh_CN"));
        QVERIFY(Language::setLanguage("en"));
        QCOMPARE(QSettings().value("UI/Language").toString(), QString("en"));
        QCOMPARE(Language::getLanguage(), QString("en"));
        QVERIFY(!Language::setLanguage("unsupported"));
        QCOMPARE(Language::getLanguage(), QString("en"));
        QVERIFY(Language::setLanguage("zh_CN"));
        QCOMPARE(Language::getLanguage(), QString("zh_CN"));
        QSettings().setValue("UI/Language", "invalid");
        QCOMPARE(Language::getLanguage(), QString("zh_CN"));
    }
};

QTEST_GUILESS_MAIN(LanguageTest)
#include "LanguageTest.moc"

#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QString>
#include "KernelLib.h"

class KERNEL_API Language final
{
public:
    static QString getLanguage();
    static bool setLanguage(const QString &language);
};

#endif

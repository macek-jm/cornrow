#include "Config.h"

#include <common/Types.h>

Config* Config::s_instance = nullptr;

Config* Config::instance()
{
    return s_instance;
}

Config* Config::init(Type type)
{
    if (s_instance) {
        return s_instance;
    }

    s_instance = new Config(type);
    return s_instance;
}

Config::Config(Type type, QObject *parent)
    : QObject(parent)
{
    // lowConf
    peqFilterCount = 5;  // @TODO(mawe): implement dynamic filter count
    freqTable = common::frequencyTable;
    freqDefault = 144;
    freqMin = 8;
    freqMax = 248;
    freqStep = 8;
    gainMin = -12.0;
    gainMax = 3.0;
    gainStep = 1.0;
    qTable = common::qTable;
    qDefault = 34;
    qMin = 16;
    qMax = 64;
    qStep = 3;

    switch (type) {
    case Type::Low:
        break;
    case Type::Mid:
        freqStep = 4;   // 2x
        gainMin = -24.0;
        gainMax = 6.0;
        gainStep = 0.5; // 2x
        qMin = 12;       // +14
        qMax = 80;
        qStep = 1;
        loudnessAvailable = true;
        break;
    case Type::High:
        freqStep = 2; // 8x
        gainMin = -48.0;
        gainMax = 12.0;
        gainStep = 0.5;
        qMin = 0;
        qMax = qTable.size()-1;
        qStep = 1;
        ioAvailable = true;
        loudnessAvailable = true;
        xoAvailable = true;
        swAvailable = true;
        break;
    }

    freqTable.resize(0);
    for (auto it = common::frequencyTable.begin()+freqMin;
         it < common::frequencyTable.begin()+freqMax+1; it += freqStep) {
        freqTable.push_back(*it);
    }
    freqDefault = (freqDefault-freqMin)/freqStep;

    qTable.resize(0);
    for (auto it = common::qTable.begin()+qMin;
         it < common::qTable.begin()+qMax+1; it += qStep) {
        qTable.push_back(*it);
    }
    qDefault = (qDefault-qMin)/qStep;
}

#include "Converter.h"

#include <math.h>

#include <QByteArray>

namespace common
{
namespace ble
{

Converter::Converter()
{
}

Converter::~Converter()
{
}

QByteArray Converter::toBle(const std::vector<common::IoInterface>& interfaces)
{
    QByteArray value;
    value.reserve(interfaces.size());

    for (const auto& interface : interfaces) {
        value.append(*reinterpret_cast<const char*>(&interface));
    }

    return value;
}

std::vector<common::IoInterface> Converter::fromBle(const QByteArray& bytes)
{
    std::vector<common::IoInterface> interfaces;
    interfaces.reserve(bytes.size());

    for (const auto& c : bytes) {
        auto interface = *reinterpret_cast<const common::IoInterface*>(&c);
        interfaces.push_back(interface);
    }

    return interfaces;
}

QByteArray Converter::filtersToBle(const std::vector<common::Filter>& filters)
{
    QByteArray value;
    value.reserve(filters.size()*4);

    for (const auto& filter : filters) {
        value.append(static_cast<char>(filter.type));
        value.append(fToBle(filter.f));
        value.append(gToBle(filter.g));
        value.append(qToBle(filter.q));
    }

    return value;
}

std::vector<common::Filter> Converter::filtersFromBle(const QByteArray& array)
{
    if (array.size()%4 != 0) {
        return {};
    }

    std::vector<common::Filter> filters;
    filters.reserve(array.size()/4);
    for (int i = 0; i < array.size(); i+=4) {
        filters.push_back( { static_cast<common::FilterType>(array.at(i)),
                             fFromBle(array.at(i+1)),
                             gFromBle(array.at(i+2)),
                             qFromBle(array.at(i+3)) } );
    }
    return filters;
}

uint8_t Converter::fToBle(float f)
{
    uint8_t i = 0;
    for (; i < common::frequencyTable.size(); ++i) {
        if (common::frequencyTable.at(i+1) >= f) break;
    }

    float c = sqrt(common::frequencyTable.at(i)*common::frequencyTable.at(i+1));
    if (f <= c) return i;
    else return i+1;
}

float Converter::fFromBle(uint8_t i)
{
    if (i >= common::frequencyTable.size()) return 0.0;
    return common::frequencyTable[i];
}

int8_t Converter::gToBle(float g)
{
    return round(g * 2.0);
}

float Converter::gFromBle(int8_t g)
{
    return g * 0.5;
}

uint8_t Converter::qToBle(float f)
{
    uint8_t i = 0;
    for (; i < common::qTable.size(); ++i) {
        if (common::qTable.at(i+1) >= f) break;
    }

    float c = sqrt(common::qTable.at(i)*common::qTable.at(i+1));
    if (f <= c) return i;
    else return i+1;
}

float Converter::qFromBle(uint8_t i)
{
    if (i >= common::qTable.size()) return 0.0;
    return common::qTable[i];
}

} // namespace ble
} // namespace common

import QtQml 2.2
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.11

import Cornrow.BusyIndicatorModel 1.0
import Cornrow.Configuration 1.0
import Cornrow.EqChart 1.0
import Cornrow.Model 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    // iPhone SE
    //width: 320
    //height: 568
    // iPhone 6
    //width: 375
    //height: 667
    // Google Nexus 5, Samsung Galaxy S5, S6, S7
    width: 360
    height: 640
    // Samsung Galaxy S8
    //width: 360
    //height: 740
    // Google Pixel
    //width: 411
    //height: 731

    Material.theme: Material.Dark
    Material.accent: Material.color(Material.Indigo)
    Material.primary: Material.color(Material.Indigo)
    Material.background: "#FF212121" //#FF000030

    Component.onCompleted: {
        CornrowModel.startDiscovering()
    }

    Connections {
        target: CornrowModel
        onFilterChanged: {
            eqChart.setFilter(i, t, f, g, q); // @TODO(mawe): make struct
        }
    }

    CornrowBusyIndicatorModel {
        id: model
        active: CornrowModel.status != CornrowModel.Connected
        radius: (CornrowModel.status == CornrowModel.Discovering ||
                CornrowModel.status == CornrowModel.Connecting) ? 48 : 36
        numPoints: 11
        Behavior on radius { SmoothedAnimation { velocity: 1000 }}
    }

    Item {
        id: statusScreen
        anchors.centerIn: parent
        enabled: CornrowModel.status != CornrowModel.Connected
        opacity: CornrowModel.status != CornrowModel.Connected ? 1.0 : 0.0
        Behavior on opacity { SmoothedAnimation { velocity: 2.0 }}
        Canvas {
            id: busyIndicator
            width: 120; height: 120
            contextType: "2d"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 48

            Shape {
                ShapePath {
                    id: myPath
                    strokeColor: "transparent"

                    startX: model.xCoords[0]; startY: model.yCoords[0]
                    Behavior on startX { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    Behavior on startY { SmoothedAnimation { velocity: 10; duration: 5000 }}

                    // @TODO(Qt): Repeater does not work here (and probably never will. We might mvoe this to C++).
                    PathCurve { x: model.xCoords[1]; y: model.yCoords[1]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[2]; y: model.yCoords[2]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[3]; y: model.yCoords[3]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[4]; y: model.yCoords[4]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[5]; y: model.yCoords[5]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[6]; y: model.yCoords[6]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[7]; y: model.yCoords[7]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[8]; y: model.yCoords[8]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[9]; y: model.yCoords[9]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[10]; y: model.yCoords[10]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }
                    PathCurve { x: model.xCoords[0]; y: model.yCoords[0]
                        Behavior on x { SmoothedAnimation { velocity: 10; duration: 5000 }}
                        Behavior on y { SmoothedAnimation { velocity: 10; duration: 5000 }}
                    }

                    fillGradient: RadialGradient {
                        centerX: 60; centerY: 60
                        // 45
                        centerRadius: model.radius*1.1//1.25
                        focalX: 60; focalY: 60
                        // 0, 0.4, 0.8, 1.0
                        GradientStop { id: grad1; position: 0; color: "#003F51B5" }
                        GradientStop { id: grad2; position: 0.4; color: "#003F51B5" }
                        GradientStop { position: 0.8; color: Material.color(Material.Indigo) }
                        GradientStop { position: 1.0; color: Material.color(Material.Pink) }
                        //GradientStop { position: 1.0; color: "#00E91E63" }
                    }
                }
            }
        }

        Label {
            id: statusReadout
            text: CornrowModel.statusLabel;
            font.capitalization: Font.SmallCaps
            font.pixelSize: 20
            font.weight: Font.DemiBold

            anchors.top: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: errorReadout
            horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignBottom
            maximumLineCount: 3
            text: CornrowModel.statusText;
            width: 240
            height: 48
            clip: true
            wrapMode: Text.Wrap
            font.pixelSize: 16
            font.weight: Font.Light

            anchors.top: statusReadout.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    ToolBar {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        visible: CornrowModel.status != CornrowModel.Discovering &&
                 CornrowModel.status != CornrowModel.Connecting &&
                 CornrowModel.status != CornrowModel.Connected
        background: background
        RowLayout {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter

            ToolButton {
                text: "Retry"
                onPressed: CornrowModel.startDiscovering()
            }
            ToolButton {
                text: "Demo"
                onPressed: CornrowModel.startDemoMode()
            }
        }
    }

    ToolButton {
        text: "Abort and retry"
        onPressed: CornrowModel.startDiscovering()
        background: background
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        visible: CornrowModel.status == CornrowModel.Connecting
    }

    Item {
        id: peq
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        enabled: CornrowModel.status == CornrowModel.Connected
        opacity: CornrowModel.status == CornrowModel.Connected ? 1.0 : 0.1
        Behavior on opacity { SmoothedAnimation { velocity: 2.0 }}

        CornrowEqChart {
            id: eqChart
            frequencyTable: CornrowConfiguration.freqTable
            plotCount: CornrowModel.filterCount
            currentPlot: CornrowModel.currentBand
            currentPlotColor: Material.accent
            plotColor: Material.foreground
            sumPlotColor: Material.primary
            warningColor: "orange" // unused
            criticalColor: Material.color(Material.Pink)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bandBar.top
        }

        /*
        Label {
            id: bandLabel
            text: "Band"
            anchors.left: typeLabel.left
            anchors.bottom: bandBar.top
        }
        */

        ToolBar {
            id: bandBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: typeBar.top
            background: background

            Row {
                id: bandRow
                // @TODO(mawe): use Repeater
                ToolButton {
                    text: qsTr("1")
                    autoExclusive: true
                    checked: CornrowModel.currentBand == 0
                    onPressed: CornrowModel.setCurrentBand(0)
                }
                ToolButton {
                    text: qsTr("2")
                    autoExclusive: true
                    checked: CornrowModel.currentBand == 1
                    onPressed: CornrowModel.setCurrentBand(1)
                }
                ToolButton {
                    text: qsTr("3")
                    autoExclusive: true
                    checked: CornrowModel.currentBand == 2
                    onPressed: CornrowModel.setCurrentBand(2)
                }
                ToolButton {
                    text: qsTr("4")
                    autoExclusive: true
                    checked: CornrowModel.currentBand == 3
                    onPressed: CornrowModel.setCurrentBand(3)
                }
                ToolButton {
                    text: qsTr("5")
                    autoExclusive: true
                    checked: CornrowModel.currentBand == 4
                    onPressed: CornrowModel.setCurrentBand(4)
                }
            }
        }

        // Type
        ToolBar {
            id: typeBar
            anchors.bottom: freqLabel.top
            anchors.left: parent.left
            anchors.right: parent.right
            background: background

            Row {
                id: typeRow
                ToolButton {
                    text: qsTr("Off")
                    autoExclusive: true
                    checked: CornrowModel.type == 0
                    onPressed: CornrowModel.type = 0
                }
                ToolButton {
                    text: qsTr("Peaking")
                    autoExclusive: true
                    checked: CornrowModel.type == 1
                    onPressed: CornrowModel.type = 1
                }
                ToolButton {
                    text: qsTr("LowPass")
                    autoExclusive: true
                    checked: CornrowModel.type == 2
                    onPressed: CornrowModel.type = 2
                }
                ToolButton {
                    text: qsTr("HighPass")
                    autoExclusive: true
                    checked: CornrowModel.type == 3
                    onPressed: CornrowModel.type = 3
                }
            }
        }

        // Frequency
        Label {
            id: freqLabel
            text: "Frequency"
            anchors.left: decFreq.horizontalCenter
            anchors.bottom: freqSlider.top
        }
        Label {
            id: freqReadout
            text: CornrowModel.freqReadout
            anchors.horizontalCenter: freqSlider.horizontalCenter
            anchors.bottom: freqSlider.top
        }
        ToolButton {
            id: decFreq
            text: qsTr("-")
            anchors.bottom: gainLabel.top
            anchors.horizontalCenter: decQ.horizontalCenter

            onPressed: CornrowModel.stepFreq(-1)
        }
        ToolButton {
            id: incFreq
            text: qsTr("+")
            anchors.bottom: gainLabel.top
            anchors.horizontalCenter: incQ.horizontalCenter

            onPressed: CornrowModel.stepFreq(1)
        }
        Slider {
            id: freqSlider
            anchors.bottom: gainLabel.top
            anchors.top: incFreq.top
            anchors.left: qSlider.anchors.left
            anchors.leftMargin: 4
            anchors.right: qSlider.anchors.right
            anchors.rightMargin: 4

            value: CornrowModel.freqSlider
            onValueChanged: CornrowModel.freqSlider = value
        }

        // Gain
        Label {
            id: gainLabel
            text: "Gain"
            anchors.left: decGain.horizontalCenter
            anchors.bottom: gainSlider.top
        }
        Label {
            id: gainReadout
            text: CornrowConfiguration.gainStep < 1.0 ? CornrowModel.gain.toFixed(1) : CornrowModel.gain.toFixed(0)
            anchors.horizontalCenter: gainSlider.horizontalCenter
            anchors.bottom: gainSlider.top
        }
        ToolButton {
            id: decGain
            text: qsTr("-")
            anchors.bottom: qLabel.top
            anchors.horizontalCenter: decQ.horizontalCenter
            onPressed: CornrowModel.stepGain(-1)
        }
        ToolButton {
            id: incGain
            text: qsTr("+")
            anchors.bottom: qLabel.top
            anchors.horizontalCenter: incQ.horizontalCenter
            onPressed: CornrowModel.stepGain(1)
        }
        Slider {
            id: gainSlider
            stepSize: CornrowConfiguration.gainStep
            from: CornrowConfiguration.gainMin
            to: CornrowConfiguration.gainMax
            anchors.bottom: qLabel.top
            anchors.top: incGain.top
            anchors.left: qSlider.anchors.left
            anchors.leftMargin: 4
            anchors.right: qSlider.anchors.right
            anchors.rightMargin: 4

            value: CornrowModel.gain // @TODO(mawe) fix binding loop
            onValueChanged: CornrowModel.gain = value
        }

        // Q
        Label {
            id: qLabel
            text: "Q"
            anchors.left: decQ.horizontalCenter
            anchors.bottom: qSlider.top
        }
        Label {
            id: qReadout
            text: CornrowModel.qReadout
            anchors.horizontalCenter: qSlider.horizontalCenter
            anchors.bottom: qSlider.top
        }
        ToolButton {
            id: decQ
            text: qsTr("-")
            anchors.verticalCenter: qSlider.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 4
            onPressed: CornrowModel.stepQ(-1)
        }
        ToolButton {
            id: incQ
            text: qsTr("+")
            anchors.verticalCenter: qSlider.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 4
            onPressed: CornrowModel.stepQ(1)
        }
        Slider {
            id: qSlider
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            anchors.left: decQ.right
            anchors.leftMargin: 4
            anchors.right: incQ.left
            anchors.rightMargin: 4

            value: CornrowModel.qSlider
            onValueChanged: CornrowModel.qSlider = value
        }
    } // Item
}

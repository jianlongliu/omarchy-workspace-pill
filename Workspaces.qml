import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// GNOME 45 style workspace indicator: one solid dot per workspace, with the
// current workspace expanded horizontally into a rounded pill. No text, no
// border, no heavy background — a pure visual indicator embedded in the bar.
BarWidget {
  id: root
  moduleName: "jianlongliu.workspace-pill"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  // Geometry: very small dots, the current one expands slightly.
  readonly property real dot: root.vertical ? root.barSize * 0.32 : Math.max(7, Math.round(root.barSize * 0.28))
  readonly property real expanded: root.vertical ? dot : dot * 2.6
  readonly property real spacing: dot * 0.5

  readonly property color base: root.bar ? root.bar.barForeground : Color.foreground
  readonly property color dim: Qt.alpha(base, 0.34)
  readonly property color active: Qt.alpha(base, 0.85)

  implicitWidth: row.implicitWidth
  // Fill the bar height so the row is vertically centered; otherwise a
  // dot-high item sits top-aligned in the bar's Row and drifts upward.
  implicitHeight: root.barSize

  Row {
    id: row
    spacing: root.spacing
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
      model: root.workspaceIds()

      Rectangle {
        id: dot
        required property int modelData

        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        implicitWidth: width
        implicitHeight: height
        width: focused ? root.expanded : root.dot
        height: root.dot
        radius: height / 2
        color: focused ? root.active : root.dim

        Behavior on width {
          NumberAnimation { duration: 220; easing.type: Easing.InOutCubic }
        }
        Behavior on color {
          ColorAnimation { duration: 220; easing.type: Easing.InOutCubic }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton
          cursorShape: Qt.ArrowCursor
          onClicked: function(mouse) { root.focusWorkspace(modelData) }
        }
      }
    }
  }
}

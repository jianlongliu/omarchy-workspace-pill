# Workspace Pill

A **[GNOME 45](https://gitlab.gnome.org/GNOME/gnome-shell) style** workspace indicator for the [Omarchy](https://omarchy.org/) bar. Each workspace is a small solid dot; the current workspace expands horizontally into a rounded pill. Pure visual — **no numbers, no border, no heavy background**.

![Workspace Pill](preview.png)

## Features

- Solid dots, one per workspace — the focused one expands into a pill.
- Embedded in the bar (not a floating element), vertically centered, height matched to the bar.
- Gentle colors from the bar's own foreground palette (unselected ~34%, current ~85% alpha) — no saturated accent/blue.
- Smooth 220ms width + color transition when switching workspaces.
- Click a dot to focus that workspace (silent, no button chrome).

## Install

```sh
omarchy plugin add https://github.com/jianlongliu/omarchy-workspace-pill.git --enable
```

Then make sure it's on the bar (it replaces the built-in dots, so disable the stock one):

```sh
omarchy bar put jianlongliu.workspace-pill --section left
omarchy plugin disable omarchy.workspaces
```

## How it looks

```
top bar, vertically centered, 5 workspaces, current = 1
      ▬▬    ●    ●    ●    ●
      ↑ current        └── gray dots
      ↑ expands into a rounded pill
```

## Source

The widget is `BarWidget + Row + Repeater`, one `Rectangle` per workspace. Key knob (`Workspaces.qml`):

| Thing | Value | Where |
| --- | --- | --- |
| Dot diameter | `barSize * 0.28` (≈7px on a 26px bar) | `dot` |
| Expansion | `dot * 2.6` | `expanded` |
| Unselected color | foreground @ 0.34 alpha | `dim` |
| Current color | foreground @ 0.85 alpha | `active` |
| Transition | 220ms width + color | `Behavior` |

To stay embedded, the widget sets `implicitHeight: root.barSize` and centers its row with `anchors.verticalCenter` — otherwise a dot-high item sits top-aligned in the bar and drifts upward.

## Requirements

- Omarchy (Quattro) on Hyprland.

## Uninstall

```sh
omarchy plugin remove jianlongliu.workspace-pill
```

## License

MIT. See [LICENSE](LICENSE).

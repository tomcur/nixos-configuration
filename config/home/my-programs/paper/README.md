A utility to help me set my wallpapers.

# Paper.py

This utility sets randomly-chosen wallpapers, per-monitor. It supports
horizontal and vertical monitors.

It makes quite some assumptions:

- Your wallpapers are in subdirectories in `~/Backgrounds`;
- Your horizontal wallpapers are in subdirectories `16-9`, `16-10`, or
  `big-horizontal`; and
- Your vertical wallpapers are in a subdirectory `9-16`.

Monitors with more horizontal than vertical pixels are given a horizontal
wallpaper, otherwise a vertical one.

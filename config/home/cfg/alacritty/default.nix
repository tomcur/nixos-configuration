{ unstablePkgs, ... }:
let alacritty = unstablePkgs.alacritty.overrideAttrs (prev: {
  postPatch = ''
    ${prev.postPatch}
    sed -i 's/pub const MIN_CURSOR_CONTRAST: f64 = .*;/pub const MIN_CURSOR_CONTRAST: f64 = 0.0;/g' \
      alacritty/src/display/content.rs
  '';
});
in
{
  home.packages = [ alacritty ];
  xdg.configFile."alacritty/alacritty.toml".text = ''
    # Monokai dark
    [colors.bright]
    black = "0x75715E"
    blue = "0x66D9EF"
    cyan = "0xA1EFE4"
    green = "0xA6E22E"
    magenta = "0xAE81FF"
    red = "0xF92672"
    white = "0xF9F8F5"
    yellow = "0xF4BF75"

    [colors.cursor]
    cursor = "0xF8F8F2"
    foreground = "CellBackground"

    [colors.normal]
    black = "0x272822"
    blue = "0x66D9EF"
    cyan = "0xA1EFE4"
    green = "0xA6E22E"
    magenta = "0xAE81FF"
    red = "0xF92672"
    white = "0xF8F8F2"
    yellow = "0xF4BF75"

    [colors.primary]
    background = "0x272822"
    foreground = "0xF8F8F2"

    [colors.vi_mode_cursor]
    cursor = "0xF8F8F2"
    foreground = "CellBackground"

    [font]
    size = 10.5

    [font.bold]
    style = "bold"

    [font.bold_italic]
    style = "bold italic"

    [font.italic]
    style = "italic"

    [font.normal]
    family = "Iosevka Extended"
    style = "book"

    [scrolling]
    history = 50000
    multiplier = 3

    [window]
    opacity = 0.9

    [keyboard]
    bindings = [
      { key = "V",        mods = "Control|Alt", action = "Paste"                               },
      { key = "C",        mods = "Control|Alt", action = "Copy"                                },
      { key = "N",        mods = "Control",     action = "SpawnNewInstance"                    },
      { key = "Paste",                          action = "Paste"                               },
      { key = "Copy",                           action = "Copy"                                },
      { key = "L",        mods = "Control",     action = "ClearLogNotice"                      },
      { key = "L",        mods = "Control",     chars = "\u000C"                               },
      { key = "Home",     mods = "Alt",         chars = "\u001B[1;3H"                          },
      { key = "Home",                           chars = "\u001BOH",        mode = "AppCursor"  },
      { key = "Home",                           chars = "\u001B[H",        mode = "~AppCursor" },
      { key = "End",      mods = "Alt",         chars = "\u001B[1;3F"                          },
      { key = "End",                            chars = "\u001BOF",        mode = "AppCursor"  },
      { key = "End",                            chars = "\u001B[F",        mode = "~AppCursor" },
      { key = "PageUp",   mods = "Shift",       action = "ScrollPageUp",   mode = "~Alt"       },
      { key = "PageUp",   mods = "Shift",       chars = "\u001B[5;2~",     mode = "Alt"        },
      { key = "PageUp",   mods = "Control",     chars = "\u001B[5;5~"                          },
      { key = "PageUp",   mods = "Alt",         chars = "\u001B[5;3~"                          },
      { key = "PageUp",                         chars = "\u001B[5~"                            },
      { key = "PageDown", mods = "Shift",       action = "ScrollPageDown", mode = "~Alt"       },
      { key = "PageDown", mods = "Shift",       chars = "\u001B[6;2~",     mode = "Alt"        },
      { key = "PageDown", mods = "Control",     chars = "\u001B[6;5~"                          },
      { key = "PageDown", mods = "Alt",         chars = "\u001B[6;3~"                          },
      { key = "PageDown",                       chars = "\u001B[6~"                            },
      { key = "Tab",      mods = "Shift",       chars = "\u001B[Z"                             },
      { key = "Back",                           chars = "\u007F"                               },
      { key = "Back",     mods = "Alt",         chars = "\u001B\u007f"                         },
      { key = "Insert",                         chars = "\u001B[2~"                            },
      { key = "Delete",                         chars = "\u001B[3~"                            },
      { key = "Left",     mods = "Shift",       chars = "\u001B[1;2D"                          },
      { key = "Left",     mods = "Control",     chars = "\u001B[1;5D"                          },
      { key = "Left",     mods = "Alt",         chars = "\u001B[1;3D"                          },
      { key = "Left",                           chars = "\u001B[D",        mode = "~AppCursor" },
      { key = "Left",                           chars = "\u001BOD",        mode = "AppCursor"  },
      { key = "Right",    mods = "Shift",       chars = "\u001B[1;2C"                          },
      { key = "Right",    mods = "Control",     chars = "\u001B[1;5C"                          },
      { key = "Right",    mods = "Alt",         chars = "\u001B[1;3C"                          },
      { key = "Right",                          chars = "\u001B[C",        mode = "~AppCursor" },
      { key = "Right",                          chars = "\u001BOC",        mode = "AppCursor"  },
      { key = "Up",       mods = "Shift",       chars = "\u001B[1;2A"                          },
      { key = "Up",       mods = "Control",     chars = "\u001B[1;5A"                          },
      { key = "Up",       mods = "Alt",         chars = "\u001B[1;3A"                          },
      { key = "Up",                             chars = "\u001B[A",        mode = "~AppCursor" },
      { key = "Up",                             chars = "\u001BOA",        mode = "AppCursor"  },
      { key = "Down",     mods = "Shift",       chars = "\u001B[1;2B"                          },
      { key = "Down",     mods = "Control",     chars = "\u001B[1;5B"                          },
      { key = "Down",     mods = "Alt",         chars = "\u001B[1;3B"                          },
      { key = "Down",                           chars = "\u001B[B",        mode = "~AppCursor" },
      { key = "Down",                           chars = "\u001BOB",        mode = "AppCursor"  },
      { key = "F1",                             chars = "\u001BOP"                             },
      { key = "F2",                             chars = "\u001BOQ"                             },
      { key = "F3",                             chars = "\u001BOR"                             },
      { key = "F4",                             chars = "\u001BOS"                             },
      { key = "F5",                             chars = "\u001B[15~"                           },
      { key = "F6",                             chars = "\u001B[17~"                           },
      { key = "F7",                             chars = "\u001B[18~"                           },
      { key = "F8",                             chars = "\u001B[19~"                           },
      { key = "F9",                             chars = "\u001B[20~"                           },
      { key = "F10",                            chars = "\u001B[21~"                           },
      { key = "F11",                            chars = "\u001B[23~"                           },
      { key = "F12",                            chars = "\u001B[24~"                           },
      { key = "F1",       mods = "Shift",   chars = "\u001B[1;2P"                              },
      { key = "F2",       mods = "Shift",   chars = "\u001B[1;2Q"                              },
      { key = "F3",       mods = "Shift",   chars = "\u001B[1;2R"                              },
      { key = "F4",       mods = "Shift",   chars = "\u001B[1;2S"                              },
      { key = "F5",       mods = "Shift",   chars = "\u001B[15;2~"                             },
      { key = "F6",       mods = "Shift",   chars = "\u001B[17;2~"                             },
      { key = "F7",       mods = "Shift",   chars = "\u001B[18;2~"                             },
      { key = "F8",       mods = "Shift",   chars = "\u001B[19;2~"                             },
      { key = "F9",       mods = "Shift",   chars = "\u001B[20;2~"                             },
      { key = "F10",      mods = "Shift",   chars = "\u001B[21;2~"                             },
      { key = "F11",      mods = "Shift",   chars = "\u001B[23;2~"                             },
      { key = "F12",      mods = "Shift",   chars = "\u001B[24;2~"                             },
      { key = "F1",       mods = "Control", chars = "\u001B[1;5P"                              },
      { key = "F2",       mods = "Control", chars = "\u001B[1;5Q"                              },
      { key = "F3",       mods = "Control", chars = "\u001B[1;5R"                              },
      { key = "F4",       mods = "Control", chars = "\u001B[1;5S"                              },
      { key = "F5",       mods = "Control", chars = "\u001B[15;5~"                             },
      { key = "F6",       mods = "Control", chars = "\u001B[17;5~"                             },
      { key = "F7",       mods = "Control", chars = "\u001B[18;5~"                             },
      { key = "F8",       mods = "Control", chars = "\u001B[19;5~"                             },
      { key = "F9",       mods = "Control", chars = "\u001B[20;5~"                             },
      { key = "F10",      mods = "Control", chars = "\u001B[21;5~"                             },
      { key = "F11",      mods = "Control", chars = "\u001B[23;5~"                             },
      { key = "F12",      mods = "Control", chars = "\u001B[24;5~"                             },
      { key = "F1",       mods = "Alt",     chars = "\u001B[1;6P"                              },
      { key = "F2",       mods = "Alt",     chars = "\u001B[1;6Q"                              },
      { key = "F3",       mods = "Alt",     chars = "\u001B[1;6R"                              },
      { key = "F4",       mods = "Alt",     chars = "\u001B[1;6S"                              },
      { key = "F5",       mods = "Alt",     chars = "\u001B[15;6~"                             },
      { key = "F6",       mods = "Alt",     chars = "\u001B[17;6~"                             },
      { key = "F7",       mods = "Alt",     chars = "\u001B[18;6~"                             },
      { key = "F8",       mods = "Alt",     chars = "\u001B[19;6~"                             },
      { key = "F9",       mods = "Alt",     chars = "\u001B[20;6~"                             },
      { key = "F10",      mods = "Alt",     chars = "\u001B[21;6~"                             },
      { key = "F11",      mods = "Alt",     chars = "\u001B[23;6~"                             },
      { key = "F12",      mods = "Alt",     chars = "\u001B[24;6~"                             },
      { key = "F1",       mods = "Super",   chars = "\u001B[1;3P"                              },
      { key = "F2",       mods = "Super",   chars = "\u001B[1;3Q"                              },
      { key = "F3",       mods = "Super",   chars = "\u001B[1;3R"                              },
      { key = "F4",       mods = "Super",   chars = "\u001B[1;3S"                              },
      { key = "F5",       mods = "Super",   chars = "\u001B[15;3~"                             },
      { key = "F6",       mods = "Super",   chars = "\u001B[17;3~"                             },
      { key = "F7",       mods = "Super",   chars = "\u001B[18;3~"                             },
      { key = "F8",       mods = "Super",   chars = "\u001B[19;3~"                             },
      { key = "F9",       mods = "Super",   chars = "\u001B[20;3~"                             },
      { key = "F10",      mods = "Super",   chars = "\u001B[21;3~"                             },
      { key = "F11",      mods = "Super",   chars = "\u001B[23;3~"                             },
      { key = "F12",      mods = "Super",   chars = "\u001B[24;3~"                             },
      { key = "NumpadEnter",                chars = "\n"                                       },
    ]
  '';
}

{ unstablePkgs, ... }:
{
  home.packages = [ unstablePkgs.alacritty ];
  xdg.configFile."alacritty/alacritty.yml".text = ''
    scrolling:
      history: 50000
      multiplier: 3
    font:
      normal:
        family: iosevka
        style: book
      bold:
        family: iosevka
        style: bold
      italic:
        family: iosevka
        style: book italic
      bold_italic:
        family: iosevka
        style: bold italic
      size: 10.5
    custom_cursor_colors: true
    schemes:
      monokai_dark: &monokai_dark
        cursor:
          cursor: '0xF8F8F2'
        primary:
          background: '0x272822'
          foreground: '0xF8F8F2'
        normal:
          black:   '0x272822'
          red:     '0xF92672'
          green:   '0xA6E22E'
          yellow:  '0xF4BF75'
          blue:    '0x66D9EF'
          magenta: '0xAE81FF'
          cyan:    '0xA1EFE4'
          white:   '0xF8F8F2'
        bright:
          black:   '0x75715E'
          red:     '0xF92672'
          green:   '0xA6E22E'
          yellow:  '0xF4BF75'
          blue:    '0x66D9EF'
          magenta: '0xAE81FF'
          cyan:    '0xA1EFE4'
          white:   '0xF9F8F5'
    colors: *monokai_dark
    background_opacity: 0.9
    key_bindings:
      - { key: V,        mods: Control|Alt, action: Paste            }
      - { key: C,        mods: Control|Alt, action: Copy             }
      - { key: N,        mods: Control,     action: SpawnNewInstance }
      - { key: Paste,                   action: Paste                            }
      - { key: Copy,                    action: Copy                             }
      - { key: L,        mods: Control, action: ClearLogNotice                   }
      - { key: L,        mods: Control, chars: "\x0c"                            }
      - { key: Home,     mods: Alt,     chars: "\x1b[1;3H"                       }
      - { key: Home,                    chars: "\x1bOH",        mode: AppCursor  }
      - { key: Home,                    chars: "\x1b[H",        mode: ~AppCursor }
      - { key: End,      mods: Alt,     chars: "\x1b[1;3F"                       }
      - { key: End,                     chars: "\x1bOF",        mode: AppCursor  }
      - { key: End,                     chars: "\x1b[F",        mode: ~AppCursor }
      - { key: PageUp,   mods: Shift,   action: ScrollPageUp,   mode: ~Alt       }
      - { key: PageUp,   mods: Shift,   chars: "\x1b[5;2~",     mode: Alt        }
      - { key: PageUp,   mods: Control, chars: "\x1b[5;5~"                       }
      - { key: PageUp,   mods: Alt,     chars: "\x1b[5;3~"                       }
      - { key: PageUp,                  chars: "\x1b[5~"                         }
      - { key: PageDown, mods: Shift,   action: ScrollPageDown, mode: ~Alt       }
      - { key: PageDown, mods: Shift,   chars: "\x1b[6;2~",     mode: Alt        }
      - { key: PageDown, mods: Control, chars: "\x1b[6;5~"                       }
      - { key: PageDown, mods: Alt,     chars: "\x1b[6;3~"                       }
      - { key: PageDown,                chars: "\x1b[6~"                         }
      - { key: Tab,      mods: Shift,   chars: "\x1b[Z"                          }
      - { key: Back,                    chars: "\x7f"                            }
      - { key: Back,     mods: Alt,     chars: "\x1b\x7f"                        }
      - { key: Insert,                  chars: "\x1b[2~"                         }
      - { key: Delete,                  chars: "\x1b[3~"                         }
      - { key: Left,     mods: Shift,   chars: "\x1b[1;2D"                       }
      - { key: Left,     mods: Control, chars: "\x1b[1;5D"                       }
      - { key: Left,     mods: Alt,     chars: "\x1b[1;3D"                       }
      - { key: Left,                    chars: "\x1b[D",        mode: ~AppCursor }
      - { key: Left,                    chars: "\x1bOD",        mode: AppCursor  }
      - { key: Right,    mods: Shift,   chars: "\x1b[1;2C"                       }
      - { key: Right,    mods: Control, chars: "\x1b[1;5C"                       }
      - { key: Right,    mods: Alt,     chars: "\x1b[1;3C"                       }
      - { key: Right,                   chars: "\x1b[C",        mode: ~AppCursor }
      - { key: Right,                   chars: "\x1bOC",        mode: AppCursor  }
      - { key: Up,       mods: Shift,   chars: "\x1b[1;2A"                       }
      - { key: Up,       mods: Control, chars: "\x1b[1;5A"                       }
      - { key: Up,       mods: Alt,     chars: "\x1b[1;3A"                       }
      - { key: Up,                      chars: "\x1b[A",        mode: ~AppCursor }
      - { key: Up,                      chars: "\x1bOA",        mode: AppCursor  }
      - { key: Down,     mods: Shift,   chars: "\x1b[1;2B"                       }
      - { key: Down,     mods: Control, chars: "\x1b[1;5B"                       }
      - { key: Down,     mods: Alt,     chars: "\x1b[1;3B"                       }
      - { key: Down,                    chars: "\x1b[B",        mode: ~AppCursor }
      - { key: Down,                    chars: "\x1bOB",        mode: AppCursor  }
      - { key: F1,                      chars: "\x1bOP"                          }
      - { key: F2,                      chars: "\x1bOQ"                          }
      - { key: F3,                      chars: "\x1bOR"                          }
      - { key: F4,                      chars: "\x1bOS"                          }
      - { key: F5,                      chars: "\x1b[15~"                        }
      - { key: F6,                      chars: "\x1b[17~"                        }
      - { key: F7,                      chars: "\x1b[18~"                        }
      - { key: F8,                      chars: "\x1b[19~"                        }
      - { key: F9,                      chars: "\x1b[20~"                        }
      - { key: F10,                     chars: "\x1b[21~"                        }
      - { key: F11,                     chars: "\x1b[23~"                        }
      - { key: F12,                     chars: "\x1b[24~"                        }
      - { key: F1,       mods: Shift,   chars: "\x1b[1;2P"                       }
      - { key: F2,       mods: Shift,   chars: "\x1b[1;2Q"                       }
      - { key: F3,       mods: Shift,   chars: "\x1b[1;2R"                       }
      - { key: F4,       mods: Shift,   chars: "\x1b[1;2S"                       }
      - { key: F5,       mods: Shift,   chars: "\x1b[15;2~"                      }
      - { key: F6,       mods: Shift,   chars: "\x1b[17;2~"                      }
      - { key: F7,       mods: Shift,   chars: "\x1b[18;2~"                      }
      - { key: F8,       mods: Shift,   chars: "\x1b[19;2~"                      }
      - { key: F9,       mods: Shift,   chars: "\x1b[20;2~"                      }
      - { key: F10,      mods: Shift,   chars: "\x1b[21;2~"                      }
      - { key: F11,      mods: Shift,   chars: "\x1b[23;2~"                      }
      - { key: F12,      mods: Shift,   chars: "\x1b[24;2~"                      }
      - { key: F1,       mods: Control, chars: "\x1b[1;5P"                       }
      - { key: F2,       mods: Control, chars: "\x1b[1;5Q"                       }
      - { key: F3,       mods: Control, chars: "\x1b[1;5R"                       }
      - { key: F4,       mods: Control, chars: "\x1b[1;5S"                       }
      - { key: F5,       mods: Control, chars: "\x1b[15;5~"                      }
      - { key: F6,       mods: Control, chars: "\x1b[17;5~"                      }
      - { key: F7,       mods: Control, chars: "\x1b[18;5~"                      }
      - { key: F8,       mods: Control, chars: "\x1b[19;5~"                      }
      - { key: F9,       mods: Control, chars: "\x1b[20;5~"                      }
      - { key: F10,      mods: Control, chars: "\x1b[21;5~"                      }
      - { key: F11,      mods: Control, chars: "\x1b[23;5~"                      }
      - { key: F12,      mods: Control, chars: "\x1b[24;5~"                      }
      - { key: F1,       mods: Alt,     chars: "\x1b[1;6P"                       }
      - { key: F2,       mods: Alt,     chars: "\x1b[1;6Q"                       }
      - { key: F3,       mods: Alt,     chars: "\x1b[1;6R"                       }
      - { key: F4,       mods: Alt,     chars: "\x1b[1;6S"                       }
      - { key: F5,       mods: Alt,     chars: "\x1b[15;6~"                      }
      - { key: F6,       mods: Alt,     chars: "\x1b[17;6~"                      }
      - { key: F7,       mods: Alt,     chars: "\x1b[18;6~"                      }
      - { key: F8,       mods: Alt,     chars: "\x1b[19;6~"                      }
      - { key: F9,       mods: Alt,     chars: "\x1b[20;6~"                      }
      - { key: F10,      mods: Alt,     chars: "\x1b[21;6~"                      }
      - { key: F11,      mods: Alt,     chars: "\x1b[23;6~"                      }
      - { key: F12,      mods: Alt,     chars: "\x1b[24;6~"                      }
      - { key: F1,       mods: Super,   chars: "\x1b[1;3P"                       }
      - { key: F2,       mods: Super,   chars: "\x1b[1;3Q"                       }
      - { key: F3,       mods: Super,   chars: "\x1b[1;3R"                       }
      - { key: F4,       mods: Super,   chars: "\x1b[1;3S"                       }
      - { key: F5,       mods: Super,   chars: "\x1b[15;3~"                      }
      - { key: F6,       mods: Super,   chars: "\x1b[17;3~"                      }
      - { key: F7,       mods: Super,   chars: "\x1b[18;3~"                      }
      - { key: F8,       mods: Super,   chars: "\x1b[19;3~"                      }
      - { key: F9,       mods: Super,   chars: "\x1b[20;3~"                      }
      - { key: F10,      mods: Super,   chars: "\x1b[21;3~"                      }
      - { key: F11,      mods: Super,   chars: "\x1b[23;3~"                      }
      - { key: F12,      mods: Super,   chars: "\x1b[24;3~"                      }
      - { key: NumpadEnter,             chars: "\n"                              }
  '';
}

local wezterm = require 'wezterm'
local config = {}

config.color_schemes = {
    ["Bearded Monokai Reversed"] = {
       foreground = "#c6cad7", -- terminal.foreground
      background = "#15171d", -- editor.background
      cursor_bg = "#ffd866",  -- suggestion, matches selection and accent
      cursor_border = "#ffd866",
      cursor_fg = "#12141a",
      selection_bg = "#98a2b5", -- picked for clarity (cannot use low alpha)
      selection_fg = "#D0D3DA",

      ansi = {
        "#12141a", -- black
        "#fc6a67", -- red
        "#a9dc76", -- green
        "#ffd866", -- yellow
        "#78dce8", -- blue
        "#e991e3", -- magenta (pulled from "players" and used in the theme)
        "#78e8c6", -- cyan
        "#c6cad7", -- white
      },
      brights = {
        "#404658", -- bright black
        "#ff6764", -- bright red
        "#a9f65c", -- bright green
        "#ffd866", -- bright yellow (same as normal but that's how theme defines it)
        "#61eeff", -- bright blue
        "#fd7df4", -- bright magenta
        "#61ffcf", -- bright cyan
        "#ffffff", -- bright white
      }
    },
  }
  
config.color_scheme = 'Bearded Monokai Reversed'
-- config.color_scheme = 'Ayu Mirage (Gogh)'
config.font = wezterm.font('JetBrains Mono')
config.enable_tab_bar = false
-- config.enable_true_color = true
config.warn_about_missing_glyphs = false

config.keys = {
  {
    key = 'Backspace',
    mods = 'CTRL',
    action = wezterm.action.SendString '\x1b\x7f',
  },
}

return config
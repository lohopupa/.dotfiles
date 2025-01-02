local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Ayu Mirage (Gogh)'
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
-- Pull in wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config = {
  font_size = 11.0,
  color_scheme = 'Dark+',
  -- color_scheme = 'Dracula',
  -- color_scheme = 'Bright Lights',
  -- workaround Hyprland bug in < 0.41
  enable_wayland = false,
  leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 },
  keys = {
    {
      key = 'v',
      mods = 'LEADER',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = 'h',
      mods = 'LEADER',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
  }

}

return config

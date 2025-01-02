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
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "ALT",
        key = "LeftArrow",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "ALT",
        key = "RightArrow",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
      key = 'v',
      mods = 'LEADER',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        mods = "CTRL|ALT",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "CTRL|ALT",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "CTRL|ALT",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize { "Down", 5 }
    },
    {
        mods = "CTRL|ALT",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize { "Up", 5 }
    },
    {
        key = 't',
        mods = 'LEADER',
        action = wezterm.action.ShowTabNavigator,
    },
    {
        key = 'p',
        mods = 'LEADER',
        -- keybinds
        action = wezterm.action.ActivateCommandPalette,
    },
  },

  -- tab bar
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  tab_and_split_indices_are_zero_based = false

}

for i = 1, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "ALT",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
    local SOLID_LEFT_ARROW = ""
    local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
    local prefix = ""

    if window:leader_is_active() then
        prefix = " " .. utf8.char(0x1f30a) -- ocean wave
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 1 then
        ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
    end -- arrow color based on if tab is first pane

    window:set_left_status(wezterm.format {
        { Background = { Color = "#b7bdf8" } },
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW }
    })
end)

return config

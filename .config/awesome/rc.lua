-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Check which disro is running
local os_file = io.open("/etc/os-release", "r")
local dist_family_id
if os_file then
  local contents = os_file:read("*a")
  os_file:close()
  dist_family_id = contents:match("ID_LIKE=([^%\n]+)")
end

if dist_family_id:find("arch") then
  wallpaper = "waypaper"
else
  wallpaper = "nitrogen"
end

-- Try to determine if we're running on a laptop
local laptop_in_use
local handle = io.popen("test -e /sys/class/power_supply/BAT0 && echo true || echo false")
if handle then
  local result = handle:read("*a")
  laptop_in_use = result:find("true")
  handle:close()
else
  laptop_in_use = false
end

-- Widgets
-- for laptops
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
-- pc/laptop
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local packages_widget
if dist_family_id:find("arch") then
  packages_widget = require('awesome-wm-widgets.pacman-widget.pacman')
end

-- Load Debian menu entries
-- debian menu only available if awesomewm is installed from debian mirrors
local debian
if dist_family_id:find("debian") then
  debian = require("debian.menu")
end
local has_fdo, freedesktop = pcall(require, "freedesktop")

--local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  dist_family_id:find("debian") and { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
cw = calendar_widget({
  placement = 'top_right',
  theme = 'outrun'
})

mytextclock:connect_signal("button::press",
  function(_,_,_,button)
    if button == 1 then cw.toggle() end
  end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            awful.widget.watch(         -- Display pending package updates (depends on OS service or cron running apt update)
                -- Take off one line if there is any output as the first line contains
                -- Listing... Done
                { awful.util.shell, "-c", string.format("apt list 2>/dev/null --upgradable | tail -n +2 | wc -l") },
                600, -- 10 min
                function(widget, stdout)
                    for line in stdout:gmatch("[^\r\n]+") do
                        updates = tonumber(line)
                        if (updates) > 0 then
                            widget:set_markup_silently(string.format('<span background="red" foreground="white"> UPDATES: %d </span> ', updates))
                        else
                            widget:set_text("")
                        end
                    end
                end
            ),
            awful.widget.watch(         -- Display any pending package updates that are phased and will not be installed (depends on OS service or cron running apt update)
                -- Take off one line if there is any output as the first line contains
                -- Listing... Done
                { awful.util.shell, "-c", string.format("apt list 2>/dev/null --upgradable | cut -d '/' -f1 | tail -n +2 | xargs apt-cache policy | rg -c phased || true") },
                600, -- 10 min
                function(widget, stdout)
                    for line in stdout:gmatch("[^\r\n]+") do
                        updates = tonumber(line)
                        if (updates) > 0 then
                            widget:set_markup_silently(string.format('<span background="blue" foreground="white"> PHASED: %d </span> ', updates))
                        else
                            widget:set_text("")
                        end
                    end
                    if stdout == nil or stdout == '' then
                        widget:set_text("")
                    end
                end
            ),
            awful.widget.watch('bash -c "test -f /var/run/reboot-required && echo \' REBOOT NEEDED \'"', 600),
            awful.widget.watch(         -- Display local IP address
                { awful.util.shell, "-c", string.format("ip addr | grep -A2 'state UP' | grep inet | grep -v : | awk '{print $2}' | cut -d'/' -f1") },
                10, -- 10 sec
                function(widget, stdout)
                    ip_set = false
                    ip = ""
                    for line in stdout:gmatch("[^\r\n]+") do
                        ip_set = true
                        ip = ip .. " " .. line
                        widget:set_text(string.format("%s  ", ip))
                    end
                    if not ip_set then
                        widget:set_text("NO IP  ")
                    end
                end
            ),
            net_speed_widget(),
            laptop_in_use and batteryarc_widget({
              show_current_level = true, 
              arc_thickness = 1,
            }),
            laptop_in_use and brightness_widget{
              type = 'icon_and_text',
              program = 'brightnessctl',
              step = 5,
              percentage = true,
            },
            cpu_widget(),
            ram_widget(),
            volume_widget{
              card = 0
            },
            fs_widget( { mounts = { '/' } } ),
            dist_family_id:find("arch") and packages_widget(),
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            logout_popup.widget{
              onlock = function () awful.spawn("loginctl lock-session") end,
            },
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "d", function() awful.spawn("dmenu_run") end,
              {description = "show dmenu", group = "launcher"}),

    awful.key({ modkey }, "d", function() awful.spawn.with_shell("$HOME/.config/rofi/scripts/launcher_t3") end,
              {description = "show rofi", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "w", function() awful.spawn(wallpaper .. " --random") end,
              {description = "set random wallpaper", group = "screen"}),

    awful.key({ modkey, "Shift" }, "e", function() awful.spawn("rofimoji -a clipboard -s neutral --selector-args='-theme ~/.config/rofi/launchers/type-3/style-5.rasi'") end,
              {description = "show emoji picker", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "p", function() awful.spawn.with_shell(terminal .. " start --class btop btop") end,
              {description = "Open btop", group = "launcher"}),

    awful.key({ modkey }, "c", function() awful.spawn("clipcat-menu insert") end,
              {description = "Open Clipboard Manager (insert)", group = "launcher"}),

    awful.key({ modkey, "Control" }, "c", function() awful.spawn("clipcat-menu remove") end,
              {description = "Open Clipboard Manager (remove)", group = "launcher"}),

    -- Brightness keys
    awful.key({}, "XF86MonBrightnessUp", function () brightness_widget:inc() end),
    awful.key({}, "XF86MonBrightnessDown", function () brightness_widget:dec() end),

    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume", function ()
            awful.util.spawn("amixer -q -D pulse sset Master 5%-", false) end),
    awful.key({}, "XF86AudioRaiseVolume", function ()
            awful.util.spawn("amixer -q -D pulse sset Master 5%+", false) end),
    awful.key({}, "XF86AudioMute", function ()
            awful.util.spawn("amixer -D pulse set Master 1+ toggle", false) end),
   -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn("playerctl play-pause", false) end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn("playerctl next", false) end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn("playerctl previous", false) end),

    -- Lock screen
    awful.key({ modkey, "Control"  }, "l", function () awful.spawn("loginctl lock-session") end,
              {description = "Lock the desktop", group = "screen"}),

    -- Logout popup
    awful.key({ modkey }, "x",
        function()
            logout_popup.launch {
                onlock = function () awful.spawn("loginctl lock-session") end
            }
        end,
        {description = "Show logout screen", group = "custom"}),

    -- Toggle keyboard layout between colemak and qwerty
    awful.key({ modkey  }, "F12", function () awful.spawn.with_shell("togglekeymap dh") end,
              {description = "Toggle colemak-dh keyboard", group = "custom"}),

    awful.key({ modkey, "Control" }, "F12", function () awful.spawn.with_shell("togglekeymap wide-dh") end,
              {description = "Toggle colemak-wide-dh keyboard", group = "custom"}),

    awful.key({ modkey, "Shift"}, "F12", function () awful.spawn.with_shell("togglekeymap") end,
              {description = "Toggle colemak (vanilla) keyboard", group = "custom"}),

    -- Applications
    awful.key({ modkey  }, "b", function () awful.spawn("zen-browser") end,
              {description = "zen-browser", group = "launcher"}),

    awful.key({ modkey  }, "e", function () awful.spawn("thunar") end,
              {description = "Thunar", group = "launcher"}),

    -- Screen grabs
    awful.key({},                       "Print", function () awful.spawn.with_shell("grab_full.sh") end),
    awful.key({ modkey          },      "Print", function () awful.spawn.with_shell("grab_focus.sh") end),
    awful.key({ modkey, "Shift" },      "Print", nil, function () awful.spawn.with_shell("grab_selection.sh") end),

    -- Change screen resolution (Mod1 being the Alt key)
    awful.key({ modkey, "Mod1"  }, "Up",
                  function ()
                        local screen = awful.screen.focused()
                        if screen.index == 1 then
                            -- primary screen
                            awful.spawn.easy_async("changeres --inc",
                                function(stdout, _, _, _)
                                    naughty.destroy(notification)
                                    notification = naughty.notify {
                                        text = stdout,
                                        title = "Resolution",
                                        timeout = 5,
                                        width = 200,
                                    }
                                end)
                        else
                            -- secondary screen
                            awful.spawn.easy_async("changeres --inc --secondary",
                                function(stdout, _, _, _)
                                    naughty.destroy(notification)
                                    notification = naughty.notify {
                                        text = stdout,
                                        title = "Resolution",
                                        timeout = 5,
                                        width = 200,
                                    }
                                end)
                        end
                  end,
              {description = "Increase screen resolution", group = "custom"}),
    awful.key({ modkey, "Mod1"  }, "Down",
                  function ()
                        local screen = awful.screen.focused()
                        if screen.index == 1 then
                            -- primary screen
                            awful.spawn.easy_async("changeres --dec",
                                function(stdout, _, _, _)
                                    naughty.destroy(notification)
                                    notification = naughty.notify {
                                        text = stdout,
                                        title = "Resolution",
                                        timeout = 5,
                                        width = 200,
                                    }
                                end)
                        else
                            -- secondary screen
                            awful.spawn.easy_async("changeres --dec --secondary",
                                function(stdout, _, _, _)
                                    naughty.destroy(notification)
                                    notification = naughty.notify {
                                        text = stdout,
                                        title = "Resolution",
                                        timeout = 5,
                                        width = 200,
                                    }
                                end)
                        end
                  end,
              {description = "Decrease screen resolution", group = "custom"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    -- awful.key({ modkey,           }, "n",
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end ,
    --     {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    {
      -- make any window float that has WM_WINDOW_ROLE set to About
      rule = { role = "About" },
      properties = { floating = true },
    },
    {
      -- Make the btop instance float in the centre of the screen
      rule = { class = "btop" },
      properties = {
          floating = true,
          geometry = { width = 1200, height = 600 },
      },
      callback = function(c)
          awful.placement.centered(c)
      end,
    },
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Gaps
beautiful.useless_gap = 3

-- Reduce the size of the notification icon
beautiful.notification_icon_size = 100

-- Autostart
awful.spawn.with_shell("changeres --preset; sleep 1")
awful.spawn.once(wallpaper .. " --restore")
awful.spawn.with_shell("nm-applet")
awful.spawn.once("clipcatd")

-- Trigger screen suspend after 10min, lock screen 5 seconds later
local locker
awful.spawn.with_shell("xset s 600 5")
if dist_family_id:find("debian") then
  awful.spawn.once("gnome-screensaver &")
  locker = "gnomelock-gnome-screensaver"
else
  locker = "betterlockscreen --off 5 -l dimblur"
end
awful.spawn.with_shell(string.format("xss-lock -n dim-screen.sh --transfer-sleep-lock -- %s &", locker))

awful.spawn.once("picom -b")
-- if Corne is not attached do not set local keymap
awful.spawn.with_shell("keebcheck && togglekeymap wide-dh -s")

-- Setup keyboard for US
-- To get the £ sign, type ,scroll lock, l, - (don't need to hold keys together)
--awful.spawn.with_shell("setxkbmap -layout us -option compose:sclk")

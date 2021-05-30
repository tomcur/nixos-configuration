-- TODO:
-- - If a client is spawned without a tag, give it a tag
-- - Restore floating position and size

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- @DOC_REQUIRE_SECTION@
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi
-- Notification library
-- disabled until it supports replacing notifications out-of-the-box (v4.4?)
-- see: https://github.com/awesomeWM/awesome/issues/1285
local _dbus = dbus
dbus = nil
local naughty = require("naughty")
dbus = _dbus
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- @DOC_ERROR_HANDLING@
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
--
local sharedtags = require("sharedtags")

local freedesktop = require("freedesktop")
local lain = require("lain");

local markup = lain.util.markup
local separators = lain.util.separators
local arrow = separators.arrow_left

-- {{{ Variable definitions
-- @DOC_LOAD_THEME@
-- Themes define colours, icons, font and wallpapers.
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/theme"

theme.font = "DejaVu Sans 9"
theme.mono_font = "Source Code Pro 9"

theme.fg_normal   = "#FEFEFE"
theme.fg_focus    = "#32D6FF"
theme.fg_urgent   = "#C83F11"
theme.fg_minimize = "#BEBEBE"

theme.bg_normal   = "#222222"
theme.bg_systray  = "#3F3F3F"

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(1)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"

theme.titlebar_bg_normal = "#C8C8C8" .. "A8";
theme.titlebar_bg_focus = "#FFFFFF" .. "B8";
theme.titlebar_fg_normal= "#262626";
theme.titlebar_fg_focus = "#161616";
theme.titlebar_fg_urgent = "#963636";

theme.tasklist_bg_focus    = "#1E232A"
theme.tasklist_bg_urgent   = "#362222"
theme.tasklist_bg_minimize = "#3F3F3F"

theme.taglist_bg_hover = "#3F3F3F"

theme.menu_bg_focus = "#3F3F3F"

theme.menu_height = dpi(19)
theme.menu_width  = dpi(140)

-- theme.menu_submenu_icon     = theme.dir .. "/icons/submenu.png"
-- theme.awesome_icon          = theme.dir .. "/icons/awesome.png"

local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

theme.tasklist_plain_task_name = false
theme.tasklist_disable_icon    = false

theme.titlebar_close_button_normal = theme.dir .. "/window-close.svg"
theme.titlebar_close_button_normal_hover = theme.dir .. "/window-close-hover.svg"
theme.titlebar_close_button_normal_press = theme.dir .. "/window-close-press.svg"
theme.titlebar_close_button_focus = theme.dir .. "/window-close-focus.svg"
theme.titlebar_close_button_focus_hover = theme.dir .. "/window-close-focus-hover.svg"
theme.titlebar_close_button_focus_press = theme.dir .. "/window-close-focus-press.svg"

theme.titlebar_minimize_button_normal = theme.dir .. "/go-down.svg"
theme.titlebar_minimize_button_normal_hover = theme.dir .. "/go-down-hover.svg"
theme.titlebar_minimize_button_normal_press = theme.dir .. "/go-down-press.svg"
theme.titlebar_minimize_button_focus = theme.dir .. "/go-down-focus.svg"
theme.titlebar_minimize_button_focus_hover = theme.dir .. "/go-down-focus-hover.svg"
theme.titlebar_minimize_button_focus_press = theme.dir .. "/go-down-focus-press.svg"

theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/go-top.svg"
theme.titlebar_ontop_button_normal_inactive_hover = theme.dir .. "/go-top-hover.svg"
theme.titlebar_ontop_button_normal_inactive_press = theme.dir .. "/go-top-press.svg"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/go-top-focus.svg"
theme.titlebar_ontop_button_focus_inactive_hover = theme.dir .. "/go-top-focus-hover.svg"
theme.titlebar_ontop_button_focus_inactive_press = theme.dir .. "/go-top-focus-press.svg"

theme.titlebar_ontop_button_normal_active = theme.dir .. "/go-bottom.svg"
theme.titlebar_ontop_button_normal_active_hover = theme.dir .. "/go-bottom-hover.svg"
theme.titlebar_ontop_button_normal_active_press = theme.dir .. "/go-bottom-press.svg"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/go-bottom-focus.svg"
theme.titlebar_ontop_button_focus_active_hover = theme.dir .. "/go-bottom-focus-hover.svg"
theme.titlebar_ontop_button_focus_active_press = theme.dir .. "/go-bottom-focus-press.svg"

theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/window-pin.svg"
theme.titlebar_sticky_button_normal_inactive_hover = theme.dir .. "/window-pin-hover.svg"
theme.titlebar_sticky_button_normal_inactive_press = theme.dir .. "/window-pin-press.svg"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/window-pin-focus.svg"
theme.titlebar_sticky_button_focus_inactive_hover = theme.dir .. "/window-pin-focus-hover.svg"
theme.titlebar_sticky_button_focus_inactive_press = theme.dir .. "/window-pin-focus-press.svg"

theme.titlebar_sticky_button_normal_active = theme.dir .. "/window-unpin.svg"
theme.titlebar_sticky_button_normal_active_hover = theme.dir .. "/window-unpin-hover.svg"
theme.titlebar_sticky_button_normal_active_press = theme.dir .. "/window-unpin-press.svg"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/window-unpin-focus.svg"
theme.titlebar_sticky_button_focus_active_hover = theme.dir .. "/window-unpin-focus-hover.svg"
theme.titlebar_sticky_button_focus_active_press = theme.dir .. "/window-unpin-focus-press.svg"

if not beautiful.init(theme) then
    beautiful.init({font = 'Monospace Bold 10'})
end

-- @DOC_DEFAULT_APPLICATIONS@
-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "vi"
local editor_cmd = terminal .. " -e " .. editor

awful.util.terminal = terminal

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- @DOC_LAYOUT@
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,       -- 1
    awful.layout.suit.tile,           -- 2
    awful.layout.suit.tile.left,      -- 3
    awful.layout.suit.tile.bottom,    -- 4
    awful.layout.suit.tile.top,       -- 5
    awful.layout.suit.fair,           -- 6
    awful.layout.suit.fair.horizontal,-- 7
    awful.layout.suit.spiral,         -- 8
    awful.layout.suit.spiral.dwindle, -- 9
    awful.layout.suit.max,            -- 10
    awful.layout.suit.max.fullscreen, -- 11
    awful.layout.suit.magnifier,      -- 12
    awful.layout.suit.corner.nw,      -- 13
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Tags
local tags = sharedtags({
    { name = "1", layout = awful.layout.layouts[2] },
    { name = "2", layout = awful.layout.layouts[2] },
    { name = "3", layout = awful.layout.layouts[2] },
    { name = "4", layout = awful.layout.layouts[2] },
    { name = "5", layout = awful.layout.layouts[2] },
    { name = "6", layout = awful.layout.layouts[2] },
    { name = "7", layout = awful.layout.layouts[2] },
    { name = "8", layout = awful.layout.layouts[2] },
    { name = "9", layout = awful.layout.layouts[2] },
    { name = "0", layout = awful.layout.layouts[10] },
    { name = "d", layout = awful.layout.layouts[1] },
    { name = "m", layout = awful.layout.layouts[10] },
})
-- }}}

-- {{{ Menu
-- @DOC_MENU@
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
-- @TAGLIST_BUTTON@
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

-- @TASKLIST_BUTTON@
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

-- -- @DOC_WALLPAPER@
-- local function set_wallpaper(s)
--     -- Wallpaper
--     -- local idx = s.index - 1
--     -- -- This unfortunately blanks the other screens...
--     -- awful.spawn("feh --xinerama-index " .. idx .. " --randomize --bg-fill ~/Backgrounds/*")
--     awful.spawn("feh --randomize --bg-fill ~/Backgrounds/*")
-- end

-- awful.widget.watch("playerctl metadata --format '{{ artist }} - {{ title }}'", 10, function(widget, stdout)
-- 	widget:set_markup(stdout:gsub("\n", ""))
-- 	widget.align = "center"
-- end)
local neticon = wibox.widget.textbox('<span font="siji 8">&#x00e1a0;</span>')
local net = lain.widget.net({
    settings = function()
        local received = tonumber(net_now.received)
        local received_unit = "k"
        if received > 1024 then
            received = received / 1024
            received_unit = "M"
        end
        local sent = tonumber(net_now.sent)
        local sent_unit = "k"
        if sent > 1024 then
            sent = sent / 1024
            sent_unit = "M"
        end

        local received_format = "%4.1f"
        local sent_format = "%-4.1f"

        if received >= 100 then
            received_format = "%4.0f"
        end
        if sent >= 100 then
            sent_format = "%-4.0f"
        end

        widget:set_markup(markup.fontfg(
            theme.mono_font,
            "#FEFEFE",
            " " .. string.format(received_format, received) .. received_unit .. " ↓↑ " .. string.format(sent_format, sent) .. sent_unit .. " B/s"
        ))
    end
})

local memicon = wibox.widget.textbox('<span font="siji 8">&#x00e020;</span>')
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.mono_font, " " .. string.format("%.1f", mem_now.used / 1000) .. "GB "))
    end
})

local cpuicon = wibox.widget.textbox('<span font="siji 8">&#x00e026;</span>')
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.mono_font, " " .. cpu_now.usage .. "% "))
    end
})

local bat_critical_icon = '<span font="siji 8">&#x00e243;</span>'
local bat_low_icon = '<span font="siji 8">&#x00e245;</span>'
local bat_medium_icon = '<span font="siji 8">&#x00e247;</span>'
local bat_high_icon = '<span font="siji 8">&#x00e249;</span>'
local bat_full_icon = '<span font="siji 8">&#x00e24b;</span>'
local bat_charging_icon = '<span font="siji 8">&#x00e239;</span>'
local bat = lain.widget.bat({
    battery = "BAT0",
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 or bat_now.status == "Charging" then
                local str =  bat_charging_icon .. " " .. bat_now.perc .. "%"
                if bat_now.status == "Charging" then
                    str = str .. " (" .. bat_now.time .. ")"
                end

                widget:set_markup(markup.font(theme.mono_font, str))
            else
                local str = ""
                if bat_now.perc > 90 then
                    str = bat_full_icon
                elseif bat_now.perc > 70 then
                    str = bat_high_icon
                elseif bat_now.perc > 50 then
                    str = bat_medium_icon
                elseif bat_now.perc > 30 then
                    str = bat_low_icon
                else
                    str = bat_critical_icon
                end

                str = str .. " " .. bat_now.perc .. "% (" .. bat_now.time .. ")"

                widget:set_markup(markup.font(theme.mono_font, str)) -- .. bat_now.status.perc))
            end
        end
    end
})

local vert_sep = wibox.widget.separator {
    orientation = "vertical",
    forced_width = theme.border_width,
    thickness = theme.border_width,
    color = theme.border_normal,
}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

-- @DOC_FOR_EACH_SCREEN@
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

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
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    id = "background_role",
                    widget = wibox.container.background,
                },
                top = 2,
                bottom = 2,
                left = 4,
                right = 4,
                widget = wibox.container.margin,
            },
            id = "main_background",
            -- bg = theme.bg_normal,
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                -- local main_background = self:get_children_by_id("main_background")[1]
                self:connect_signal('mouse::enter', function()
                    self.bg = theme.taglist_bg_hover
                end)
                self:connect_signal('mouse::leave', function()
                    self.bg = theme.bg_normal
                end)
            end,
        },
        layout = {
            layout = wibox.layout.fixed.horizontal,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id = "icon_role",
                                widget = wibox.widget.imagebox,
                            },
                            margins = 3,
                            widget = wibox.container.margin,
                        },
                        {
                            {
                                id = "text_role",
                                widget = wibox.widget.textbox,
                            },
                            left = 8,
                            widget = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    id = "background_role",
                    widget = wibox.container.background,
                },
                id = "border",
                color = theme.border_normal,
                margins = 1,
                widget = wibox.container.margin,
            },
            margins = 2,
            widget = wibox.container.margin,
            create_callback = function(self, c, index, objects)
                local border_margin = self:get_children_by_id("border")[1]
                self:connect_signal('mouse::enter', function()
                    border_margin.color = theme.border_focus
                end)
                self:connect_signal('mouse::leave', function()
                    border_margin.color = theme.border_normal
                end)
            end,
        },
        layout = {
            layout = wibox.layout.flex.horizontal,
        },
    }

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = theme.bg_normal, fg = theme.fg_normal })

    -- @DOC_SETUP_WIDGETS@
    -- Add widgets to the wibox
    local width = s.geometry.width

    local bat_hosts = { pollux = true, argo = true }

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
            wibox.container.background(wibox.container.margin(vert_sep, dpi(4), dpi(4)), theme.bg_normal),
        },
        s.mytasklist, -- Middle widget
        s.geometry.width > 1600 and
        { -- Right widgets on big screens
            wibox.container.background(wibox.container.margin(nil, dpi(8)), theme.bg_normal),
            layout = wibox.layout.fixed.horizontal,
            arrow(theme.bg_normal, theme.bg_systray),
            wibox.container.background(wibox.container.margin(wibox.widget.systray(), dpi(4), dpi(4)), theme.bg_systray),
            -- wibox.container.background(wibox.container.margin(wibox.widget { mailicon, theme.mail and theme.mail.widget, layout = wibox.layout.align.horizontal }, dpi(4), dpi(7)), "#343434"),
            -- arrow("#343434", theme.bg_normal),
            -- wibox.container.background(wibox.container.margin(wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }, dpi(3), dpi(6)), theme.bg_focus),
            arrow(theme.bg_systray, "#777E76"),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, dpi(2), dpi(3)), "#777E76"),
            arrow("#777E76", "#4B696D"),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, dpi(3), dpi(4)), "#4B696D"),
            arrow("#4B696D", "#4B3B51"),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }, dpi(3), dpi(3)), "#4B3B51"),
            arrow("#4B3B51", theme.bg_normal),
            bat_hosts[awesome.hostname]
                and wibox.container.background(wibox.container.margin(bat.widget, dpi(2), dpi(3)), theme.bg_normal)
                or wibox.container.background(wibox.container.margin(task, dpi(3), dpi(7)), theme.bg_normal),
            arrow(theme.bg_normal, "#777E76"),
            wibox.container.background(wibox.container.margin(mytextclock, dpi(4), dpi(8)), "#777E76"),
            arrow("#777E76", "alpha"),
            {
                s.mylayoutbox,
                margins = 2,
                layout = wibox.container.margin,
            },
        }
        or
        { -- Right widgets on small screens
            layout = wibox.layout.fixed.horizontal,
            {
                s.mylayoutbox,
                margins = 2,
                layout = wibox.container.margin,
            },
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
-- @DOC_ROOT_BUTTONS@
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local compositor_pid = awful.util.spawn("picom --experimental-backends")

-- {{{ Key bindings
-- @DOC_GLOBAL_KEYBINDINGS@
globalkeys = gears.table.join(
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
    awful.key({ modkey,           }, "q", function () mymainmenu:show() end,
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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.02)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.02)          end,
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
              {description = "run prompt", group= "launcher"}),

    awful.key({ modkey }, "x",
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
    awful.key({ modkey }, "p",
              function()
                  awful.util.spawn("rofi -modi drun,run -show drun -show-icons")
              end,
              {description = "show the menubar", group = "launcher"}),

    -- Compositor
    awful.key({ modkey }, "c",
              function()
                  if compositor_pid then
                      awful.util.spawn("kill -9 " .. compositor_pid)
                      compositor_pid = nil
                  else
                      compositor_pid = awful.util.spawn("picom --experimental-backends")
                  end
              end,
              {description = "toggle the compositor", group = "awesome"})

)

-- @DOC_CLIENT_KEYBINDINGS@
clientkeys = gears.table.join(
    awful.key({ modkey, "Mod1"    }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "s",      awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
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

-- @DOC_NUMBER_KEYBINDINGS@
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[i]
                        if tag then
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = tags[i]
                      if tag then
                         sharedtags.viewtoggle(tag, screen)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
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
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- @DOC_CLIENT_BUTTONS@
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

-- See: https://awesomewm.org/doc/api/classes/client.html#client.startup_id
local blacklisted_snid = setmetatable({}, {__mode = "v" })

--- Make startup notification work for some clients like XTerm. This is ugly
-- but works often enough to be useful.
local function fix_startup_id(c)
    -- Prevent "broken" sub processes created by <code>c</code> to inherit its SNID
    print("pid", c.pid)
    print("pid startup id", c.startup_id)
    if c.startup_id then
        blacklisted_snid[c.startup_id] = blacklisted_snid[c.startup_id] or c
        return
    end


    if not c.pid then return end

    -- Read the process environment variables
    local f = io.open("/proc/"..c.pid.."/environ", "rb")

    -- It will only work on Linux, that's already 99% of the userbase.
    if not f then return end

    local value = _VERSION <= "Lua 5.1" and "([^\z]*)\0" or "([^\0]*)\0"
    local snid = f:read("*all"):match("DESKTOP_STARTUP_ID=" .. value)
    f:close()

    print("snid", snid)

    if not snid then return end

    -- If there is already a client using this SNID, it means it's either a
    -- subprocess or another window for the same process. While it makes sense
    -- in some case to apply the same rules, it is not always the case, so
    -- better doing nothing rather than something stupid.
    if blacklisted_snid[snid] then return end

    c.startup_id = snid

    print("set snid", c.startup_id)

    blacklisted_snid[snid] = c
end

awful.rules.add_rule_source(
    -- rules seem to be reversed,
    -- see: https://github.com/awesomeWM/awesome/issues/2725
    -- "snid", fix_startup_id, {}, {"awful.spawn", "awful.rules"}
    "snid", fix_startup_id, {"awful.spawn", "awful.rules"}, {}
)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- @DOC_RULES@
awful.rules.rules = {
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    { rule = { },
      properties = { focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    { rule = { },
      except_any = { type = { "desktop" } },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
      }
    },


    -- @DOC_FLOATING_RULE@
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

    -- @DOC_DIALOG_RULE@
    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      -- @DOC_CSD_TITLEBARS@
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2".
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[2] } },
}
-- }}}

local function handle_title_bar(c)
    local show = true

    if c.requests_no_titlebar then
        show = false
    end

    if not c.floating and (c.first_tag and c.first_tag.layout.name ~= "floating") then
        show = false
    end

    if show then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end


-- {{{ Signals
-- Signal function to execute when a new client appears.
-- @DOC_MANAGE_HOOK@
client.connect_signal("manage", function (c)
    c._in_managing = true
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    local tag_clients = c.first_tag:clients()
    for k,client in pairs(tag_clients) do
        if client.floating then
            c.floating = true
            break
        end
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    elseif c.floating or c.first_tag.layout.name == "floating" then
        local placement = awful.placement.under_mouse + awful.placement.no_offscreen
        placement(c, {
            honor_workarea = true,
        })
    end

    handle_title_bar(c)
    c._in_managing = false
end)

client.connect_signal("property::floating", function(c)
    if c._in_managing then
        return
    end

    handle_title_bar(c)

    if c.floating or c.first_tag and c.first_tag.layout.name == "floating" then
        local placement = awful.placement.under_mouse + awful.placement.no_offscreen
        placement(c, { honor_workarea = true })
    end
end)

client.connect_signal("tagged", function(c)
    handle_title_bar(c)
end)

tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        handle_title_bar(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- @DOC_BORDER@
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- @DOC_TITLEBARS@
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

    local titlebar = awful.titlebar(c, {
        size = dpi(28),
    })

    titlebar : setup {
        {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                margins = dpi(3),
                layout  = wibox.container.margin,
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
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                spacing = dpi(12),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        },
        color = theme.border_normal,
        bottom = 1,
        layout = wibox.container.margin,
    }
end)


awful.spawn("sxhkd")
awful.spawn("keepassxc", { tag = tags[10] })
awful.spawn("thunderbird", { tag = tags[10] })
awful.spawn("seafile-applet", { tag = tags[10] })
awful.spawn("Discord", { tag = tags[6] })

awful.spawn("cool-retro-term -e vis", { tag = tags[12], below = true })
awful.spawn("alacritty -e ncmpcpp", { tag = tags[12], above = true })

awful.spawn("paper")

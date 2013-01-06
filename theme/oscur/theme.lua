-- {{{ License
--
-- Awesome theme configuration, using awesome 3.4.6 on Debian squeeze GNU/Linux
--   * Manuel F. <mfauvell@esdebian.org>

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


---------------------------
-- Oscur awesome theme --
---------------------------

theme = {}
confdir = awful.util.getdir("config")


theme.font          = "sans 9"

--theme.bg_normal     = "#000000" -- #222222
theme.bg_normal     = "#191e1a" -- #222222
theme.bg_focus      = "#393b3d" -- #535d6c
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "2"
theme.border_normal = "#000000"
theme.border_focus  = "green" -- #535d6c
-- theme.border_focus  = "#393b3d" -- #535d6c
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = confdir.. "/theme/oscur/taglist/squarefw.png"
theme.taglist_squares_unsel = confdir.. "/theme/oscur/taglist/squarew.png"

theme.tasklist_floating_icon = confdir.. "/theme/oscur/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = confdir.. "/theme/oscur/submenu.png"
theme.menu_height = "25"
theme.menu_width  = "190"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = confdir.. "/theme/oscur/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = confdir.. "/theme/oscur/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = confdir.. "/theme/oscur/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = confdir.. "/theme/oscur/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = confdir.. "/theme/oscur/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = confdir.. "/theme/oscur/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = confdir.. "/theme/oscur/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = confdir.. "/theme/oscur/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = confdir.. "/theme/oscur/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = confdir.. "/theme/oscur/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = confdir.. "/theme/oscur/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = confdir.. "/theme/oscur/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = confdir.. "/theme/oscur/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = confdir.. "/theme/oscur/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = confdir.. "/theme/oscur/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = confdir.. "/theme/oscur/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = confdir.. "/theme/oscur/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = confdir.. "/theme/oscur/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = confdir.. "/theme/oscur/layouts/fairhw.png"
theme.layout_fairv = confdir.. "/theme/oscur/layouts/fairvw.png"
theme.layout_floating  = confdir.. "/theme/oscur/layouts/floatingw.png"
theme.layout_magnifier = confdir.. "/theme/oscur/layouts/magnifierw.png"
theme.layout_max = confdir.. "/theme/oscur/layouts/maxw.png"
theme.layout_fullscreen = confdir.. "/theme/oscur/layouts/fullscreenw.png"
theme.layout_tilebottom = confdir.. "/theme/oscur/layouts/tilebottomw.png"
theme.layout_tileleft   = confdir.. "/theme/oscur/layouts/tileleftw.png"
theme.layout_tile = confdir.. "/theme/oscur/layouts/tilew.png"
theme.layout_tiletop = confdir.. "/theme/oscur/layouts/tiletopw.png"
theme.layout_spiral  = confdir.. "/theme/oscur/layouts/spiralw.png"
theme.layout_dwindle = confdir.. "/theme/oscur/layouts/dwindlew.png"

--theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
theme.awesome_icon = confdir.. "/theme/oscur/awesome16.png"

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
--{{{ 壁纸，一个目录的图片作为壁纸
x = 0
-- setup the timer
--theme.wallpaper_cmd = { "awsetbg " .. confdir .. "/theme/oscur/image/default.jpg" }
-- theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/default/background.png" }
theme.wallpaper_cmd = {  }
mytimer = timer { timeout = x }
mytimer:add_signal("timeout", function()
                                   -- tell awsetbg to randomly choose a wallpaper from your wallpaper directory
                                 os.execute("awsetbg  -F  -r  " .. confdir  .. "/theme/oscur/image&")
                                 -- stop the timer (we don't need multiple instances running at the same time)
                                 mytimer:stop()
                                   -- define the interval in which the next wallpaper change should occur in seconds
                                 -- (in this case anytime between 3 and 6 minutes)
                                 x = math.random( 3*60, 6*120)
                                   --restart the timer
                                   mytimer.timeout = x
                                 mytimer:start()
                              end)
-- initial start when rc.lua is first run
mytimer:start()
return theme

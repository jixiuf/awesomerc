require("awful")
require("awful.autofocus")
require("awful.rules")
-- Notification library
require("naughty")
require("vicious")
require("beautiful")
beautiful.init(awful.util.getdir("config") .. "/themes/oscur/theme.lua")
--动态tags
require("shifty")
require("mywiboxrc")
require("mykeyrc")

modkey = "Mod4" 
altkey = "Mod1" 
ctrlkey="Control"
shiftkey="Shift"
awful.util.spawn_with_shell("pkill -9 fcitx ; fcitx") 
shifty.config.tags = {
   ["www"] = { layout =awful.layout.suit.tile,max_clients=1 ,position=1  , solitary = true},
   ["java"] = { exclusive = true,          },
   ["eclipse"] = { exclusive = true,       solitary=true  },
   ["fs"] = { rel_index = 1,                               },
}

shifty.config.apps = {
   { match = {"urxvt" }, slave=true   ,intrusive=true     },
   { match = { "Pcmanfm"}, tag = "f s " },
   { match = { "OpenOffice.org*"}, tag = "office" },
   { match = { "Firefox"}, tag = "www",instrusive=true },
   { match = { "Dialog"},  tag = "www",intrusive=true,  float=true,geometry={240,200,nil,nil} ,above=true },
  { match = { "^下载$" },  tag ="www",above=true, titlebar=true,intrusive=true, geometry={800,200,400,300} ,float=true },
  { match = { "打开文件"}, tag = "www",intrusive=true,  float=true,geometry={240,200,nil,nil} ,above=true },
  { match = { "另存为"},   tag = "www",intrusive=true,  float=true,geometry={240,200,nil,nil} ,above=true },
  { match = { "附加组件"}, tag = "www",intrusive=true,  float=true,geometry={240,200,nil,nil} ,above=true },
--   { match = { "^Firefox.*"}, tag = "www",intrusive=true,  float=true,geometry={240,160,nil,nil} ,above=true },
   
   { match = {"Gimp",}, tag = "gimp" },
   { match = {"gimp%-image%-window" }, slave = true},
   { match = {"VirtualBox"}, tag ="vbox"},
   { match = {"Stardict"} ,slave=true },
   { match = { "Xmessage","Gxmessage"         }, float=true  },
   { match = {"Eclipse"},tag ="eclipse"   },
   { match = {"MyEclipse Enterprise Workbench" }, tag ="java" },
   { match = { "" }, 
     buttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, function (c) awful.mouse.client.move() end),
        awful.button({ modkey }, 3, awful.mouse.client.resize ) 
     )
  }
}
awful.rules.rules = {
   { rule = { },    properties = {  size_hints_honor = false} }
 }
shifty.config.defaults = {
   layout = awful.layout.suit.tile,
   ncol = 1, 
   mwfact = 0.50,
   floatBars=true,
   guess_name=true,
   guess_position=false,
}
shifty.taglist = mytaglist
shifty.init()
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
                               if awful.client.floating.get(c)  then awful.titlebar.add(c) end
                               -- Enable sloppy focus
                               c:add_signal("mouse::enter", function(x)
                                                               local cur_mouse_pos=mouse.coords()
                                                               if cur_mouse_pos.x>2 then
                                                                  --人性化，因为当x处在屏幕慕边界处（mouse.x=0时，)
                                                                  --也会隐藏菜单，故，做个特殊处理）
                                                                  mymainmenu:hide()
                                                               end
                                                               if taskMenuInstance then
                                                                  taskMenuInstance:hide()--关闭任务栏列表，如果存在的话
                                                                  taskMenuInstance = nil
                                                               end
--                                                               鼠标进入，聚焦
                                                               if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                               and awful.client.focus.filter(c) then
                                                               client.focus = c
                                                            end
                                                         end)
                            end)
client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- function debug_(var)
--    naughty.notify({ text = var, timeout = 5 })
-- end
-- d="ddddd"
-- debug_(d)
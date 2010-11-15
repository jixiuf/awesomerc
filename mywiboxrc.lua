--require("oss_volumerc")
require("alsa_volumerc")
require("batteryrc")
require("mymenurc")
modkey = "Mod4" 
altkey = "Mod1" 
ctrlkey="Control"
shiftkey="Shift"
--时间
layouts =
   {
       awful.layout.suit.floating,
       awful.layout.suit.tile,
       awful.layout.suit.tile.left,
       awful.layout.suit.tile.bottom,
       awful.layout.suit.tile.top,
       awful.layout.suit.fair,
       awful.layout.suit.fair.horizontal,
       awful.layout.suit.spiral,
       awful.layout.suit.spiral.dwindle,
       awful.layout.suit.max,
       awful.layout.suit.max.fullscreen,
       awful.layout.suit.magnifier
}
spacer=widget({type="textbox", name="spacer"})
spacer.text=" "
mytextclock = awful.widget.textclock({ align = "right" },"<span color='green'>%Y-%m-%d</span> <span   color='yellow'>%H:%M</span>",1)
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, "<span color='blue' >$1</span>")

--系统托盘
mysystray = widget({ type = "systray" })
--整个状态条
mywibox = {}
--运行对话框
mypromptbox = {}
--布局按钮
mylayoutbox = {}
--任务栏
mytasklist = {}
--标签,相当于虚拟桌面
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
)
--以下定义鼠标左键，右键，滚轮在任务栏上的事件
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
                           if not c:isvisible() then
                              awful.tag.viewonly(c:tags()[1])
                           end
                           client.focus = c
                           c:raise()
                        end),
   awful.button({ }, 3, function ()
                           if taskMenuInstance then
                              taskMenuInstance:hide()
                              taskMenuInstance = nil
                           else
                              taskMenuInstance  = awful.menu.clients({ width=250 })
                           end
                        end),
   awful.button({ }, 4, function ()
                           awful.client.focus.byidx(1)
                           if client.focus then client.focus:raise() end
                        end),
   awful.button({ }, 5, function ()
                           awful.client.focus.byidx(-1)
                           if client.focus then client.focus:raise() end
                        end))
for s = 1, screen.count() do
   mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))
                       )
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
   mytasklist[s] = awful.widget.tasklist(function(c)
                                            return awful.widget.tasklist.label.currenttags(c, s)
                                         end, mytasklist.buttons)
   mywibox[s] = awful.wibox({ position = "top", screen = s })
   mywibox[s].widgets = {
      {
         menuautoicon,
         mytaglist[s],
         mypromptbox[s],
         layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],baticon,spacer, textVolume,volicon,spacer, mytextclock,cpuwidget,
      s == 1 and mysystray or nil,
      mytasklist[s],
      layout = awful.widget.layout.horizontal.rightleft
   }

end


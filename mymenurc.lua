modkey = "Mod4" 
altkey = "Mod1" 
ctrlkey="Control"
shiftkey="Shift"
 --don't change this file's name ,
  --require("mymenurc")
  --add  menuautoicon into your wibox
local confdir=  awful.util.getdir("config")
local icondir= confdir .. "/icons/"
myawesomemenu = {
   { "   刷   新", awesome.restart, icondir .. "restart_3.png" },
   { "   注   销", awesome.quit ,icondir .. "logout.png" }
}
TextEditorMenu = {
   { "  Gvim", "gvim", icondir .. "gvim.xpm" },
   { "  Evim普通文本编辑器", "evim" ,icondir .. "gvim.xpm" },
   { "  Emacs", "emacs" ,icondir .. "emacs.png" },
}
OpenOfficeMenu = {
   { "OpenOffice", "ooffice "  , icondir .. "ooo-writer.png"},
   { "OpenOffice Writer(Word)", "ooffice -write" ,icondir .. "ooo-writer.png"},
   { "OpenOffice Calc(Excel)", "ooffice -calc" ,icondir .."ooo-calc.png"},
   { "OpenOffice Impress", "ooffice -impress"  ,icondir .. "ooo-impress.png"},
   { "OpenOffice Base(DataBase)", "ooffice -base",icondir .."ooo-base.png"  },
   { "OpenOffice Draw", "ooffice -draw" ,icondir .. "ooo-draw.png" },
   { "OpenOffice Math", "ooffice -math" ,icondir .. "ooo-math.png"},
   { "OpenOffice Print", "ooffice -printeradmin" ,icondir .. "ooo-printeradmin.png"},
}
TerminalMenu={
   { "Urxvt 终端", "urxvt" ,icondir .. "terminal.png" },
   { "Mlterm 终端", "mlterm" },
}
mymainmenu = awful.menu({ items = { 
                             { " OpenOffice办公软件", OpenOfficeMenu,icondir .. "ooo-writer.png" },
                             { " 文 本 编辑器", TextEditorMenu ,icondir .. "edit.png"},
                             { "  终   端", TerminalMenu,icondir .. "terminal2.png" },
                             { "  PcManFM 文件管理器", "pcmanfm",icondir .."folder.png" },
                             { "  FireFox 浏览器 ", "firefox",icondir .."firefox-icon.png" },
                             { "  StarDict星际译王", "stardict",icondir .."stardict.png" },
                             { "  Gpicview 图片浏览", "gpicview" ,icondir .. "gpicview.png"},
                             { "  Gimp 图片编辑", "gimp" ,icondir .. "gimp.png" },
                             { "  Adobe PDF 浏览器", "acroread",icondir .. "acroread.png" },
                             { "  ThunderBird邮件客户端", "thunderbird" ,icondir .. "thunderbird.png"},
                             { "   Timidity++ ", "timidity -ig", icondir .. "timidity.png" },
                             { "  WireShark网络分析 ", "sudo wireshark", icondir ..  "wireshark.png" },
                             { "  VirtualBox 虚拟机", "sudo VirtualBox", icondir .. "virtualbox.png" },
                             { "  Awesome", myawesomemenu ,icondir .. "awesome.png"},
                             { "    关  机", "sudo shutdown -h now",  icondir .. "shutdown.png"  },
                             { "    重  启", "sudo shutdown -r now" ,icondir .. "reboot.png" }
                       }})
 --mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu=mymainmenu})
 function toggle_menu ()
                        local cur_mouse_pos=mouse.coords()
                              mouse.coords({x=0,y=0},true)
                              mymainmenu:toggle()
                              mouse.coords(cur_mouse_pos,true)
                        end
 
menuautoicon = widget({ type = "imagebox" })
menuautoicon.image = image(icondir .. "linux.png")
menuautoicon:buttons(
   awful.util.table.join(
      awful.button({ }, 1, toggle_menu  )
   )
)
root.buttons(awful.util.table.join(
                awful.button({ }, 1, function () mymainmenu:hide() end),
                awful.button({ }, 3, function () mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
          ))

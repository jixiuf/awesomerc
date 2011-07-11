--文件列表--将所有窗口平铺到当前tag 然后可以用jkhl 移动焦点，回车后回到所选窗口所在的tag
require("jixiuf_util")
require("toggle_client_in_a_tag")
require("revelation")
require("drop_only")
require("run_or_raise_by_uuid")
require("aweror")
modkey = "Mod4" 
altkey = "Mod1" 
ctrlkey="Control"
shiftkey="Shift"
globalkeys = awful.util.table.join(
   awful.key({  modkey}, "i", function () awful.util.spawn_with_shell("sudo modprobe -r drcom; sudo modprobe drcom;sudo pkill drcomclient; sudo drcomclient") end),
   --awful.key({  modkey}, "i", function () run_or_raise("sudo drcomclient", { class="Drcomclient", instance="drcomclient" }) end),
   awful.key({  modkey}, "a", function () toggle_tag_with_shifty("emacsclient -c " ,"emacs",{class="Emacs" ,instance="emacs"}) end),
   awful.key({  modkey}, "q", function () show_matched_client({class="Emacs" ,instance="emacs"},"emacs"," emacsclient -c " ,nil) end),
   
   awful.key({ modkey            }, "c",function () toggle_conky() end),
      --stardict 文本模式,要用到xsel sdcv
   awful.key({ modkey }, "z", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),
--   awful.key({ modkey }, "F2", function () show_matched_client({class="Evim" ,instance="evim"},"evim","evim",nil ) end),
   awful.key({ modkey }, "d",function () query_word_from_selection() end),
   --将所有窗口平铺到当前tag 然后可以用jkhl 移动焦点，回车后回到所选窗口所在的tag
   awful.key({ modkey }, "w",  revelation.revelation),
   --文本模式下的music 播放器
   awful.key({modkey }, "F6", function ()
                                local offcount=awful.util.pread("pgrep -f mocp |wc -l")
                                if  string.match(offcount, "0") then 
                                   awful.util.spawn_with_shell("mocp -S ")
                                end
                                drop_only("urxvtc -e mocp " ,true,"center","center",1024,700,false,1)
                             end),
   awful.key({ modkey }, "F3", function () toggle_tag_with_shifty("urxvtc -name toggled_urxvt" ,"urxvtt",{class="URxvt"}) end),
--   awful.key({modkey}, "F3", function () awful.util.spawn("urxvtc -name toggled_urxvt" ) end),
   awful.key({      }, "F3", function () drop_only("urxvtc -name f3",true ,"center","center",900,600,false,1) end),
   awful.key({      }, "F1", function () drop_only("sudo urxvtc -name f1_root",true ,"center","center",900,600,false,1) end),
   awful.key({ modkey }, "F4", function () toggle_tag_with_shifty("sudo urxvtc -name toggled_urxvt_root" ,"urxvtt",{class="URxvt" ,instance="toggled_urxvt_root"}) end),
---   awful.key({modkey}, "F4", function () awful.util.spawn("sudo urxvtc -name toggled_urxvt_root" ) end),
   awful.key({      }, "F12", function () drop_only("urxvtc -e sudo  tail -f /var/log/messages", false, "bottom","center",1280,780,false,1)end),
   awful.key({      }, "Print",function () awful.util.spawn("scrot  -e 'mv $f ~/shots;gpicview ~/shots/$f'") end  ),
   awful.key({modkey,       },"F12",function () awful.util.spawn("xlock") end),--锁屏，
   awful.key({modkey,       }, "t",  function () awful.util.spawn("urxvtc") end),
--   awful.key({modkey,       }, "e",  function () awful.util.spawn("pcmanfm") end  ),
   awful.key({ modkey       }, "e", function () toggle_tag_with_shifty("pcmanfm" ,"f  s",{class="Pcmanfm"}) end),
   awful.key({modkey,       }, "g",  function () run_or_raise_by_uuid("gimp","gimp") end  ),
   awful.key({modkey        }, "f", function () toggle_tag_with_shifty("firefox" ,"www",{class="Firefox" ,instance="Navigator"}) end),   
--   awful.key({ modkey       }, "f",  function () run_or_raise_by_uuid("firefox") end),
   awful.key({modkey,       }, "i",  function () run_or_raise_by_uuid("eclipse","eclipse-j2ee-helios") end  ),
   awful.key({modkey,       }, "m",  function () run_or_raise_by_uuid("myeclipse","myeclipse") end  ),
   awful.key({modkey,shiftkey}, "s",  function () run_or_raise_by_uuid("stardict","stardict") end  ),
   awful.key({modkey,       }, "v",  function () run_or_raise_by_uuid("VirtualBox","vbox-main") end  ),
   awful.key({modkey,       }, "x",  function () run_or_raise_by_uuid("VirtualBox --comment x --startvm ee914fca-d5a4-45aa-9fc4-a44c6c07abe9 --no-startvm-errormsgbox","vobx-xp" ) end  ),

   awful.key({ modkey }, "n",   awful.tag.viewnext),
   awful.key({ modkey }, "p",   awful.tag.viewprev),
   awful.key({ ctrlkey,altkey    }, "Left",  awful.tag.viewprev),
   awful.key({ ctrlkey,altkey    }, "Right", awful.tag.viewnext),
   awful.key({ modkey }, "Tab", awful.tag.history.restore),
   awful.key({ modkey }, "grave", awful.tag.viewnext), --win+~

   --将每一个窗口与它的下一个窗口交换，同时把焦点放到主窗口上，也就是循环把窗口送到主窗口上
   awful.key({ ctrlkey,        }, "Tab",   function (c) awful.client.cycle(false,mouse.screen) client.focus=awful.client.getmaster() end),
   --焦点切换
   awful.key({ modkey,        }, "j",     function () awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end end),
   awful.key({ modkey,        }, "k",     function () awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end),
   awful.key({modkey,altkey}, "j",     function () awful.client.swap.byidx(  1)    end),--对调焦点窗口与下一个窗口
   awful.key({modkey,altkey}, "k",     function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey,        }, "u",     awful.client.urgent.jumpto),
   -- Standard program
   awful.key({modkey,altkey}, "r",     awesome.restart),
   awful.key({modkey,altkey}, "q",     awesome.quit),
   --多增加一列
   --awful.key({ modkey, altkey }, "h",     function () awful.tag.incncol( 1)         end),
   --awful.key({ modkey, altkey }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,        }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey,shiftkey }, "space", function () awful.layout.inc(layouts, -1) end),
   awful.key({ modkey         }, "r",     function () mypromptbox[mouse.screen]:run() end),
      -- awful.key({      }, "XF86AudioLowerVolume", function ()	awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 -- -2")  end),
   -- awful.key({      }, "XF86AudioRaiseVolume", function ()	awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 -- +2")  end),

   awful.key({shiftkey      }, "XF86AudioLowerVolume", function ()	awful.util.spawn_with_shell("amixer -q -c 0 set PCM 5%-")  end),
   awful.key({shiftkey      }, "XF86AudioRaiseVolume", function ()	awful.util.spawn_with_shell("amixer -q -c 0 set PCM 5%+")  end),
   awful.key({              }, "XF86AudioRaiseVolume", function ()	awful.util.spawn_with_shell("amixer -q -c 0 set Master 5%+")  end),
   awful.key({              }, "XF86AudioLowerVolume", function ()	awful.util.spawn_with_shell("amixer -q -c 0 set Master 5%-")  end),
   awful.key({      }, "XF86AudioStop", function ()awful.util.spawn("mocp -s ")  end),
   awful.key({      }, "XF86AudioPlay", function ()awful.util.spawn("mocp -G ")  end),
   awful.key({      }, "XF86AudioNext", function ()awful.util.spawn("mocp -f ")  end),
   awful.key({      }, "XF86AudioPrev", function ()awful.util.spawn("mocp -r ")  end)

   --awful.key({ modkey, shiftkey }, "x",
   --         function ()
   --            awful.prompt.run({ prompt = "Run Lua code: " },
   --           mypromptbox[mouse.screen].widget,
   --          awful.util.eval, nil,
   --         awful.util.getdir("cache") .. "/history_eval")
   --    end)
)


clientkeys = awful.util.table.join(
   awful.key({ modkey,        }, "h",     function (c)
                                             if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier then 
                                                awful.client.incwfact(-0.1) 
                                             end 
                                             awful.tag.incmwfact( 0.05)   end),
   awful.key({ modkey,        }, "l",     function (c) 
                                             if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier then 
                                                awful.client.incwfact(0.1)
                                             end 
                                             awful.tag.incmwfact( -0.05)   end),
 --send the client to next/previous tag
   awful.key({ modkey,altkey    }, "Left",  function (c)  send2prev_tag(c) end),
   awful.key({ modkey,altkey    }, "Right", function (c)  send2next_tag(c)  end),
--send the client to previous/next tag ,and view that tag
   awful.key({ modkey,shiftkey   }, "Left",  function (c)  send2prev_tag(c) awful.tag:viewprev(mouse.screen) end),
   awful.key({ modkey,shiftkey   }, "Right", function (c)  send2next_tag(c) awful.tag:viewnext(mouse.screen)  end),

   -- awful.key({ modkey		     }, "Next",  function (c) awful.client.moveresize( 20,  20, -40, -40) end),
   -- awful.key({ modkey		     }, "Prior", function (c) awful.client.moveresize(-20, -20,  40,  40) end),
   -- awful.key({ modkey		     }, "Down",  function (c) awful.client.moveresize(  0,  20,   0,   0) end),
   -- awful.key({ modkey		     }, "Up",    function (c) awful.client.moveresize(  0, -20,   0,   0) end),
   -- awful.key({ modkey		     }, "Left",  function (c) awful.client.moveresize(-20,   0,   0,   0) end),
   -- awful.key({ modkey 		     }, "Right", function (c) awful.client.moveresize( 20,   0,   0,   0) end),
   awful.key({ modkey,          },  "Escape",    function (c) c:kill()                         end),
   awful.key({ modkey, altkey}, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey,          }, "Return", function (c) 
                                                local master=awful.client.getmaster()
                                                if    master ~=c    then
                                                   c:swap(master)
                                                else 
                                                   awful.client.swap.byidx(  1) 
                                                   client.focus=awful.client.getmaster()
                                                end
                                             end),
   --awful.key({ modkey, shiftkey   }, "r",      function (c) c:redraw()                       end),
   --awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
   awful.key({             },       "F11",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({modkey,      },       "F11",      function (c) c.maximized_horizontal = not c.maximized_horizontal
                                                   c.maximized_vertical   = not c.maximized_vertical
                                                end)

)
for i=1,9 do
   globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey }, i,
                                                            function ()
                                                               for idx,t in ipairs(screen[mouse.screen]:tags()) do
                                                               if idx==i then
                                                                  awful.tag.viewonly(t)
                                                               end
                                                               end
                                                            end))
   globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, altkey }, i,
                                                            function ()
                                                               local t = shifty.getpos(i)
                                                               t.selected = not t.selected
                                                            end))
   globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, altkey, shiftkey }, i,
                                                            function ()
                                                               if client.focus then
                                                                  awful.client.toggletag(shifty.getpos(i))
                                                               end
                                                            end))
   --     move clients to other tags
   globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, shiftkey }, i,
                                                            function ()
                                                               if client.focus then
                                                                  local t = shifty.getpos(i)
                                                                  awful.client.movetotag(t)
                                                                  awful.tag.viewonly(t)
                                                               end
                                                            end))
end

--toggle conky in a new tag
function toggle_conky()
   local conky_tag=shifty.name2tag("conky",mouse.screen)
   if conky_tag then
      local clients = conky_tag:clients()
      for i, c in ipairs(clients) do
         if c.class=="Conky" then
            c:kill()
         else
            --send the client to previous tag (function in file jixiuf_util.lua)
            send2prev_tag(c)
         end
      end
      shifty.del(conky_tag)
   else
      shifty.add({ name="conky" })
      awful.util.spawn("conky -q ")
   end 
end


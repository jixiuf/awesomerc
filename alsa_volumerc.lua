
--Useage : require("volumerc")
---        add  volicon,textVolume,to your wibox list
--
confdir = awful.util.getdir("config")

volicon	= widget({ type = "imagebox", name = "volicon" })
vicious.register(volicon, vicious.widgets.volume, 
      function (widget, args)
	  if args[1] == 0 or args[2] == "♩" then 
	    volicon.image=image(confdir.."/icons/vol-mute.png")
	  elseif args[1] > 66 then
	    volicon.image=image(confdir.."/icons/vol-hi.png")
	  elseif args[1] > 33 and args[1] <= 66 then
	    volicon.image=image(confdir.."/icons/vol-med.png")
	  else
	    volicon.image  = image(confdir.."/icons/vol-low.png")
	  end
      end, 
      2, "Master")
--Mouse buttons
volumeButtons = awful.util.table.join(
   awful.button({ }, 4, function() 
                           awful.util.spawn_with_shell("amixer -q -c 0 set Master unmute")
                           awful.util.spawn_with_shell("amixer -q -c 0 set Master 5%+")
                        end  ),
   awful.button({ }, 5, function()
                           awful.util.spawn_with_shell("amixer -q -c 0 set Master unmute")
                           awful.util.spawn_with_shell("amixer -qc 0 set Master 5%-")
                        end  ),
   awful.button({ }, 1, function()
                           local offcount=awful.util.pread("amixer  -c 0 set Master toggle |grep off|wc -l")
                           if  string.match(offcount, "0") then 
                              awful.util.spawn_with_shell("amixer -qc 0 set Master 89%")
                           else 
                              awful.util.spawn_with_shell("amixer -qc 0 set Master 0")
                           end

                        end  )
)
-- awful.util.table.join(
--                            awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
--                            awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 4%+",false) end),
--                            awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 4%-",false) end))
   
volicon:buttons( volumeButtons)
-- }}}

textVolume=widget({type="textbox", name="textVolume"})
vicious.register(textVolume, vicious.widgets.volume, "<span color='red'>$2$1%</span>", 1, 'Master')
textVolume:buttons(volumeButtons)

--Useage : require("volumerc")
---        add  volicon,textVolume,to your wibox list
textVolume=widget({type="textbox", name="textVolume"})
volicon	= widget({ type = "imagebox", name = "volicon" })
function set_volume_value ()
local current_volume=awful.util.pread('ossmix   codec3.misc.pcm1 |cut -d " " -f 10|cut -d ":" -f 1')
textVolume.text= current_volume 
local current_volume_num=current_volume+0
	  if current_volume_num == 0 then 
	    volicon.image=image(confdir.."/icons/vol-mute.png")
	  elseif current_volume_num > 50 then
	    volicon.image=image(confdir.."/icons/vol-hi.png")
	  elseif current_volume_num > 30 and current_volume_num <= 66 then
	    volicon.image=image(confdir.."/icons/vol-med.png")
	  else
	    volicon.image  = image(confdir.."/icons/vol-low.png")
	  end
end 
volumeButtons = awful.util.table.join(
   awful.button({ }, 4, function() 
                           awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 -- +2")
                           set_volume_value()
                         end  ),
   awful.button({ }, 5, function()
                           awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 -- -2")
                           set_volume_value()
                        end  ),
   awful.button({ }, 1, function()
                           local offcount=awful.util.pread(" ossmix  codec3.misc.pcm1 |grep 0.0|wc -l")
                           if  string.match(offcount, "0") then 
                              awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 0:0")
                           else 
                              awful.util.spawn_with_shell("ossmix   codec3.misc.pcm1 100:100")
                           end
                           set_volume_value()
                        end  )
 )

   
volicon:buttons( volumeButtons)
textVolume:buttons(volumeButtons)

set_volume_value()
volume_listener_timer = timer { timeout = 30 }
volume_listener_timer:add_signal("timeout", function()
                                 set_volume_value()
                              end)
volume_listener_timer:start()
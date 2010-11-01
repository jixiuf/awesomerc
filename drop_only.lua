--scratch provided a scratch.drop() to 
-- Create a new window for the drop-down application when it doesn't
-- exist, or toggle between hidden and visible states when it does
-------------------------------------------------------------------
-- I provided this drop_only() to only show the curent client
--(means  it will hidden all other drop_down client when current client show )
-- I also provide scratch.drop_only.hideall() to hiden all drop_down clients
--what you need to do is
--add require("drop_only")
--and  replace scratch.drop(...) to drop_only(...) ,the parameters are the
--same with scratch.drop() ;actually ,this file is modified from scratch/drop.lua

-- and you can email me : <jixiuf@qq.com><jixiuf@gmail.com>

-------------------------------------------------------------------
--and the initial source of scratch.drop() is 
-- Coded  by: * Lucas de Vries <lucas@glacicle.com>
-- Hacked by: * Adrian C. (anrxc) <anrxc@sysphere.org>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
-------------------------------------------------------------------
-- To use this module add:
--   require("drop_only")
--   awful.key({      }, "F1", function () drop_only("urxvtc" ,"center","center",1024,700,false,1) end),
--   awful.key({      }, "F2", function () drop_only("mlterm","center","center",1024,700,false,1) end),
--   awful.key({      }, "F3", function () drop_only("gksu urxvtc", "center","center",900,600,false,1) end),
--   awful.key({      }, "Escape", function () drop_only.hideall() end),

-- to the top of your rc.lua, and call it from a keybinding:
--   drop_only(prog, vert, horiz, width, height, sticky, screen)
--
-- Parameters:
--   prog   - Program to run; "urxvt", "gmrun", "thunderbird"
--   vert   - Vertical; "bottom", "center" or "top" (default)
--   horiz  - Horizontal; "left", "right" or "center" (default)
--   width  - Width in absolute pixels, or width percentage
--            when <= 1 (1 (100% of the screen) by default)
--   height - Height in absolute pixels, or height percentage
--            when <= 1 (0.25 (25% of the screen) by default)
--   sticky - Visible on all tags, false by default
--   screen - Screen (optional), mouse.screen by default
-------------------------------------------------------------------

-- Grab environment
local pairs = pairs
local awful = require("awful")
local setmetatable = setmetatable
local capi = {
   mouse = mouse,
   client = client,
   screen = screen
}

-- Scratchdrop: drop-down applications manager for the awesome window manager
module("drop_only")

local dropdown = {}
--记录前一个dropped client
local previous_dropped_client
--这里第一次运行将previous_dropped_client伪装成一个{} ,从而可以,有一个为false的hidden属性,
--便于编程,否则还要判断,previous_dropped_client是否存在,
if previous_dropped_client==nil then
   previous_dropped_client={}
   previous_dropped_client.hidden=false
end

-- Create a new window for the drop-down application when it doesn't
-- exist, or toggle between hidden and visible states when it does
 function toggle(prog,hideOtherClients, vert, horiz, width, height, sticky, screen)
   vert   = vert   or "top"
   horiz  = horiz  or "center"
   width  = width  or 1
   height = height or 0.25
   sticky = sticky or false
   screen = screen or capi.mouse.screen

   if not dropdown[prog] then
      dropdown[prog] = {}

      -- Add unmanage signal for scratchdrop programs
      capi.client.add_signal("unmanage", function (c)
                                            for scr, cl in pairs(dropdown[prog]) do
                                               if cl == c then
                                                  dropdown[prog][scr] = nil
                                               end
                                            end
                                         end)
   end
   --如果client 不存在,则创建它,
   if not dropdown[prog][screen] then
      spawnw = function (c)
                  dropdown[prog][screen] = c

                  --for 做了两件事,在创建当前窗口的同时记录是否有dropped client ,有的话将其记入previous_dropped_client
                  -- 并且,如果当前cient  要求隐藏其它的dropped client ,则隐藏之
                  for i,ws in pairs(dropdown) do
                     for i2,s  in pairs(ws) do
                        if  c~= s and s:isvisible() == true then
                           previous_dropped_client=s
                           if hideOtherClients then
                              s.hidden=true
                           end 
                        end 
                     end
                  end
                  -- Scratchdrop clients are floaters
                  awful.client.floating.set(c, true)

                  -- Client geometry and placement
                  local screengeom = capi.screen[screen].workarea

                  if width  <= 1 then width  = screengeom.width  * width  end
                  if height <= 1 then height = screengeom.height * height end

                  if     horiz == "left"  then x = screengeom.x
                  elseif horiz == "right" then x = screengeom.width - width
                  else   x =  screengeom.x+(screengeom.width-width)/2 end

                  if     vert == "bottom" then y = screengeom.height + screengeom.y - height
                  elseif vert == "center" then y = screengeom.y+(screengeom.height-height)/2
                  else   y =  screengeom.y - screengeom.y end

                  -- Client properties
                  c:geometry({ x = x, y = y, width = width, height = height })
                  c.ontop = true
                  c.above = true
                  c.skip_taskbar = true
                  if sticky then c.sticky = true end
                  if c.titlebar then awful.titlebar.remove(c) end

                  c:raise()
                  capi.client.focus = c
                  capi.client.remove_signal("manage", spawnw)
               end
      
      -- Add manage signal and spawn the program
      capi.client.add_signal("manage", spawnw)
      awful.util.spawn(prog, false)

      
   else    --这个else 是说,当前client 已经创建,只是hidden 了而已
      -- Get a running client
      c = dropdown[prog][screen]

      -- Switch the client to the current workspace
      if c:isvisible() == false then c.hidden = true
         awful.client.movetotag(awful.tag.selected(screen), c)
      end

      -- Focus and raise if hidden   --显示当前client
      if c.hidden then
         --for 做了两件事,
         -- 一 记录上一个dropped(如果有的话)的client, 记录的原因是:便于hideOtherClients=false的client
         --在隐藏自身的时候,显示上一个dropped client,从而做到hideOtherClients=false
         
         -- 第二是隐藏前一个dropped 的  client
         --(不论当前client 是否hideOtherClients ,因为对于hideOtherClients=false,的client ,只要在hide它时,显示上一个dropped 的client 即可实现此功能)
         for i,ws in pairs(dropdown) do
            for i2,s  in pairs(ws) do
               if  c~= s and s:isvisible() == true then
                  previous_dropped_client=s
                  s.hidden=true
                  break
               end 
            end
         end
         -- Make sure it is centered
         if vert  == "center" then awful.placement.center_vertical(c)   end
         if horiz == "center" then awful.placement.center_horizontal(c) end
         c.hidden = false
         c.ontop=true
         c:raise()
         capi.client.focus = c

      else -- Hide and detach tags if not
         if  hideOtherClients then 
            previous_dropped_client.hidden=true
         else
            previous_dropped_client.hidden=false
            capi.client.focus = previous_dropped_client
         end 
         c.hidden = true
         local ctags = c:tags()
         for i, t in pairs(ctags) do
            ctags[i] = nil
         end
         c:tags(ctags)
      end
   end
   
end

function hideall()
   for i,ws in pairs(dropdown) do
      for i2, s in pairs(ws) do
         s.hidden=true
      end
   end
end

setmetatable(_M, { __call = function(_, ...) return toggle(...) end })


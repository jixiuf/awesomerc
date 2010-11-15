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
-- Parameters:
--   prog   - Program to run; "urxvt", "gmrun", "thunderbird"
--   hideOtherClients   whether to hide other dropped client when this client show ,default true
--   vert   - Vertical; "bottom", "center" or "top" (default),fullscreen
--   horiz  - Horizontal; "left", "right" or "center" (default),fullscreen
--   width  - Width in absolute pixels, or width percentage
--            when <= 1 (1 (100% of the screen) by default)
--   height - Height in absolute pixels, or height percentage
--            when <= 1 (0.25 (25% of the screen) by default)
--   sticky - Visible on all tags, false by default
--   screen - Screen (optional), mouse.screen by default
-------------------------------------------------------------------
local pairs = pairs
local awful = require("awful")
local setmetatable = setmetatable
local capi = {
   mouse = mouse,
   client = client,
   screen = screen
}
--module("drop_only")

local dropdown = {}
local previous_dropped_client

if previous_dropped_client==nil then
   previous_dropped_client={}
   previous_dropped_client.hidden=false
end

--function toggle(prog,hideOtherClients, vert, horiz, width, height, sticky, screen)
function drop_only(prog,hideOtherClients, vert, horiz, width, height, sticky, screen)
   vert   = vert   or "top"
   horiz  = horiz  or "center"
   width  = width  or 1
   height = height or 0.25
   sticky = sticky or false
   screen = screen or capi.mouse.screen

   if not dropdown[prog] then
      dropdown[prog] = {}
      capi.client.add_signal("unmanage", function (c)
                                            for scr, cl in pairs(dropdown[prog]) do
                                               if cl == c then
                                                  dropdown[prog][scr] = nil
                                               end
                                            end
                                         end)
   end

   if not dropdown[prog][screen] then
      spawnw = function (c)
                  dropdown[prog][screen] = c
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
                  if horiz=="fullscreen" then width=screengeom.width     x=screengeom.x end
                  if vert== "fullscreen" then height=screengeom.height y=screengeom.y end

                  c:geometry({ x = x, y = y, width = width, height = height })
--                  c.ontop = true
                  c.above = true
--                c.skip_taskbar = true
                  if sticky then c.sticky = true end
                  if c.titlebar then awful.titlebar.remove(c) end

                  c:raise()
                  capi.client.focus = c
                  capi.client.remove_signal("manage", spawnw)
               end
      
      -- Add manage signal and spawn the program
      capi.client.add_signal("manage", spawnw)
      awful.util.spawn(prog, false)

      
   else
      -- Get a running client
      c = dropdown[prog][screen]

      -- Switch the client to the current workspace
      if c:isvisible() == false then 
         if awful.tag.selected(screen) then 
            awful.client.movetotag( awful.tag.selected(screen) , c)
         end
         c.hidden = true
      end

      -- Focus and raise if hidden
      if c.hidden then
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
         c:raise()
         capi.client.focus = c

      else -- Hide and detach tags if not
         if  hideOtherClients then 
            previous_dropped_client.hidden=true
         else
            previous_dropped_client.hidden=false
         end 
         c.hidden = true
         local tag_count=table.getn( capi.screen[mouse.screen]:tags())
         if tag_count >1 then
            local ctags = c:tags()
            for i, t in pairs(ctags) do
               ctags[i] = nil
            end
            c:tags(ctags)
         end
         
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

--setmetatable(_M, { __call = function(_, ...) return toggle(...) end })


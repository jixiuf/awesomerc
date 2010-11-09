--this function is the same to aweror.lua, but it isn't find client by it's class instance or anything ,but the uuid given by you
--  
--  awful.key({modkey,       }, "c",  function () run_or_raise_by_uuid("urxvtc","1") end),
--  awful.key({modkey,       }, "2",  function () run_or_raise_by_uuid("urxvtc -name emerge ","2") end),
----- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param prog   the program to execute
-- @param uuid    ,just a num or string to  make sure it is diffenert in different run_or_raise_by_uuid() key bindings 
local raises_clients = {}
--module("run_or_raise_by_id")
function run_or_raise_by_uuid(prog,uuid)
   if not  uuid then
      uuid=prog
   end
   
  if not raises_clients[uuid] then    --如果raises_clients 中没有关于uuid为uuid的记录，则新建之
      spawnw = function (c)
                  raises_clients[uuid] = c
                  c:raise()
                  client.focus = c
                  client.remove_signal("manage", spawnw)
               end
      client.add_signal("manage", spawnw)
      awful.util.spawn_with_shell(prog, false)
   else   --否则，还要做一个判断，即raises_clients中关于uuid 的client 是否还存在，
      if  raises_clients[uuid] then
         c = raises_clients[uuid]
         exists=false
         clients =client.get()
         for i, nextclient in pairs(clients) do
            if c==nextclient then
               exists=true
               break
            end
         end
         if exists then    --如果存在，切换到其所在标签
            c = raises_clients[uuid]
            c:raise()
            client.focus = c
            local ctags = c:tags()
            if table.getn(ctags) == 0 then
               local curtag = awful.tag.selected()
               awful.client.movetotag(curtag, c)
            else
               awful.tag.viewonly(ctags[1])
            end
            client.focus = c
            c:raise()
         else           --如果不存在，这里代码中上面相同
            spawnw = function (c)
                        raises_clients[uuid] = c
                        c:raise()
                        client.focus = c
                        client.remove_signal("manage", spawnw)
                     end
            client.add_signal("manage", spawnw)
            awful.util.spawn_with_shell(prog, false)
         end 
      end
   end
end


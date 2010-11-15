require("shifty")
require("jixiuf_util")        
--this function will toggle the program prog in tag tagName
--this means when hidden the program ,the tag will be destory
--      ,and when show this prog then it will create tag 'tagName' and show it in 
--for example ,when you press modkey+F2 ,it will run evim (or find an existed one with class=Evim)
-- and when you press again ,the evim will hidden and the tag evim will be destory
-- awful.key({ modkey }, "F2", function () toggle_tag_with_shifty("evim" ,"evim",{class="Evim"}) end),
-- @param  prog        the program you want to run 
-- @param  tagName     the tag you want the 'prog' to put  in         
-- @param  props4match    a property table about client to match ,now only support: class instance name type role.
function toggle_tag_with_shifty(prog,tagName,props4match)
   if tagName == nil then tagName=prog end
   local prog_tag=shifty.name2tag(tagName,mouse.screen)  --maybe nil
   local matched_clients=find_matched_clients(props4match)
   --put all the client in prog_tag except matched_clients
   local other_clients_in_prog_tag=find_unmatched_clients_in_tag(prog_tag,matched_clients)
   
   if prog_tag then
      if    awful.tag.selected(mouse.screen) ~=prog_tag  then  --try to show the clint in the tag
         _show(matched_clients,prog_tag,prog)
      else --  try to move all unmatched client to other tags ,then try to untouch all clients in prog_tag  and destory prog_tag
         --- trey to move unmatched clients to prev_tag( cyclely) ,(just try ,maybe this is the only tag)
         for j,other_c_in_prog_tag in ipairs(other_clients_in_prog_tag ) do
            send2prev_tag(other_c_in_prog_tag)
         end
         --untouch  and hide all clients in prog_tag ,include unmatched and matched clients
         for j,c_in_prog_tag in ipairs( prog_tag:clients() ) do
            local ctags = c_in_prog_tag:tags()
            for l, t in pairs(ctags) do
               ctags[l] = nil
            end
            c_in_prog_tag:tags(ctags)
            c_in_prog_tag.hidden=true
         end
         shifty.del(prog_tag) --try to del this tag 
      end

   else  -- if prog_tag don't exists ,then create one ,show the matched clients in it ,or create new client and show it 
      prog_tag= shifty.add({name=tagName,rel_index=1})
      _show(matched_clients,prog_tag,prog)
   end
end
--private function ,don't try to call this function
--show the matched clients in prog_tag ,if no matched_clients then create new client and show it 
function _show(matched_clients ,prog_tag,prog)
   if #matched_clients>0 then
      -- move matched clients to prog_tag
      for j ,c in ipairs (matched_clients) do
         awful.client.movetotag( prog_tag , c) 
         awful.tag.viewonly(prog_tag)
         c.hidden=false
         c.above = true
         c:raise()
         client.focus = c 
      end
   else
      --create new clients and show it in prog_tag
      awful.tag.viewonly(prog_tag)
      awful.util.spawn_with_shell(prog)
   end
   
end
--@param props4match  :a table about the client to match ,for example {class="Evim" ,instance="evim"}
function find_matched_clients(props4match)
   local  clients = client.get() --all clients on this screen
   local matched_clients={}
   for i, c in ipairs(clients) do
      local match_count=0
      local props_count=0
      if props4match.class      then props_count=props_count+1 if c.class ==props4match.class        then  match_count=match_count+1   end end
      if props4match.instance   then props_count=props_count+1 if c.instance ==props4match.instance  then  match_count=match_count+1   end end
      if props4match.name       then props_count=props_count+1 if c.name ==props4match.name          then  match_count=match_count+1   end end
      if props4match.type       then props_count=props_count+1 if c.type ==props4match.type          then  match_count=match_count+1   end end
      if props4match.role       then props_count=props_count+1 if c.role ==props4match.role          then  match_count=match_count+1   end end
      if match_count>0 and match_count== props_count then 
         table.insert(matched_clients ,c)
      end
      --      debug_("mc=" .. match_count .. ",pc=" .. props_count)
   end
   return matched_clients
end

-- return all clients in tag except those in matched_clients or empty table
function find_unmatched_clients_in_tag(tag ,matched_clients)
   local other_clients_in_tag={}
   if  tag then
      for i, client_in_tag in ipairs(tag:clients()) do 
         local matched=false
         for j ,matched_c in ipairs (matched_clients) do
            if client_in_tag ==matched_c then  matched=true break end
         end
         if matched ==false then table.insert(other_clients_in_tag, client_in_tag) end
      end
   end
   return other_clients_in_tag
end
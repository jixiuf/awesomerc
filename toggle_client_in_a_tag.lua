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
local toggled_clients={}
function toggle_tag_with_shifty(prog,tagName,props4match)
   if tagName == nil then tagName=prog end
   local prog_tag=shifty.name2tag(tagName,mouse.screen)  --maybe nil
   if prog_tag then
      local matched_clients  = find_matched_clients(props4match)
      --      local clients_in_tag = awful.client.visible(mouse.screen)
      local clients_in_tag = prog_tag:clients()
      local is_matched_client_in_its_tag=false
      for i,c in pairs(matched_clients) do
         for j ,c2 in pairs(clients_in_tag) do 
            if c== c2 then
               is_matched_client_in_its_tag=true break
            end
         end
      end
      if awful.tag.selected() ==prog_tag and is_matched_client_in_its_tag then
         hide_client(prog_tag ,props4match) shifty.del(prog_tag) --try to del this tag 
      else show_matched_client(props4match,tagName,prog,nil) end
      is_matched_client_in_its_tag=false
   else  -- if prog_tag don't exists ,then create one ,show the matched clients in it ,or create new client and show it 
      show_matched_client(props4match,tagName,prog,nil)
   end
   
   
end
--@param props4match  :a table about the client to match ,for example {class="Evim" ,instance="evim"}
function find_matched_clients(props4match)
   local  clients = client.get() --all clients on this screen
   local matched_clients={}
   for i, c in ipairs(clients) do
      local match_count=0
      local props_count=0
      if props4match.class    then props_count=props_count+1 if c.class ==props4match.class       then match_count=match_count+1 end end
      if props4match.instance then props_count=props_count+1 if c.instance ==props4match.instance then match_count=match_count+1 end end
      if props4match.name     then props_count=props_count+1 if c.name ==props4match.name         then match_count=match_count+1 end end
      if props4match.type     then props_count=props_count+1 if c.type ==props4match.type         then match_count=match_count+1 end end
      if props4match.role     then props_count=props_count+1 if c.role ==props4match.role         then match_count=match_count+1 end end
      if match_count>0 and match_count== props_count then 
         table.insert(matched_clients ,c)
      end
   end
   return matched_clients
end

-- return all clients in tags which don't match props4match
function find_unmatched_clients_in_tag(tag ,props4match)
   local matched_clients=find_matched_clients(props4match)
   local other_clients_in_tag={}
   if  tag then
      --    for i, client_in_tag in ipairs(tag:clients()) do 
      local clients_in_tag 
      if awful.tag.selected() ~= tag then clients_in_tag=tag:clients()
      else clients_in_tag=awful.client.visible(mouse.screen) end
      for i, client_in_tag in ipairs(clients_in_tag) do 
         if table.getn(client_in_tag:tags()) then
         end
         local matched=false
         for j ,matched_c in ipairs (matched_clients) do
            if client_in_tag ==matched_c then  matched=true break end
         end
         if matched ==false then table.insert(other_clients_in_tag, client_in_tag) end
      end
   end
   return other_clients_in_tag
end

--  show_matched_client({class="Emacs" ,instance="emacs"},"emacs","/usr/bin/emacsclient -c " ,nil)
--show all clients match props4match, in prog_tag_name
--(if prog_tag_name= nil then current tag,if prog_tag_name doesn't exist ,create new one),
--if don't exists matched client then it will try to 
--run a cmd with awful.util.spawn_with_shell(prog) and run
--run a lua  awful.util.eval(run)
-- if prog or run is nil then it do nothing 
--   awful.key({ modkey }, "F2", function () show_matched_client({class="Evim" ,instance="evim"},"evim","evim",nil ) end),
-- or you even can use it like this  
-- echo 'show_matched_client({class="Evim" ,instance="evim"},"evim","evim",nil )'|awesome-client 
--@param props4match : a table 4 find out the matched client ,prop may be class instance type name role of a client 
--@ prog_tag_name    :a tag name will show the found clients in it ,maybe nil ,maybe a don't exists tag name(we will create it for you ) 

function show_matched_client( props4match,prog_tag_name,prog,run)
   --debug_(#dropdown)
   if props4match ==nil then return end
   local prog_tag=nil
   if prog_tag_name then
      prog_tag=shifty.name2tag(prog_tag_name,mouse.screen)  --maybe nil
      if prog_tag==nil then  prog_tag=shifty.add({name=prog_tag_name,rel_index=1}) end
   end
   local matched_clients=find_matched_clients(props4match)
   local unmatched_clients =find_unmatched_clients_in_tag(prog_tag ,props4match) 
   if #matched_clients>0 then
      -- move matched clients to prog_tag
      for j ,c in ipairs (matched_clients) do
         if prog_tag then
            awful.client.movetotag( prog_tag  , c) 
            awful.tag.viewonly(prog_tag)
         end
         c.hidden=false
         c.above = true
         c:raise()
         client.focus = c 
      end
   else --create new clients and show it in prog_tag
      if prog_tag then
         awful.tag.viewonly(prog_tag)
      end
      if prog then  --if param is not nil ,then spawnw it ,add add it a manage and unmanage signl
         -- un_spawnw= function (c) --a unmanage signal ,when it unmanage ,try to destory this its tag
         --               for scr, cl in pairs(toggled_clients) do
         --                  if cl == c then
         --                     hide_client(prog_tag ,props4match )
         --                     shifty.del(prog_tag) 
         --                     toggled_clients[scr]=nil
         --                  end
         --               end
         --            end
         -- if not toggled_clients[prog] then 
         --    client.add_signal("unmanage", un_spawnw) 
         -- end 
         spawnw = function (c)
                     c:raise() client.focus = c
                     toggled_clients[prog]=c
                     client.remove_signal("manage", spawnw)
                  end
         client.add_signal("manage", spawnw)
         awful.util.spawn_with_shell(prog)
      end
      if run then awful.util.eval(run) end 
   end
          --- try to move unmatched clients to prev_tag( cyclely) ,(just try ,maybe this is the only tag)
      for j,other_c_in_prog_tag in ipairs(unmatched_clients) do
         if (#screen[mouse.screen]:tags()>1) then
            sendClient2Tag_by_tagName(other_c_in_prog_tag ,"tail") --      send2prev_tag(other_c_in_prog_tag)
            -- I have a tag named tail ,and I wouldn't use it ,so i can send unused client to tail tag
         else other_c_in_prog_tag:kill() end
      end
end

--send  all unmatched clients in this tag  to other tags ,and hide all matched clients
function hide_client( prog_tag,props4match)
   local unmatched_clients=find_unmatched_clients_in_tag(prog_tag,props4match)
   local matched_clients=find_matched_clients(props4match)

         --- trey to move unmatched clients to prev_tag( cyclely) ,(just try ,maybe this is the only tag)
   for j,other_c_in_prog_tag in ipairs(unmatched_clients) do
      if (#screen[mouse.screen]:tags()>1) then
--      send2prev_tag(other_c_in_prog_tag)
         sendClient2Tag_by_tagName(other_c_in_prog_tag ,"tail") 
 -- I have a tag named tail ,and I wouldn't use it ,so i can send unused client to tail tag
   else 
      other_c_in_prog_tag:kill()
   end

   end
   for j,matched_c in ipairs(matched_clients ) do
         local ctags = matched_c:tags()
         for l, t in pairs(ctags) do
            ctags[l] = nil
         end
         matched_c:tags(ctags)
         matched_c.hidden=true
   end
end

function hide_matched_clients(props4match)
   local matched_clients=find_matched_clients(props4match)
   for j,matched_c in ipairs(matched_clients ) do
      matched_c.hidden=true
   end
end

function hide_emacs()
--   hide_client("emacs" , {class="Emacs" ,instance="emacs"})
   local matched_clients=find_matched_clients({class="Emacs" ,instance="emacs"})
      for j,matched_c in ipairs(matched_clients ) do
         local ctags = matched_c:tags()
         for l, t in pairs(ctags) do
            ctags[l] = nil
         end
         matched_c:tags(ctags)
         matched_c.hidden=true
      end
end

function show_emacs()
  show_matched_client({class="Emacs" ,instance="emacs"},"emacs","/usr/bin/emacsclient -c " ,nil)
end

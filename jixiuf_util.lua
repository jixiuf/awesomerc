--same to shifty.send(idx) 
--but shifty.send can only send the focused client ,
--so I add those functions
function sendClient2Tag(c ,tagIdx)
     local scr = client.focus.screen or mouse.screen
  local sel = awful.tag.selected(scr)
  local sel_idx = shifty.tag2index(scr,sel)
  local tags = screen[scr]:tags()
  local targetTag = awful.util.cycle(#tags, sel_idx + tagIdx)
  awful.client.movetotag(tags[targetTag], c)
end
--send the client to previous tag ,cyclely
function send2prev_tag(c)
   sendClient2Tag(c ,-1)
end 
--send the client to next tag ,cyclely
function send2next_tag(c)
   sendClient2Tag(c ,1)
end 


function viewTag(tagIdx)
  local scr = client.focus.screen or mouse.screen
  local sel = awful.tag.selected(scr)
  local sel_idx = shifty.tag2index(scr,sel)
  local tags = screen[scr]:tags()
  local targetTag = awful.util.cycle(#tags, sel_idx + tagIdx)
  awful.tag.viewonly(tags[targetTag])
end
--maybe awful.tal.viewnext ,is ok
function viewNextTagCyclely()
   viewTag(1)
end

function viewPrevTagCyclely()
   viewTag(-1)
end


function moveTag2Last (targetTagName )
            local targetTag=shifty.name2tag(targetTagName,mouse.screen,1)
            local tags= screen[mouse.screen]:tags()
            local tag_count=table.getn(tags)
            if targetTag == nil or tag_count<2 then return end
            
            local targetTag_index=-1
            local lastTag=tags[tag_count]
            
            if targetTag ~= lastTag then
               for i, t in pairs(tags) do
                  if t == targetTag then
                     targetTag_index=i
                  end
               end
               tags[targetTag_index]=lastTag
               tags[tag_count]=targetTag
               screen[mouse.screen]:tags(tags)
            end
end


function sendClient2Tag_by_tagName(c ,tagName)
      local tag=shifty.name2tag(tagName,mouse.screen)  
      if tag == nil then
            tag= shifty.add({name=tagName})
      end
         awful.client.movetotag(tag, c)
end

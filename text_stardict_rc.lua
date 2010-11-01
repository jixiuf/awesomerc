 require("naughty")
 --使用了xsel程序,当用户选中一个单词后单击绑定的键,就会通过通知的方式显示出所查的单词
 -- 用到了stardict 词典的文本模式sdcv (需要安装)
--   awful.key({ modkey }, "d",function () query_word_from_selection() end),
 function  query_word_from_selection()

                                 local f = io.popen("xsel -o")
                                 local new_word = f:read("*a")
                                 f:close()

                                 if frame ~= nil then
                                    naughty.destroy(frame)
                                    frame = nil
                                    if old_word == new_word then
                                       return
                                    end
                                 end
                                 old_word = new_word

                                 local fc = ""
                                 local f  = io.popen("sdcv -n --utf8-output -u '朗道英汉字典5.0' "..new_word)
                                 for line in f:lines() do
                                    fc = fc .. line .. '\n'
                                 end
                                 f:close()
                                 frame = naughty.notify({ text = fc, timeout = 6, width = 320 ,icon="/usr/share/stardict/pixmaps/docklet_scan.png"})
                              end

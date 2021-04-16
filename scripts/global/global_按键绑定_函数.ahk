; ==========================================================
;
; [全局] global_按键绑定_函数.ahk
;
; 文档作者: tom
;
; 修改时间: 2021-03-10 01:43:43
;
; 为按键绑定, 提供精简的功能函数名, 以便让按键绑定界面更加整洁
;
; ==========================================================


; ==========================================================
; [keyPress_event] 热键绑定事件
; ==========================================================
; 绑定按键_函数命名_功能键简写约定:
; ctrl: c_ | shift: s_ | alt: a_ | win: w_
;
; 功能键一律小写加下换线
; 如caps键: caps_ 
; ----------------------------------------------------------


绑定_mbutton(){
    if(inWinList(Config.get("视频播放器"))){                 ;视频播放器自动居中1440*720
        快捷操作_移动当前窗口(5, {"w":1440, "h":797})
    }
    else{
        ;send % get_hot_key()
        send {MButton}
    }
}


c_w_q(){
    运行程序("D:\_home_\tom\program\green_program\应用软件\文件管理\Listary\Listary.exe")
}

c_w_tab(){
    keyPress_event()
}

a_w_f(){
    ; 用于收集多个带有序号_xxx的图片到同一个作品编号名目录下
    快速收集特征文件到目录_单目录("i)^([a-z]{2,5}-\d{3,5})", false)    
}

c_s_w_f(){
    快速收集特征文件到目录_单目录(format("i)#av.*?({1}|{2}|{3}|{4}|{5}|{6}).*"
                                        , "carib[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "1pon[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "CAPPV[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "heyzo[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "Avs[_-]museum[_-]\d{6}"
                                        , "[a-z]{2,5}-\d+")
                                , true)
}


caps(){
    show_msg("键屏蔽, 用ESC + Capslock代替.")   ; 屏蔽Capslock键
    打开剪贴板菜单()
}


a_f8(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口
        ; [可多选]显示所选文件的md5
        showFileHash("md5")
    }
    else{
        send % get_hot_key()
    }
}

c_a_f8(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口
        ; [可多选]显示所选文件的md5和hash
        showFileHash("")
    }
    else{
        send % get_hot_key()
    }
}

c_r(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, 按ctrl+r,
        ; 结果: 剪贴板 + 扩展名;
        f2自动重命名("regExp", Config.rename_regexMatch, Config.rename_regexReplace)
    }
    else if(inWinList(["#32770"], "class")){
        ; 另存为窗口, ctrl+r
        ; 结果: 剪贴板 + 扩展名;
        自动重命名("regExp", Config.rename_regexMatch, Config.rename_regexReplace)
    }
    else if(inWinList(["Chrome_WidgetWin_2"], "class")){
        ; 360浏览器自定义修改av收藏
        WinGetTitle, _winTitle, A
        if(_winTitle ~= "[收藏|书签]$")
        {
            Send ^a
            sleep 100
            _收藏名称:= Clipboarder.get("cut")
            write(Av.rename(_收藏名称))
        }
    }
    else{
        send % get_hot_key()
        ;提示热键无操作()
    }
}


c_a_r(){
    if(! 绑定_用剪贴板内容重命名()){
        send % get_hot_key()
    }
}


a_w_r(){
    绑定_用剪贴板内容重命名()
}


绑定_用剪贴板内容重命名(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, 按ctrl+alt+r
        ; 结果: 剪贴板内容 + 扩展名
        f2自动重命名("regExp", "^.+$", "{clipboard}")
        Return True
    }
    
    if(inWinList(["#32770"], "class")){
        ; 另存为窗口, 按ctrl+alt+r
        ; 结果: 剪贴板内容 + 扩展名"
        自动重命名("regExp", "^.+$", "{clipboard}")
        Return True
    }

    Return False
}

c_s_r(){
    if(! 绑定_撤销重命名操作()){
        send % get_hot_key()
    }
}

a_f2(){
   if(! 绑定_av文件名_重命名()){
        send % get_hot_key()
    } 
}

绑定_av文件名_重命名(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口,
        ; 结果: 剪贴板 + 扩展名;
        f2自动重命名("av")
        Return true
    }

    Return False
}

s_f2(){
    if(inWinList(Config.get("资源管理器"))){
        if(! 绑定_撤销重命名操作()){
            send +{f2}
        }
    }
    else{
        send +{f2}
    }
}


绑定_撤销重命名操作(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口,
        ; undo撤销操作
        f2自动重命名("undo")
        Return True
    }
    Return False
}




; ==========================================================
; 常用功能函数 脚本内置功能
; ==========================================================

绑定_从文件名获取AV作品编号_重命名(){
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, 按ctrl+r,
        ; 结果: 剪贴板 + 扩展名;
        f2自动重命名("function", "从图片文件名中获取AV作品编号", "")
        Return True
    }

    Return False
}


绑定_向左调整窗口(){
    if(inWinList(允许调整窗口白名单())){
        向左调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
}

绑定_向右调整窗口(){
    if(inWinList(允许调整窗口白名单())){
        向右调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
}

绑定_切换窗口x轴大小(){
    if(inWinList(Config.get("视频播放器"))){                 ;视频播放器自动居中1440*720
        快捷操作_移动当前窗口(5, {"w":1440, "h":797})
    }
    else if(inWinList(允许调整窗口白名单())){
        切换窗口x轴大小()                                     ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
}

绑定_切换窗口y轴大小(){
    if(inWinList(Config.get("视频播放器"))){                 ;视频播放器自动居中1440*720
        快捷操作_移动当前窗口(5, {"w":1440, "h":797})
    }
    else if(inWinList(允许调整窗口白名单())){
        切换窗口y轴大小()                                     ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
}

绑定_窗口屏幕居中(){
    if(inWinList(允许调整窗口白名单())){
        快捷操作_移动当前窗口(5)                             ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
}


打开脚本主目录(){
    打开窗口(A_ScriptDir)
}

打开用户主目录(){
    打开窗口("D:\_home_\tom")
}

打开脚本主菜单(){
    Menus.main_menu()
}

打开ahk本地帮助(){
    run "D:\_home_\tom\program\green_program\辅助工具\AutoHotkey\AutoHotkey.chm"
}

运行单元测试(){
    test_init()
    testContent.test()
    test_run()
}

增大音量(){
    Send {Volume_Up}
}

减小音量(){
    Send {Volume_Down}
}

剪贴板数组清洗_拼接_粘贴(){
    Clipboarder.clean()
    剪贴板数组_拼接_粘贴()
}

打开字符串文件(){
    _路径 := Clipboarder.get("copy")
    if(instr(_路径, "`r`n"))
        _路径 := trim(_路径, "`r`n")
    _路径 := trim(_路径, """")

    if(FileExist(_路径))
        run, % """" . _路径 . """"
    Else
        msgbox, % "指定文件路径不存在!`n" . _路径
}

打开字符串目录(){
    _路径 := Clipboarder.get("copy")
    if(instr(_路径, "`r`n"))
        _路径 := trim(_路径, "`r`n")
    _路径 := Path.parse(trim(_路径, """"))

    if(FileExist(_路径.dir))
        run, % """" . _路径.dir . """"
    Else
        msgbox, % "指定目录路径不存在!`n" . _路径.dir
}


; 添加备注_av女优
; 输出"#av女优# ★★★ 源字符串 tags(长相好看 美乳 美臀)"
添加备注_av女优(){
    _str := trim(Clipboarder.get("cut"))
    
    if(! InStr(_str,"#av女优#"))
        _str := format("#av女优# ★★ {1}", _str)
    
    if(! InStr(_str,"tags("))
        _str := format("{1} tags(长相好看 美丰乳 美臀)", _str)

    Clipboarder.write(_str)
}


; 添加备注_av作品
; 输出"#av作品# ★★★ 源字符串 tags(待剪辑 高画质 中字 后入)"
添加备注_av作品(){
    _str := trim(Clipboarder.get("cut"))
    
    if(! InStr(_str,"#av作品#"))
        _str := format("#av作品# ★★ {1}", _str)
    
    if(! InStr(_str,"tags("))
        _str := format("{1} tags(待剪辑 高画质 中字 后入)", _str)

    Clipboarder.write(_str)
}


; tags默认备注_av女优
tags默认备注_av女优(){
    write(format("tags({1})", Av.get_tags格式("av女优", false)))
    send {left 1}
    ; 帮助提示
    tags默认备注提示_av女优()
    Return
}


; tags默认备注提示_av女优()
tags默认备注提示_av女优(){
    ; 帮助提示
    show_text(Av.get_tags格式("av女优", true))
    Return
}    


; tags默认备注_av作品
tags默认备注_av作品(){
    write(format("tags({1})", Av.get_tags格式("av作品", false)))
    send {left 1}
    ; 帮助提示
    tags默认备注提示_av作品()
    Return
}

; tags默认备注提示_av作品()
tags默认备注提示_av作品(){
    ; 帮助提示
    show_text(Av.get_tags格式("av作品", true))
    Return
}




; ==========================================================
; 常用功能函数 第三方程序功能
; ==========================================================

; get_hot_key() 返回去除$以后的热键字符串
get_hot_key(){
    return StrReplace(A_ThisHotkey, "$",  "")
}


打开音速启动(){

    if WinExist("ahk_exe VStart.exe"){
        send % get_hot_key()
    }
    else{
        show_msg("启动->音速启动")
        运行程序("D:\_home_\tom\program\green_program\音速启动(VStart)V5\VStart.exe")
    }
}


打开文本编辑器(){
    运行程序("D:\_home_\tom\program\green_program\应用软件\编辑工具\EmEditor\EmEditor.exe")
}


打开计算器(){
    运行程序("D:\_home_\tom\program\green_program\开发工具\辅助工具\SpeQ Mathematics┊计算任意定义变量、复杂数学公式┊多国语言绿色免费版\SpeQ Mathematics.exe")
}


打开截图(){
    运行程序("D:\_home_\tom\program\green_program\图形图像\Snipaste\Snipaste.exe")
}


打开截图2(){
    运行程序("D:\_home_\tom\program\green_program\图形图像\FastStone Capture\FSCapture.exe")
}


打开制图工具(){
    run "https://app.diagrams.net/"
}

打开ocr文字识别(){
    运行程序("D:\_home_\tom\program\green_program\辅助工具\pandaOCR文字识别\PandaOCR.exe")
}


打开路由器(){
    run "http://10.0.0.1"
}


打开视频剪辑(){
    run %A_WorkingDir%\scripts\专用脚本\[tom实用工具] ffmpeg视频处理GUI.ahk
}


打开文件比较(){
    运行程序("D:\_home_\tom\program\green_program\应用软件\文件管理\Beyond Compare┊专业级文件及文件夹比较工具\Beyond Compare\BCompare.exe")
}


打开正则表达式编辑器(){
    运行程序("D:\_home_\tom\program\green_program\开发工具\[正则表达式]RegexBuddy\RegexBuddy.exe")
} 


打开windowspy(){
    run "D:\_home_\tom\program\green_program\辅助工具\AutoHotkey\tom工具包\WindowSpy.ahk"
}

; ==========================================================
; 常用功能函数 打开网站类
; ==========================================================
web_购物(){
    run "https://www.taobao.com/"
    sleep 200
    run "https://www.jd.com/"
}


web_下载(){
    run "https://www.downg.com/"
}


web_it(){
    run "http://detail.zol.com.cn"
}


web_财经(){
    run "http://rl.fx678.com"
    sleep 200
    run "http://live.wallstreetcn.com"
    sleep 200
    run "https://wallstreetcn.com/markets/home"
}


web_微博(){
    run "http://blog.sina.com.cn/u/1712177201"
}








; ==========================================================
; 临时性操作
; ==========================================================
临时测试1(){
    ; _test_items := {"源字符串":"", "处理结果":""}
    ; _test_items["源字符串"] := Clipboard
    ; _test_items["处理结果"] := 从图片文件名中获取AV作品编号(_test_items["源字符串"])
    ; list_print(_test_items)

    ;list1 := list(1,5,3,2,4,8, 7, 6, 9)
    ; list1.Push("a", "b", "c")
    ;list1.sort()
    ;show_debug(list1.join(" | "))

    显示结果 := ""


    list1 := [3, 5, 8, 1, 2, 9, 4, 7, 6]

    ;list1 := [3, 1, 5, 2, 4]
    ; list1 := [1,5,9,1,3,8,2,4,8, 7, 6, 9]
    ; list2 := ["c", "b", "c", "g", "f", "d", "a"]
    ; list3 := [1,5,9,1,3,8,"g", "f", "d"]
    
    ;list1.Push(list2*)
    ;list1.Push(list3*)    
    显示结果 .= Format("数组原来的 : {1}`n", list_join(list1, " | "))
    
    list1 := list_quick_sort(list1) 

    显示结果 .= Format("数组修改后 : {1}`n", list_join(list1, " | "))
    show_debug(显示结果)




    ; list4 := list_splice(list2, "hello", list1, list3)
    ; list_print(list4)


    

    ; list2 := [1,2,3,4,5]
    ; list_print(list2)
 
}



list_add(_list){
    _list.push("追加的新内容")
}

字典_add(_字典){
    _字典["电话"] := "18028165671"
}

使用函数对象(_函数名, _参数){
    _fn := Func(_函数名)
    _fn.call(_参数)
}

临时测试2(){
    ;keyPress_event()
    _tmp := ""
    if(获取用户密码输入(_tmp, "", "随便输入一个内容")){
        show_msg(_tmp)
    }
}

临时测试3(){    
    ;av_测试分析剪贴板()
    ; 收集特征文件到目录_单目录(".*?([a-zA-Z]{2,5}-\d+).*"
    ;         , "D:\_home_data_\desktop\ahktest"
    ;         , "D:\_home_data_\desktop\收集目录")

    _特征组 := 根据特征分组("i).*?(carib[^-]*[_-]\d{6}[_-]\d{3}|1pon[^-]*[_-]\d{6}[_-]\d{3}|[a-z]{2,5}-\d+).*"
            , ["#av作品# ★★★ JUY-822 被跳槽的女上司工作中一直玩弄的新人 友田真希 tags(风骚 极品诱惑).jpg"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).torrent"
                , "#av作品# ★★★ JUY-822 被跳槽的女上司工作中一直玩弄的新人 友田真希 tags(风骚 极品诱惑).mp4"
                , "#av作品# ★★★ JUY-915 互相争夺我的两人妻 友田真希 早川瑞希 tags(中字 双飞 湿吻 呻吟 风骚 极品诱惑).jpg"
                , "#av作品# ★★★ JUY-915 我的两人妻 友田真希 早川瑞希 tags(中字 双飞 湿吻 呻吟 风骚 极品诱惑).mp4"
                , "#av作品# ★★★ carib-100218-764 早抜き 中島京子 tags(无码 舔逼 抠逼 风骚 后入 极品诱惑).jpg"
                , "#av作品# ★★★ carib-100218-764 早抜き 中島京子 tags(无码 舔逼 抠逼 风骚 后入 极品诱惑).txt"
                , "#av作品# ★★★ 1pon-112018-001 天使の誘惑_スペシャル版 水鳥文乃 tags(不能压缩会变灰 美颜 无码 呻吟).jpg"
                , "#av作品# ★★★ 1pon-112018-001 天使の誘惑_スペシャル版 水鳥文乃 tags(不能压缩会变灰 美颜 无码 呻吟).mp4"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).jpg"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).mp4"])
    list_print(_特征组)

    ; 快捷批量重命名文件或目录("regExp"
    ;                         , format("i)#av.*?({1}|{2}|{3}|{4}|{5}).*"
    ;                                     , "carib[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "1pon[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "CAPPV[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "Avs[_-]museum[_-]\d{6}"
    ;                                     , "[a-z]{2,5}-\d+")
    ;                         , _regexReplace:="$1")
}

临时测试4(){
    _复制窗口标题 := (获取窗口信息()).window.title
    Clipboard := _复制窗口标题
    show_msg("窗口标题:`n" . _复制窗口标题 . "`n`n===== 已复制到剪贴板 =====")
}

临时测试5(){
    msgbox, 当前函数%A_ThisFunc%(), 暂无测试内容
}

keyPress_event(){
    _hotkey := A_ThisHotkey
    MsgBox, % "当前快捷键:`n" . _hotkey
}







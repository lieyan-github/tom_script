﻿; ==========================================================
;
; [全局]操作控制中心, 集中所有全局快捷操作
;
; 文档作者: 烈焰
;
; 修改时间: 2019-01-19 14:47:10
;
; ==========================================================

^#Tab::
    ;send {Space 4}
    keyPress_event()
Return

keyPress_event(){
        _hotkey := A_ThisHotkey
        MsgBox, % _hotkey
    }


!#f::
    ; 用于收集多个带有序号_xxx的图片到同一个作品编号名目录下
    快速收集特征文件到目录_单目录("i)^([a-z]{2,5}-\d{3,5})", false)
return

; av目录文件收集整理
^+#f::
    快速收集特征文件到目录_单目录(format("i)#av.*?({1}|{2}|{3}|{4}|{5}|{6}).*"
                                        , "carib[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "1pon[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "CAPPV[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "heyzo[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "Avs[_-]museum[_-]\d{6}"
                                        , "[a-z]{2,5}-\d+")
                                , true)
return


^#f9::
    ;av_测试分析剪贴板()
    ; 收集特征文件到目录_单目录(".*?([a-zA-Z]{2,5}-\d+).*"
    ;         , "D:\_home_data_\desktop\ahktest"
    ;         , "D:\_home_data_\desktop\收集目录")

    _特征组 := 根据特征分组("i).*?(carib[^-]*[_-]\d{6}[_-]\d{3}|1pon[^-]*[_-]\d{6}[_-]\d{3}|[a-z]{2,5}-\d+).*"
            , ["#av作品# ★★★ JUY-822 被跳槽的女上司工作中一直玩弄的新人 友田真希 tags(风骚 极品诱惑).jpg"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).torrent"
                , "#av作品# ★★★ JUY-822 被跳槽的女上司工作中一直玩弄的新人 友田真希 tags(风骚 极品诱惑).mp4"
                , "#av作品# ★★★ JUY-915 互相争夺我的两人妻 友田真希 早川瑞希 tags(中字 双飞 湿吻 呻吟 风骚 极品诱惑).jpg"
                , "#av作品# ★★★ JUY-915 互相争夺我的两人妻 友田真希 早川瑞希 tags(中字 双飞 湿吻 呻吟 风骚 极品诱惑).mp4"
                , "#av作品# ★★★ carib-100218-764 早抜き 中島京子 tags(无码 舔逼 抠逼 风骚 后入 极品诱惑).jpg"
                , "#av作品# ★★★ carib-100218-764 早抜き 中島京子 tags(无码 舔逼 抠逼 风骚 后入 极品诱惑).txt"
                , "#av作品# ★★★ 1pon-112018-001 天使の誘惑_スペシャル版 水鳥文乃 tags(不能压缩会变灰 美颜 无码 呻吟).jpg"
                , "#av作品# ★★★ 1pon-112018-001 天使の誘惑_スペシャル版 水鳥文乃 tags(不能压缩会变灰 美颜 无码 呻吟).mp4"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).jpg"
                , "#av作品# ★★★ Caribbean-122317-562 令嬢と召使 ～足で踏まれて感じてんの 水鳥文乃 tags(高画质 无码 风骚 后入诱惑).mp4"])
    arrayPrint(_特征组)

    ; 快捷批量重命名文件或目录("regExp"
    ;                         , format("i)#av.*?({1}|{2}|{3}|{4}|{5}).*"
    ;                                     , "carib[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "1pon[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "CAPPV[^-]*[_-]\d{6}[_-]\d{3}"
    ;                                     , "Avs[_-]museum[_-]\d{6}"
    ;                                     , "[a-z]{2,5}-\d+")
    ;                         , _regexReplace:="$1")
    return

^#f12::
    单元测试()
    return

单元测试(){
    test_init()
    testContent.test()
    test_run()
}

; 快捷复制窗口标题
#!RButton::
    _复制窗口标题 := (获取窗口信息()).window.title
    Clipboard := _复制窗口标题
    show_msg("窗口标题:`n" . _复制窗口标题 . "`n`n===== 已复制到剪贴板 =====")
Return

; 快捷复制 发现bug无法右键选择区域
; $RButton::
;     ; 鼠标左键如果在按下, 同时按下右键为复制
;     if GetKeyState("LButton") {
;         send ^c
;         show_msg("已复制选择内容:`n" . Clipboard)
;     }
;     else
;         send {RButton}
; Return


; ----------------------------------------------------------
; [ 热键用到的快捷操作 ]
; ----------------------------------------------------------
打开ahk在线帮助(){
    run "https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm"
}

打开ahk帮助(){
    run "D:\_home_\tom\program\green_program\辅助工具\AutoHotkey\AutoHotkey.chm"
}

打开编辑器(){
    运行程序("D:\_home_\tom\program\green_program\应用软件\编辑工具\EmEditor\EmEditor.exe")
}

打开计算器(){
    运行程序("D:\_home_\tom\program\green_program\开发工具\辅助工具\SpeQ Mathematics┊计算任意定义变量、复杂数学公式┊多国语言绿色免费版\SpeQ Mathematics.exe")
}

打开截图(){
    运行程序("D:\_home_\tom\program\green_program\图形图像\FastStone Capture\FSCapture.exe")
}

打开文件比较(){
    运行程序("D:\_home_\tom\program\green_program\应用软件\文件管理\Beyond Compare┊专业级文件及文件夹比较工具\Beyond Compare\BCompare.exe")
}

打开路由器(){
    run "http://10.0.0.1"
}

web网购(){
    run "http://www.taobao.com"
}

;注释 web下载软件()
web下载软件(){
    run "http://www.downg.com"
}

web查报价(){
    run "http://detail.zol.com.cn"
}

web微博(){
    run "http://blog.sina.com.cn/u/1712177201"
}

web财经(){
    run "http://rl.fx678.com"
    sleep 200
    run "http://live.wallstreetcn.com"
    sleep 200
    run "https://wallstreetcn.com/markets/home"
}

打开正则表达式编辑器(){
    运行程序("D:\_home_\tom\program\green_program\开发工具\[正则表达式]RegexBuddy\RegexBuddy.exe")
}

打开音速启动(){
    if WinExist("ahk_exe VStart.exe")
        send !``
    else{
        show_msg("启动->音速启动")
        运行程序("D:\_home_\tom\program\green_program\音速启动(VStart)V5\VStart.exe")
    }
}

; ----------------------------------------------------------
; 全局快捷键
; ----------------------------------------------------------
; [ 常用功能设置]
; ----------------------------------------------------------
;#e::                                                        ; 打开home目录
#home::打开窗口("D:\_home_\tom")

^#RButton::
^#home::打开窗口(A_ScriptDir)                                ; 打开脚本主目录

#RButton::                                                  ;打开主菜单
AppsKey::Menus.main_menu()

$!`::打开音速启动()

; ----------------------------------------------------------
; [全局]win & F1-F12        打开软件
; ----------------------------------------------------------
^+#f1::打开ahk在线帮助()                                     ;
^#f1::打开ahk帮助()                                             ; AHK帮助

#f1::打开编辑器()
#f2::打开计算器()
#f3::打开截图()
#f4::run %A_WorkingDir%\scripts\专用脚本\[tom实用工具] ffmpeg视频处理GUI.ahk
#f5::script_reload()
#f6::打开文件比较()
#f7::提示热键无操作()
#f8::打开文件操作菜单()
#f9::arrayPrint(获取窗口信息(), 1024, 768)                   ; 调试: 设置断点调试
#f10::打开正则表达式编辑器()                                  ; 调试: 调试保留备用    - 打开正则表达式
#f11::run "D:\_home_\tom\program\green_program\辅助工具\AutoHotkey\tom工具包\WindowSpy.ahk"    ; 调试: 单步调试        - 打开spy探针
#f12::Menus.main_menu()                                     ; 调试: 打开配置文件
^+#del::批量关闭进程(JsonFile.read(Config.upath("批量关闭程序")))

; ----------------------------------------------------------
; [全局]win & 数字          打开web
; ----------------------------------------------------------
#`::web财经()
#1::web网购()
#2::web下载软件()
#3::web查报价()
#4::web财经()
#5::web微博()
#6::提示热键无操作()
#7::提示热键无操作()
#8::提示热键无操作()
#9::提示热键无操作()
#0::打开路由器()
; ----------------------------------------------------------
; [全局] Capslock  组合键
;
; 帮助参考 基本用法/热键/"Alt-Tab 热键"
; ----------------------------------------------------------
; Capslock & F1-F12
Capslock & f1::Log.print()
Capslock & f2::提示热键无操作()
Capslock & f3::提示热键无操作()
Capslock & f4::提示热键无操作()
Capslock & f5::提示热键无操作()
Capslock & f6::提示热键无操作()
Capslock & f7::提示热键无操作()
Capslock & f8::提示热键无操作()
Capslock & f9::提示热键无操作()
Capslock & f10::提示热键无操作()
Capslock & f11::提示热键无操作()
Capslock & f12::提示热键无操作()

; Capslock & ` 1-9 0
Capslock & `::粘贴来自剪贴板数组()   ;获取最新一个内容
Capslock & 1::粘贴来自剪贴板数组(1)
Capslock & 2::粘贴来自剪贴板数组(2)
Capslock & 3::粘贴来自剪贴板数组(3)
Capslock & 4::提示热键无操作()
Capslock & 5::提示热键无操作()
Capslock & 6::提示热键无操作()
Capslock & 7::提示热键无操作()
Capslock & 8::提示热键无操作()
Capslock & 9::提示热键无操作()
Capslock & 0::提示热键无操作()

; Capslock & a - z
Capslock & a::提示热键无操作()
Capslock & b::提示热键无操作()
Capslock & c::提示热键无操作()
Capslock & d::提示热键无操作()
Capslock & e::提示热键无操作()
Capslock & f::提示热键无操作()
Capslock & g::提示热键无操作()
Capslock & h::提示热键无操作()
Capslock & i::提示热键无操作()
Capslock & j::提示热键无操作()
Capslock & k::提示热键无操作()
Capslock & l::提示热键无操作()
Capslock & m::提示热键无操作()
Capslock & n::提示热键无操作()
Capslock & o::提示热键无操作()
Capslock & p::提示热键无操作()
Capslock & q::提示热键无操作()
Capslock & r::提示热键无操作()
Capslock & s::提示热键无操作()
Capslock & t::提示热键无操作()
Capslock & u::提示热键无操作()
Capslock & v::提示热键无操作()
Capslock & w::提示热键无操作()
Capslock & x::提示热键无操作()
Capslock & y::提示热键无操作()
Capslock & z::提示热键无操作()

; Capslock & 常用符号
Capslock & -::提示热键无操作()
Capslock & =::提示热键无操作()
Capslock & [::提示热键无操作()
Capslock & ]::提示热键无操作()
Capslock & \::提示热键无操作()
Capslock & `;::提示热键无操作()
Capslock & '::提示热键无操作()
Capslock & ,::提示热键无操作()
Capslock & .::提示热键无操作()
Capslock & /::提示热键无操作()

; Capslock & 功能键
Capslock & Esc::提示热键无操作()
Capslock & Tab::提示热键无操作()
Capslock & Space::提示热键无操作()
Capslock & Backspace::提示热键无操作()
Capslock & Enter::提示热键无操作()

Capslock & Home::提示热键无操作()
Capslock & End::提示热键无操作()
Capslock & PgUp::提示热键无操作()
Capslock & PgDn::提示热键无操作()

Capslock & Up::提示热键无操作()
Capslock & Down::提示热键无操作()
Capslock & Left::提示热键无操作()
Capslock & Right::提示热键无操作()

Capslock & Delete::提示热键无操作()
Capslock & Insert::提示热键无操作()

Capslock & Pause::提示热键无操作()
Capslock & PrintScreen::提示热键无操作()

; ----------------------------------------------------------
; [全局]Ctrl & 小键盘数字       打开软件
; ----------------------------------------------------------
^Numpad0::提示热键无操作()
^Numpad1::打开编辑器()
^Numpad2::打开计算器()
^Numpad3::打开截图()
^Numpad4::提示热键无操作()
^Numpad5::提示热键无操作()
^Numpad6::提示热键无操作()
^Numpad7::提示热键无操作()
^Numpad8::提示热键无操作()
^Numpad9::提示热键无操作()
; ----------------------------------------------------------
; [全局]Alt & 小键盘数字        打开web
; ----------------------------------------------------------
!Numpad0::提示热键无操作()
!Numpad1::提示热键无操作()
!Numpad2::提示热键无操作()
!Numpad3::提示热键无操作()
!Numpad4::提示热键无操作()
!Numpad5::提示热键无操作()
!Numpad6::提示热键无操作()
!Numpad7::提示热键无操作()
!Numpad8::提示热键无操作()
!Numpad9::提示热键无操作()
; ----------------------------------------------------------
; [全局]多媒体键盘快捷键
; ----------------------------------------------------------
Launch_Media::提示热键无操作()          ;fn+f3
Media_Prev::提示热键无操作()            ;fn+f4
Media_Play_Pause::提示热键无操作()      ;fn+f5
Media_Next::提示热键无操作()            ;fn+f6
;Volume_Mute::提示热键无操作()           ;fn+f7
;Volume_Down::提示热键无操作()           ;fn+f8
;Volume_Up::提示热键无操作()             ;fn+f9
; -------------------------------
; fn快捷键 无法实现
Browser_Back::提示热键无操作()
Browser_Forward::提示热键无操作()
Browser_Refresh::提示热键无操作()
Browser_Stop::提示热键无操作()
Browser_Search::提示热键无操作()
Browser_Favorites::提示热键无操作()
Browser_Home::提示热键无操作()
; -------------------------------
Media_Stop::提示热键无操作()
Launch_Mail::提示热键无操作()
Launch_App1::提示热键无操作()
Launch_App2::提示热键无操作()
; ----------------------------------------------------------
; 音量控制
; ----------------------------------------------------------
#up::Send {Volume_Up}
#down::Send {Volume_Down}
#WheelUp::Send {Volume_Up}
#WheelDown::Send {Volume_Down}
; ----------------------------------------------------------
; [lib_搜索]快捷搜索
; ----------------------------------------------------------
#q::打开搜索菜单()                   ;搜索菜单
^#q::运行程序("D:\Program Files\Listary\Listary.exe")

; ----------------------------------------------------------
; 剪贴板数组
; ----------------------------------------------------------
; 打开
; Capslock用ESC + Capslock代替
$Capslock::
    show_msg("键屏蔽, 用ESC + Capslock代替.")   ; 屏蔽Capslock键
    打开剪贴板菜单()
    Return

; Capslock 操作剪贴板数组
; 方案一
^Capslock::清空并复制到剪贴板数组()
#Capslock::复制到剪贴板数组()
!Capslock::剪贴板数组拼接并粘贴()
+Capslock::Clipboarder.clean()
^!Capslock::
^#Capslock::
    Clipboarder.clean()
    剪贴板数组拼接并粘贴()
    Return


; 设置: 复制到剪贴板
^#`::清空并复制到剪贴板数组()
^#1::复制到剪贴板数组(1)
^#2::复制到剪贴板数组(2)
^#3::复制到剪贴板数组(3)
^#4::复制到剪贴板数组(4)
^#5::复制到剪贴板数组(5)
^#6::复制到剪贴板数组(6)

; 获取: 粘贴自剪贴板


; ----------------------------------------------------------
; [字符串类]加密/解密字符串
; ----------------------------------------------------------
^#e::加密字符串()
^#d::解密字符串()
; ----------------------------------------------------------
; [文件目录类]检查文件的md5和sha值
; ----------------------------------------------------------
; 资源管理器窗口
; ---------------------------------------
$!f8::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口
        ; [可多选]显示所选文件的md5
        showFileHash("md5")
    }
    else{
        send !{f8}
    }
return

$^!f8::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口
        ; [可多选]显示所选文件的md5和hash
        showFileHash("")
    }
    else{
        send ^!{f8}
    }
return

; ----------------------------------------------------------
; [功能实现部分] 文件目录类
; ----------------------------------------------------------

; 快速打开字符串文件, 根据选中的路径字符串
#Enter::
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

; 快速打开字符串目录, 根据选中的路径字符串
+#Enter::
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

; 快速编辑字符串文件, 根据选中的路径字符串
!#Enter::
    提示热键无操作()


; ---------------------------------------
; 资源管理器窗口 - 重命名操作
; ---------------------------------------
$^r::
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
        send ^r
        ;提示热键无操作()
    }
return

$^#r::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, 按ctrl+r,
        ; 结果: 剪贴板 + 扩展名;
        f2自动重命名("regExp", [{"match": "i).*?([a-zA-Z]{3,5})00(\d{3,5})jp-(\d+)"
                                    , "replace": "$1-$2_$3"}
                                , {"match": "i).*?([a-zA-Z]{3,5})00(\d{3,5})pl"
                                    , "replace": "$1-$2"}])
    }
    else{
        send ^r
        ;提示热键无操作()
    }
return

$^!r::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, 按ctrl+alt+r
        ; 结果: 剪贴板内容 + 扩展名
        f2自动重命名("regExp", "^.+$", "{clipboard}")
    }
    else if(inWinList(["#32770"], "class")){
        ; 另存为窗口, 按ctrl+alt+r
        ; 结果: 剪贴板内容 + 扩展名"
        自动重命名("regExp", "^.+$", "{clipboard}")
    }
    else{
        send ^!r
        ;提示热键无操作()
    }
return

$^+r::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口, ctrl + shift + r
        ; undo撤销操作;
        f2自动重命名("undo")
    }
    else{
        send ^+r
        ;提示热键无操作()
    }
return

; 自定义重命名操作
$!f2::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口,
        ; 结果: 剪贴板 + 扩展名;
        f2自动重命名("av")
    }
    else{
        send !{f2}
    }
return

; undo撤销操作
$+f2::
    if(inWinList(Config.get("资源管理器"))){
        ; 资源管理器窗口,
        ; undo撤销操作
        f2自动重命名("undo")
    }
    else{
        send +{f2}
    }
return
; ----------------------------------------------------------
; [窗口控制操作]针对四键鼠标的设置
; ----------------------------------------------------------
^#MButton::
    添加窗口到白名单()
    return

+#MButton::
    从白名单删除窗口()
    return

; 鼠标快速向左调整窗口()
$Wheelleft::
    if(inWinList(允许调整窗口白名单())){
        鼠标快速向左调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; 鼠标快速向右调整窗口()
$Wheelright::
    if(inWinList(允许调整窗口白名单())){
        鼠标快速向右调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; 鼠标快速向左调整窗口()
$XButton1::
    if(inWinList(允许调整窗口白名单())){
        鼠标快速向左调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

;鼠标快速向右调整窗口()
$XButton2::
    if(inWinList(允许调整窗口白名单())){
        鼠标快速向右调整窗口()                                ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; 按ctrl+鼠标中键, 窗口纵向最大化
$MButton::
    if(inWinList(Config.get("视频播放器"))){                 ;视频播放器自动居中1440*720
        快捷操作_移动当前窗口(5, {"w":1440, "h":797})
    }
    else if(inWinList(允许调整窗口白名单())){
        鼠标单键切换窗口y轴大小()                             ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; 按shift+鼠标中键, 窗口横向向最大化
$+MButton::
    if(inWinList(允许调整窗口白名单())){
        鼠标单键切换窗口x轴大小()                             ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; 按ctrl+鼠标中键, 窗口屏幕居中, 1440*720
$^!MButton::
    if(inWinList(允许调整窗口白名单())){
        快捷操作_移动当前窗口(5)                             ; 资源管理器窗口
    }
    else{
        添加窗口到白名单()
    }
return

; ----------------------------------------------------------
; 窗口置顶,按Ctrl+win+t将窗口置顶，再按一次恢复正常
; ----------------------------------------------------------
~^#t::窗口置顶()
; ----------------------------------------------------------
; 快捷操作 - 调整当前窗口大小
; ----------------------------------------------------------
#^up::快捷操作_调整当前窗口大小("up")                         ; 快速纵向最大化
#^down::快捷操作_调整当前窗口大小("down")                     ; 快速纵向缩小
#^Numpad8::快捷操作_调整当前窗口大小(8)                       ; 纵向向上伸缩
#^Numpad2::快捷操作_调整当前窗口大小(2)                       ; 纵向向下伸缩
#^Numpad4::快捷操作_调整当前窗口大小(4)                       ; 横向缩小(向左)
#^Numpad6::快捷操作_调整当前窗口大小(6)                       ; 横向扩大(向右)
; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口
; ----------------------------------------------------------
#NumpadDot::快捷操作_移动当前窗口(".")                        ; 移动窗口到右下角最小化
#Numpad8::快捷操作_移动当前窗口(8)                            ; 上移
#Numpad2::快捷操作_移动当前窗口(2)                            ; 下移
#Numpad4::快捷操作_移动当前窗口(4)                            ; 左移
#Numpad6::快捷操作_移动当前窗口(6)                            ; 右移
#Numpad5::快捷操作_移动当前窗口(5)                            ; 自动移到屏幕正中
; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口(并自动调整窗口大小)
; ----------------------------------------------------------
#Numpad7::快捷操作_移动当前窗口_并调整大小(1)                  ; 移到左上方
#Numpad1::快捷操作_移动当前窗口_并调整大小(3)                  ; 移到左下方
#Numpad9::快捷操作_移动当前窗口_并调整大小(2)                  ; 移到右上方
#Numpad3::快捷操作_移动当前窗口_并调整大小(4)                  ; 移到右下方
; ----------------------------------------------------------
; 多窗口管理
; ----------------------------------------------------------
#NumpadMult::多窗口管理("平铺",1)                            ; 全部窗口平铺
^#NumpadMult::多窗口管理("平铺",-0.49)
!#NumpadMult::多窗口管理("平铺",0.49)
#IfWinActive ahk_class Progman
    ~left & NumpadMult::多窗口管理("平铺",-0.49)
    ~right & NumpadMult::多窗口管理("平铺",0.49)
    ~down & NumpadMult::多窗口管理("平铺",1)
#IfWinActive
; ----------------------------------------------------------
; [功能实现部分] 编程快捷操作类
; ----------------------------------------------------------
#=::代码段边界线(2)                                          ; 代码段行间隔加粗
#-::代码段边界线(1)                                          ; 代码段行间隔
#+-::设置代码段落标题()                                      ; 设置代码段落标题(将当前行全部内容设置为标题)
; ----------------------------------------------------------
; [代码块注释]
; ----------------------------------------------------------
#/::注释代码块(1,1,1)                                        ; 注释选定行并添加上下边界线 (清理连续空行)
#!/::注释代码块(1,1,0)                                       ; 注释选定行并添加上下边界线
#+/::取消注释代码块()                                        ; 取消注释代码块, 可以识别当前行是否被注释
; ----------------------------------------------------------
#,::xml包裹选定文本()                                        ; xml包裹选定文本, 如<td>...</td>, 使用# C可以直接复制设置标签名
; ----------------------------------------------------------
#'::Clipboarder.wrap("""", """")                            ; 双引号包裹
#+9::Clipboarder.wrap("(", ")")                             ; 小括号包裹
#[::Clipboarder.wrap("[", "]")                              ; 中括号包裹
#+[::Clipboarder.wrap("{", "}")                             ; 大括号包裹
#+,::Clipboarder.wrap("<", ">")                             ; <>包裹
#+3::Clipboarder.wrap("#", "#")                             ; #...#包裹
#+5::Clipboarder.wrap("%", "%")                             ; %...%包裹

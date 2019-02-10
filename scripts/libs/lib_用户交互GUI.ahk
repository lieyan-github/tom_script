; ==========================================================
;
; 用户界面类, 控制消息和界面GUI
;
; 文档作者: 烈焰
;
; 修改时间: 2019-01-21 01:12:57
;
; ==========================================================

; ListVars调试界面显示
show_debug(_text, _w:=800, _h:=600){
    ; 控制台显示
    _text_out := StrReplace(_text, "`n", "`r`n") ; for display purposes only
    ListVars
    WinWaitActive ahk_class AutoHotkey
    WinMove, ahk_class AutoHotkey, , , , %_w%, %_h%
    ControlSetText Edit1, %_text_out%`r`n
    WinWaitClose
}

; [GUI]show_text(_text)
show_text(_text, _title:="显示文本", _w:=800, _h:=600){
    global MyEdit
    ; gui
    Gui, New, hwndMyhwnd AlwaysOnTop Resize
    Gui, Margin, 0, 0
    gui, font, s12, Consolas
    Gui, Add, Edit, vMyEdit W%_w% H%_h% ReadOnly +HScroll -Wrap, % _text
    Gui, Show, AutoSize Center, % _title
    return Myhwnd

    GuiSize:
        if ErrorLevel = 1  ; 窗口被最小化了.  无需进行操作.
            return
        ; 否则, 窗口的大小被调整过或被最大化了. 调整编辑控件的大小以匹配窗口.
        NewWidth := A_GuiWidth
        NewHeight := A_GuiHeight
        GuiControl, Move, MyEdit, W%NewWidth% H%NewHeight%
    return
}

; [GUI]show_text(_text)
show_textToRightDown(_text, _title:="显示文本在右下角", _w:=330, _h:=220){
    Myhwnd := show_text(_text, _title, _w, _h)
    WinGetPos, , , _Width, _Height, ahk_id %Myhwnd%
    _x := Sys.monitor.w - _Width
    _y := Sys.monitor.h - _Height
    winmove, ahk_id %Myhwnd%, , % _x, % _y
}

提示热键无操作(){
    ; 未定义的窗体, 提示该窗体未定义ctrl+shift+r操作内容
    WinGetClass, _winclass, A
    WinGetTitle, _winTitle, A
    MouseGetPos, , , _WhichWindow, _WhichControl
    ControlGetText, _control_text, %_WhichControl%, ahk_id %_WhichWindow%
    show_debug(format("`n快捷键[ {1} ]在当前窗口无操作; `n`n"
                    . "a. 添加 ctrl + win + 中键. `n"
                    . "b. 删除 shift+ win + 中键.`n`n"
                    . "-----------------------------------------`n"
                    . "WinInfo`n"
                    . "-----------------------------------------`n"
                    . "{3}`n"
                        , A_ThisHotkey
                        , "a. 添加到白名单 ctrl+win+中键 `nb. 删除从白名单 shift+win+中键"
                        , arrayToStr(获取窗口信息())))
}

; ----------------------------------------------------------
; [客户界面常用功能] 操作确认
; 让使用者确认是否进行操作
; ----------------------------------------------------------
操作确认(_title, _text)
{
    _confirm:= true
    ;让使用者确认是否进行操作
    msgbox, 1, % _title, % _text
    IfMsgBox, Cancel
    {
        show_msg("[操作结束]`n用户取消了当前操作!")
        _confirm:= false
    }
    return _confirm
}

; ----------------------------------------------------------
; [客户界面常用功能]  用户修改变量
; _RegExReplace: 对输入的内容进行格式化处理,以便使用
; ----------------------------------------------------------
用户修改对象变量(ByRef _userVar, _userVarTitle, _default:="", _hide:="")
{
    ; 从输入框获取修改后的新变量值, 用户输入为空则退出
    if(获取用户输入(_OutputVar
        , "编辑[" . _userVarTitle . "]"
        , "当前[" . _userVarTitle . "]为对象"
        , _default
        , _hide)
        = false)
        return false
    _userVar := _OutputVar
    show_msg("当前[" . _userVarTitle . "]已修改为: " . _userVar)
    return true
}

; ----------------------------------------------------------
; [客户界面常用功能]  用户修改变量
; _RegExReplace: 对输入的内容进行格式化处理,以便使用
; ----------------------------------------------------------
用户修改变量(ByRef _userVar, _userVarTitle, _default:="", _hide:="")
{
    ; 从输入框获取修改后的新变量值, 用户输入为空则退出
    if(获取用户输入(_OutputVar
        , "编辑[" . _userVarTitle . "]"
        , "当前[" . _userVarTitle . "]= " . _userVar
        , _default
        , _hide)
        = false)
        return false
    _userVar := _OutputVar
    show_msg("当前[" . _userVarTitle . "]已修改为: " . _userVar)
    return true
}

; ----------------------------------------------------------
; [客户界面常用功能]  获取用户输入
; _RegExReplace: 对输入的内容进行格式化处理,以便使用
; ----------------------------------------------------------
获取用户输入(ByRef _userinput, _title, _text, _default:="", _hide:="", _RegExReplaces*)
{
    _confirm:= true
    重新等待用户输入:
    InputBox, _userinput, % _title, % _text, % _hide, , , , , , , % _default
    if ErrorLevel
    {
        show_msg("[操作结束]`n用户取消了当前操作!")
        _confirm:= false
        return _confirm
    }
    if _userinput =
    {
        show_msg("[输入错误]`n用户输入内容空白, 请重新输入.")
        goto 重新等待用户输入
    }

    ;对输入的内容进行格式化处理,以便使用
    for index, _RegExReplace in _RegExReplaces
        _userinput := RegExReplace(_userinput, _RegExReplace)

    return _confirm
}

; 扩展功能: 修改ini配置变量, 并在修改完成后, 重新加载变量;
用户修改ini变量(ByRef _userVar, _userVarTitle, _file, _Section, _Key){
    ; 从输入框获取修改后的新变量值, 用户输入为空则退出
    if(获取用户输入(_OutputVar
        , "编辑[" . _userVarTitle . "]"
        , "当前[" . _userVarTitle . "]= " . _userVar
        , _userVar)
        = false)
        return false
    ; 将修改后的新值写入ini文件
    IniFile.update(_OutputVar
            , _file
            , _Section
            , _Key)
    ; 重新读取Ini中的变量到全局变量
    _userVar := _OutputVar
    show_msg("[文件]" . _file . "`n[项目]" . _Section . " | " . _Key . "  : " . _userVarTitle . "`n已修改为: " . _userVar)
    return true
}

; ----------------------------------------------------------
; [客户界面常用功能]  获取用户密码输入
; _RegExReplace: 对输入的内容进行格式化处理,以便使用
; ----------------------------------------------------------
获取用户密码输入(ByRef _userinput, _title, _text, _RegExReplaces*)
{
    _confirm:= true
    _userinput := ""
    _userinput_confirm := ""

    重新等待用户输入密码:
    ;开始进行输入操作
    if(获取用户输入(_userinput
        , _title
        , _text
        , ""
        , "hide"
        , _RegExReplaces)=false)
    {
        _confirm:= false
        return _confirm
    }
    ;再次输入,进行确认操作
    if(获取用户输入(_userinput_confirm
        , "[确认输入]--" . _title
        , "[确认输入]--" . _text
        , ""
        , "hide"
        , _RegExReplaces)=false)
    {
        _confirm:= false
        return _confirm
    }
    if(_userinput != _userinput_confirm)
    {
        msgbox, 两次输入内容不同, 需重新输入!
        goto 重新等待用户输入密码
    }

    ;对输入的内容进行格式化处理,以便使用
    for index, _RegExReplace in _RegExReplaces
        _userinput := RegExReplace(_userinput, _RegExReplace)

    return _confirm
}

; ----------------------------------------------------------
; 显示: 显示Splash图片窗口
; ----------------------------------------------------------
show_splashImage(_ImageFile, _seconds=5000, _title="消息", _Options="", _subText="", _mainText="", _fontName="")
{
    SplashImage, %_ImageFile%, %_Options%, %_subText%, %_mainText%, %_title%, %_fontName%
    Sleep, %_seconds%
    SplashImage, Off
}

; ----------------------------------------------------------
; 显示: 显示Splash消息窗口
; ----------------------------------------------------------
show_splash(_text, _title="消息", _seconds=2000, _w="", _h="")
{
    SplashTextOn, %_w%, %_h%, %_title%, %_text%
    Sleep, %_seconds%
    SplashTextOff
}

; ----------------------------------------------------------
; 显示: 显示消息窗口
; ----------------------------------------------------------
show_msg(_text, _title="消息", _seconds=3000){
    show_tooltip(format("{1:4}`n--------------------------------------------------`n{2}`n`n`n`n`n`n--------------------------------------------------"
                        , _title, _text)
                    , _seconds)
}

; 任务托盘提示方式
; ----------------------------------------------------------
show_traytip(_text, _title="消息", _seconds=3000, _options=1){
    #SingleInstance off
    TrayTip, %_title%, %_text%, 30, %_options%
    SetTimer, _RemoveTrayTip, %_seconds%
    return

    _RemoveTrayTip:
        SetTimer, _RemoveTrayTip, Off
        TrayTip
    return
}


;; 任务托盘提示方式(修改前备份)
;; ----------------------------------------------------------
;show_traytip(_text, _title="消息", _seconds=5000, _options=1){
;    #SingleInstance off
;    TrayTip, %_title%, %_text%, 30, %_options%
;    SetTimer, _RemoveTrayTip, %_seconds%
;    return
;
;    _RemoveTrayTip:
;        SetTimer, _RemoveTrayTip, Off
;        TrayTip
;    return
;}

; tooltip提示方式(定时器对象 新版bug, sleep期间不能进行操作)
; ----------------------------------------------------------
show_tooltip(_msg, _time:=3000){
    _obj := new Timer_showmsg(_msg, _time)
    _obj.start()
    _obj := ""
}

; tooltip提示方式(旧版备份)
; ----------------------------------------------------------
;show_tooltip(_msg, _time=3000, params*){
;    ToolTip, % _msg
;    SetTimer, RemoveToolTip, %_time%
;    return
;
;    RemoveToolTip:
;    SetTimer, RemoveToolTip, Off
;    ToolTip
;    return
;}

; ----------------------------------------------------------
; 输出: 以粘贴的方式输出字符串
; ----------------------------------------------------------
write(_out){
    Clipboarder.write(_out)
}




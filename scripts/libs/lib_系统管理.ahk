; ==========================================================
;
; lib_系统控制类
;
; 作者: 烈焰
;
; 修改时间: 2018-02-19 17:23:05
;
; ==========================================================

class Sys{
    static monitor := {x:0, y:0, w:0, h:0}
    static mouse := {x:0, y:0
                    , x_screen:0, y_screen:0
                    , color:0}

    ; static method
    init(){
        Sys.monitor_init()
        Sys.mouse_init()
    }
    ; static method
    monitor_init(){
        SysGet, monitor, MonitorWorkArea
        Sys.monitor.w := monitorRight
        Sys.monitor.h := monitorBottom
    }
    ; static method
    mouse_init(){
        ;--- 鼠标信息(默认相对于当前窗体)
        CoordMode, Mouse, Screen
        MouseGetPos, mouseX_screen, mouseY_screen
        CoordMode, Mouse, Window
        MouseGetPos, mouseX, mouseY, mouseUnderwinId, mouseUnderControlClass
        PixelGetColor, pixColor, mouseX, mouseY, RGB
        Sys.mouse.x := mouseX
        Sys.mouse.y := mouseY
        Sys.mouse.x_screen := mouseX_screen
        Sys.mouse.y_screen := mouseY_screen
        Sys.mouse.color := pixColor
    }
    ; static method 获取"日期时间字符串"
    now(){
        return strTime("yyyy-MM-dd HH:mm:ss")
    }
    ; static method 获取"日期字符串"
    date(){
        return strTime("yyyy-MM-dd")
    }
    ; static method 获取"时间字符串"
    time(){
        return strTime("HH:mm:ss")
    }

    ; static method 获取"星期字符串" 修正系统的星期天数, 周一_周日从1-7
    week(){
        FormatTime, _result,, WDay
        if(_result == 1)
            _result := 7
        else
            _result -= 1
        return _result
    }
}

; ----------------------------------------------------------
; [系统控制类]tom手动批量启动常用工具()
; ----------------------------------------------------------
tom手动批量启动常用工具()
{
    ;--- 先启动音速启动, 以便使用程序菜单
    _自动启动列表:= JsonFile.read(Config.upath("批量启动程序"))
    批量启动程序(_自动启动列表, true)
    sleep 10000
}

; ----------------------------------------------------------
; debug有待继续调试, 只能执行一次, 不能重复???, 定时重复执行程序(_timer, byref _func(_params*)) 函数作为参数时可以直接带参数
; ----------------------------------------------------------
定时重复执行程序(_timer, ByRef _func)
{
    #Persistent
    #SingleInstance off
    SetTimer, _定时重复执行程序, % _timer
    return
    _定时重复执行程序:
        _func.()
    return
}


; ----------------------------------------------------------
; 批量启动程序
; 参数:
; _启动程序列表, 格式[[程序名1, 程序路径1, 启动过参数1, [[options1],[options2],启动后的后续调整操作比如最小化]], ...]
; ----------------------------------------------------------
批量启动程序(byRef _启动程序列表, _is写入日志:=false, _is显示信息:=true)
{
    ;--- 程序启动通知信息
    show_msg("开始批量启动程序......" . "`n" . Sys.now())
    ;--- 自动启动文件列表和日志
;    _自动启动列表:= [["音速启动", "d:\home\lieyan\d - softwares\green_software\音速启动(VStart)V5\VStart.exe"]
;                    , ["F.lux", "C:\Users\tom\AppData\Local\FluxSoftware\Flux\flux.exe", "/noshow"]
;                    , ["360安全卫士", "C:\Program Files (x86)\360\360Safe\360Safe.exe"]]
    _处理日志:= []
    _程序启动间隔时间:= 3000
    ; ----------------------------
    启动项          := []
    程序名          := ""
    程序路径        := ""
    程序参数        := ""
    ; ----------------------------
    options        := []
    启动后的状态调整 := ""
    窗口标题        := ""
    附加条件参数    := ""
    ; ----------------------------
    提示信息        := ""
    ; ----------------------------
    ; 自动启动处理过程
    Loop % _启动程序列表.MaxIndex()
    {
        ; ----------------------------
        启动项          := _启动程序列表[A_Index]
        程序名          := 启动项[1]
        程序路径        := 启动项[2]
        程序参数        := ""
        提示信息        := ""
        if(启动项.MaxIndex()>2)
            程序参数 := 启动项[3]
        ; ----------------------------
        options         := []
        if(启动项.MaxIndex()>3)
            options := 启动项[4]
        ; ----------------------------
        进程名:= get_fileName(程序路径)
        ; ----------------------------
        Process, wait, %进程名%, 3
        NewPID = %ErrorLevel%  ; 由于 ErrorLevel 会经常发生改变, 所以要立即保存这个值.
        if NewPID = 0
        {
            ;不存在指定进程, 则准备启动进程
            ;检查指定文件是否存在
            if FileExist(程序路径)
            {
                run, %程序路径% %程序参数%
                sleep 100
                提示信息 .= 程序名 . " | 启动ok"
                ; options调整打开后的窗口状态, 比如最小化, 关闭多余进程
                ; ----------------------------
                Loop % options.MaxIndex()
                {
                    ; ----------------------------
                    启动后的状态调整:= ""
                    窗口标题        := ""
                    附加条件参数    := ""
                    if(options[A_Index].MaxIndex()>0)
                    {
                        启动后的状态调整 := options[A_Index][1]
                        if(options[A_Index].MaxIndex()>1)
                            窗口标题 := options[A_Index][2]
                        if(options[A_Index].MaxIndex()>2)
                            附加条件参数 := options[A_Index][3]
                    }
                    ; ----------------------------
                    if(启动后的状态调整 != "")
                    {
                        if(启动后的状态调整 == "min")   ; 窗口最小化
                        {
                            sleep 3000
                            WinWait, %窗口标题%, , 60
                            if ErrorLevel
                            {
                                提示信息 .= " | 等待" . 程序名 . "打开, 超时"
                            }
                            else
                            {
                                WinMinimize, %窗口标题%
                                提示信息 .= " | 最小化"
                            }
                        }
                        else if(启动后的状态调整 == "kill")   ; 关闭多余的窗口, 如果提前存在, 则不进行关闭
                        {
                            ;--- 如果没有打开app, 则将程序打开的额外app关闭, 比如蓝灯打开时会打开一个浏览器i
                            IfWinNotExist, %窗口标题%
                            {
                                WinWait, %附加条件参数%, , 60
                                if ErrorLevel
                                {
                                    提示信息 .= " | 等待" . 程序名 . "打开, 超时"
                                }
                                else
                                {
                                    WinKill %附加条件参数%
                                    提示信息 .= " | 多余的程序[" 附加条件参数 "]已经关闭"
                                }
                            }
                            else
                            {
                                提示信息 .= " | 用户提前打开的[" 附加条件参数 "]不需要关闭"
                            }
                        }
                    }
                }
            }
            else
            {
                提示信息 .= "**路径错误  (" . 程序名 . ": " . 进程名 . ") ."
            }
            arrayAppend(_处理日志, 提示信息)
            ; 操作处理结果提示信息
            ; show_msg(提示信息)
            sleep %_程序启动间隔时间%
        }
        else
        {
            arrayAppend(_处理日志, 程序名 . " | 进程ok")
            ;存在指定进程, 则直接下一个
            sleep %_程序启动间隔时间%
            continue
        }
    }
    sleep 500
    _showMsg:= arrayToStr(_处理日志)
    ; 写入剪贴板 debug专用
    ; ----------------------
    ;clipboard:= _showMsg
    ;Clipboarder.push(_showMsg)
    ; ----------------------
    ;---- 写入日志
    if(_is写入日志)
    {
        修改日志(_showMsg, "批量启动程序日志")
        _showMsg .= "`n*信息已写入日志*"
    }
    else
    {
        _showMsg .= "`n*仅提示信息*"
    }
    if(_is显示信息)
        show_msg(_showMsg . "`n" . Sys.now())
    _showMsg=
    _处理日志:=
}

; ----------------------------------------------------------
; 批量关闭进程
; 参数:
; _关闭进程列表, 格式数组[程序文件名, ...]
; ----------------------------------------------------------
批量关闭进程(byRef _关闭进程列表, _is显示信息:=true)
{
    ;--- 程序启动通知信息
    show_msg("开始批量关闭进程......`n" . Sys.now())
;    _关闭进程列表:= ["Thunder.exe"
;        , "ThunderPlatform.exe"
;        , "QQPYCloud.exe"
;        , "QQProtect.exe"]
    _处理日志:= []
    Loop % _关闭进程列表.MaxIndex()
    {
        进程名:= _关闭进程列表[A_Index]
        Process, wait, %进程名%, 3
        NewPID = %ErrorLevel%  ; 由于 ErrorLevel 会经常发生改变, 所以要立即保存这个值.
        if NewPID = 0
        {
            arrayAppend(_处理日志, "不存在ok (" . SubStr(进程名, 1, 5) . "..) .")
            continue
        }
        else
        {
            runwait TASKKILL /F /IM %进程名% /T, , Hide
            sleep 100
            arrayAppend(_处理日志, "关闭ok (" . SubStr(进程名, 1, 5) . "..) .")
        }
    }
    sleep 500
    _showMsg:= arrayToStr(_处理日志)
    ; 写入剪贴板 debug专用
    ; ----------------------
    ;clipboard:= _showMsg
    ;Clipboarder.push(_showMsg)
    ; ----------------------
    if(_is显示信息)
    {
        show_msg(_showMsg . "`n*信息已存入剪贴板*" . "`n" . Sys.now())
    }
    _showMsg=
    _处理日志:=
}

; ----------------------------------------------------------
; script_reload() 脚本刷新
; ----------------------------------------------------------
script_reload()
{
    Reload
    Sleep 1000 ; 如果成功, 则 reload 会在 Sleep 期间关闭这个实例, 所以下面这行语句永远不会执行.
    MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
    IfMsgBox, Yes, Edit
}



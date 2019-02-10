; ----------------------------------------------------------
; mt4 常用快捷键
; ----------------------------------------------------------
#IfWinActive ahk_class MetaQuotes::MetaTrader::4.00

    ;按平时股票设置放大缩小键为上下键
    Up::NumpadAdd
    Down::NumpadSub
        
    ; 按insert, delete上下翻市场
    ; ----------------------------------------------------------
    ^PgUp::
        Send {Ctrl down}{Shift Down}{F6}    ; 按下向上键.
        Sleep 200                           ; 按住 0.2 秒.
        Send {Ctrl up}{Shift up}            ; 释放向上键.   
    return

    ^PgDn::
        Send {Ctrl down}{F6}                ; 按下向上键.
        Sleep 200                           ; 按住 0.2 秒.
        Send {Ctrl up}                      ; 释放向上键.   
    return

    ;按放大,同时将页面移到末尾  
    ;NumpadAdd::
    ;   send {NumpadAdd}{End}
    ;return

    ;按缩小,同时将页面移到末尾  
    ;NumpadSub::
    ;   send {NumpadSub}{End}
    ;return

    ;中键显示十字光标
    MButton::mt4十字光标开关切换()

    ;按左键同时清空十字光标切换标志
    ~LButton::mt4十字光标开关切换(1)

    ;按ctrl+左键显示十字光标        
    #LButton::mt4十字光标开关切换()

    ;菜单键代替右键
    ;AppsKey::RButton

    mt4十字光标开关切换(_init=0)
    {
        ;init=1时, 只做清空开关状态的动作
        if(_init=1) 
        {
            Config.mt4_ctrl_f_switch:=0
            return
        }   
        
        ;十字光标开关切换   
        if(Mod(Config.mt4_ctrl_f_switch, 2)=0)
                send {ctrl down}{f}{ctrl up}
            else
                send {LButton}
        Config.mt4_ctrl_f_switch++
    }

#IfWinActive



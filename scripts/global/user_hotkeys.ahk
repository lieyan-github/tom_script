﻿; ==========================================================
; ----------------------------------------------------------
; user_hotkeys.ahk  用户热键管理
;
; 作者: 烈焰
;
; 2019-02-07 00:44:35
; ----------------------------------------------------------
; ==========================================================


; ----------------------------------------------------------
; [针对av管理]360浏览器自定义修改av收藏
; ----------------------------------------------------------
^#a::
:*:;avny::
    write("#av女优# ★★★ ")               ; 输出"#av女优# ★★★ "
    return

^#z::
:*:;avzp::
    write("#av作品# ★★★ ")               ; 输出"#av作品# ★★★ "
    return
; ----------------------------------------------------------
; 常用快捷键
; ----------------------------------------------------------
:*:@@@::
    write("lie_yan@126.com")             ; 输出邮箱
    return

; 输出"评级星星"
:*:;xxxxx::★★★★★
:*:;5x::★★★★★
:*:;4x::★★★★☆
:*:;3x::★★★☆☆
:*:;2x::★★☆☆☆
:*:;1x::★☆☆☆☆
:*:;0x::☆☆☆☆☆
; ----------------------------------------------------------
:*:;id::                                ; 输出17位短id -- "14位时间+3位随机数" 下划线间隔
>!'::
    write(strId())
    return

:*:;now::                               ; 输出"日期时间字符串"
:*:;nnn::
>!`;::
    write(Sys.now())
    return
; ----------------------------------------------------------
:*:;date::                              ; 输出"日期字符串"
>!.::
    write(Sys.date())
    return
; ----------------------------------------------------------
:*:;time::                              ; 输出"时间字符串"
>!/::
    write(Sys.time())
    return
; ----------------------------------------------------------

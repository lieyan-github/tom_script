﻿; ==========================================================
; ----------------------------------------------------------
; 日志管理
;
; 作者: 烈焰
;
; 2016年01月30日 16:42:59
; ----------------------------------------------------------
; ==========================================================

; ----------------------------------------------------------
; 记录并循环备份日志(_区域名, _项目名, _in备份次数:=3)
; ----------------------------------------------------------
记录并循环备份日志(_区域名, _项目名, _in备份次数:=3, _isShowMsg:=true)
{
    _备份次数:= _in备份次数
    _日志列表:= []
    ;---- 记录开机时间
    while(_备份次数>0)
    {
        if(_备份次数-1 > 0)
        {
            arrayPushFirst(_日志列表
                , 写日志(读日志(_区域名, _项目名 . (_备份次数-1))
                    , _区域名
                    , _项目名 . _备份次数
                    , false))
            _备份次数--
        }
        else
        {
            arrayPushFirst(_日志列表
                , 写日志(读日志(_区域名, _项目名)
                    , _区域名
                    , _项目名 . _备份次数
                    , false))
            _备份次数--
        }
    }
    arrayPushFirst(_日志列表
        , 写日志(Sys.now()
            , _区域名
            , _项目名
            , false))
    _msg:= arrayToStr(_日志列表)
    if(_isShowMsg)
        show_msg(_msg . " `n--写入完成", "写入日志")
    return _msg
}

; ----------------------------------------------------------
; 写日志文件
; ----------------------------------------------------------
写日志(_Value, _Section, _Key:="", _showMsg:=true)
{
    IniFile.write(_Value, Config.upath("logFile"), _Section, _Key)
    _msg:= "[" . _Section . "]" . _Key . "=" . _Value
    if(_showMsg)
        show_msg(_msg . " `n--写入完成", "写入日志")
    return _msg
}

; ----------------------------------------------------------
; 读日志文件
; ----------------------------------------------------------
读日志(_Section, _Key:="", _Default:="null", _showMsg:=false)
{
    OutputVar := IniFile.read(Config.upath("logFile"), _Section, _Key, _Default)
    if(_showMsg)
        show_msg("[" . _Section . "]" . _Key . "=" . OutputVar . " `n--读取完成", "读取日志")
    return %OutputVar%
}

; ----------------------------------------------------------
; 删日志文件内容
; ----------------------------------------------------------
删日志(_Section, _Key:="", _showMsg:=true)
{
    IniFile.delete(Config.upath("logFile"), _Section, _Key)
    _msg:= "[" . _Section . "]" . _Key
    if(_showMsg)
        show_msg(_msg . "    --删除完成.", "删除日志")
    return _msg
}

; ----------------------------------------------------------
; 修改日志文件
; ----------------------------------------------------------
修改日志(_Value, _Section, _Key:="", _showMsg:=true)
{
    IniFile.update(_Value, Config.upath("logFile"), _Section, _Key)
    _msg:= "[" . _Section . "]" . _Key
    if(_showMsg)
        show_msg(_msg . "    --修改完成.", "修改日志")
    return _msg
}


; ==========================================================
; ==========================================================






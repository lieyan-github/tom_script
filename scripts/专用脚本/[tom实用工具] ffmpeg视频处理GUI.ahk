; ----------------------------------------------------------
; ffmpeg视频处理GUI.ahk
;
; tom
;
; 2020-11-26 05:32:17
; ----------------------------------------------------------
;主要功能
;1. 主程序ffmpeg视频处理gui()
;2. 功能, 按时间段剪切, 修改视频分辨率

#include scripts\libs\Array.ahk
#include scripts\packages\Json.class.ahk

; ----------------------------------------------------------
; class JsonFile extends File
; ----------------------------------------------------------
class JsonFile {

    ; static 读文件
    ; 返回json对象
    read(_jsonPath){
        if(! FileExist(_jsonPath))
            return {}
        _fileIn:= FileOpen(_jsonPath, "r", "utf-8")
        _json_str:= _fileIn.read()
        fileIn.close()
        return JSON.Load(_json_str)
    }

    ; static 写文件
    write(_jsonObj, _jsonPath){
        _json_str := JSON.Dump(_jsonObj,, 3)
        _json_str := StrReplace(_json_str, "`n", "`r`n") ; for display purposes only

        ; 输出结果到文件
        _dump_file:= FileOpen(_jsonPath, "w", "utf-8")
        _dump_file.write(_json_str)
        _dump_file.close()
    }
}


ffmpeg视频处理gui()

/*
    ffmpeg视频处理gui()
*/
ffmpeg视频处理gui(){

    ; ----------------------------------------------------------
    ; gui控件变量初始化
    ; ----------------------------------------------------------
    static 源文件路径, 剪切时间列表str, 输出文件名, 输出目录, 剪辑后缀

    _剪切任务_文件名前缀 := "剪切任务"
    _剪切任务_文件扩展名 := "json"
    _剪切任务_文件路径   := ""
    _设置json          := {}
    
    ; 获取视频文件路径, 通过复制获得
    send ^c
    sleep 200
    
    if FileExist(Clipboard){

        源文件路径     := Clipboard
        _源文件obj    := 分析文件路径(源文件路径)
        _源文件名     := _源文件obj.文件名
        _扩展名       := _源文件obj.扩展名
        _当前目录名    := _源文件obj.当前目录名
        _当前目录路径  := _源文件obj.目录路径
        输出目录      := A_Desktop

        if(_扩展名 = "json"){
            ; 选中配置文件的操作, 恢复配置, 并打开视频源文件目录
            ; 如果是json文件, 则当成配置文件处理
            _设置json := JsonFile.read(源文件路径)

            ; 检测配置文件中的源文件地址是否存在, 不存在则中止操作
            if(! FileExist(_设置json["源文件路径"])){
                
                ; 如果视频源文件路径, 不存在
                ; 则检查json当前目录是否存在指定视频文件
                _当前目录下视频文件路径 := format("{1}\{2}.{3}"
                                            , _当前目录路径
                                            , _设置json["源文件名"]
                                            , _设置json["输出扩展名"])

                if(FileExist(_当前目录下视频文件路径)){
                    ; 如果json当前目录, 包含源文件, 则将源文件路径修改;
                    ; 输出目录保持不变;
                    msgbox, % format("配置文件中`n源文件路径不存在, 更新为当前目录下的视频文件`n`n无效路径: {1}`n`n新路径: {2}"
                                    , _设置json["源文件路径"]
                                    , _当前目录下视频文件路径)
                    _设置json["源文件路径"] := _当前目录下视频文件路径
                }
                else{
                    msgbox, % "配置文件中的源文件路径不存在, 操作终止!`n`n" . _设置json["源文件路径"]
                    return
                }
            }
            else{
                ; 如果存在源文件路径
                ; 则打开源文件的目录
                Run, % (分析文件路径(_设置json["源文件路径"])).目录路径
            }

            

            ; 恢复设置
            剪切时间列表str  := 时间列表转字符串(_设置json.剪切时间列表)
            输出文件名      := _设置json.输出文件名
            输出目录        := _设置json.输出目录 != "" ? _设置json.输出目录 : A_Desktop
            源文件路径      := _设置json["源文件路径"]

        }
        else{
            ; 选中视频文件的操作, 输出目录没有相关配置文件, 则空白, 否则恢复配置

            ; 如果文件名不含"#av", 则取目录名中的含 #av 的已格式化名字
            if(InStr(_当前目录名, "#av") == 1 and not(InStr(_源文件名, "#av"))){
                输出文件名   := _当前目录名
                输出文件名   := StrReplace(输出文件名, "#av作品#", "#av剪辑#")
            }
            else
                输出文件名   := _源文件名

            ; 查看是否存在对应的配置文件
            ; 存在对应配置文件, 则恢复设置
            _剪切任务_文件路径 := 创建日志文件路径(输出目录
                                            , _源文件名
                                            , _剪切任务_文件扩展名
                                            , _剪切任务_文件名前缀)
            if FileExist(_剪切任务_文件路径){
                _设置json := JsonFile.read(_剪切任务_文件路径)

                ; 恢复设置
                剪切时间列表str  := 时间列表转字符串(_设置json.剪切时间列表)
                输出文件名      := _设置json.输出文件名
                输出目录        := _设置json.输出目录 != "" ? _设置json.输出目录 : A_Desktop
            }

        }



        

    }

    ; ----------------------------------------------------------
    ; 显示gui窗体部分
    ; ----------------------------------------------------------
    Gui Add, Button, x11 y350 w80 h23, &Exit
    Gui Add, Button, x111 y350 w80 h23, 保存设置
    Gui Add, Button, x409 y350 w80 h23, 剪切
    Gui Add, Button, x309 y350 w80 h23 Disabled, 修改分辨率

    ;Gui Add, Text, x150 y240 w220 h20 +0x200, 注意: 需提前在path设置ffmpeg路径
    Gui Add, Tab3, x12 y12 w477 h320, Main|Options
    ; Tab Main
    Gui Tab, 1
        gui, font, s10, Consolas
        Gui Add, GroupBox, x19 y41 w461 h85, Files
        Gui Add, Text, x30 y65 w80 h23 +0x200, 源文件路径
        Gui Add, Edit, x121 y66 w350 h19 v源文件路径, %源文件路径%
        Gui Add, Text, x30 y93 w80 h23 +0x200, 时间列表
        Gui Add, Edit, x121 y94 w350 h19 v剪切时间列表str, %剪切时间列表str%
        ; GroupBox Output
        Gui Add, GroupBox, x19 y138 w461 h85, Output
        Gui Add, Text, x30 y159 w80 h23 +0x200, 输出文件名
        Gui Add, Edit, x121 y160 w350 h19 v输出文件名, %输出文件名%
        Gui Add, Text, x30 y187 w80 h23 +0x200, 输出目录
        Gui Add, Edit, x121 y188 w350 h19 +ReadOnly v输出目录, %输出目录%
        ; GroupBox Options
        Gui Add, GroupBox, x19 y235 w461 h85, Options
        Gui Add, Text, x30 y256 w80 h23 +0x200, 剪辑后缀
        Gui Add, Edit, x121 y257 w350 h19 +ReadOnly v剪辑后缀, _剪辑_
        Gui Add, Text, x30 y284 w80 h23 +0x200, 改分辨率
        Gui Add, Edit, x121 y285 w350 h19 +ReadOnly, 1280x720
    Gui Tab

    Gui Show, , ffmpeg剪切视频GUI - (需在path设置ffmpeg路径)
    Return

    ; ----------------------------------------------------------
    ; gui 事件处理部分
    ; ----------------------------------------------------------
    Button修改分辨率:
        Gui, Submit  ; 保存用户的输入到每个控件的关联变量中.
        ; 1. 检验源文件路径, 清洗两边的双引号, 检查源文件路径是否存在
        源文件路径:= Trim(源文件路径,"""")
        if(! FileExist(源文件路径)){
            Gui Restore
            msgbox 源文件路径错误或文件不存在!
            return
        }
        if(ffmpeg修改视频分辨率(源文件路径))
            msgbox finished
        else
            msgbox 剪切结果异常
        ; 返回操作窗口
        Gui Restore
    return

    Button剪切:
        Gui, Submit  ; 保存用户的输入到每个控件的关联变量中.
        ; 1. 检验源文件路径, 清洗两边的双引号, 检查源文件路径是否存在
        源文件路径:= Trim(源文件路径,"""")
        if(! FileExist(源文件路径)){
            Gui Restore
            msgbox 源文件路径错误或文件不存在!
            return
        }

        if(ffmpeg剪切视频(源文件路径, 输出文件名, Trim(剪切时间列表str, ","), 输出目录, 剪辑后缀))
            msgbox finished
        else
            msgbox 剪切结果异常
        ; 返回操作窗口
        Gui Restore
    return

    Button保存设置:
        Gui, Submit  ; 保存用户的输入到每个控件的关联变量中.

        if(保存设置(源文件路径, 输出文件名, Trim(剪切时间列表str, ","), 输出目录, 剪辑后缀)){
            msgbox, 保存设置完成.
        }
        else{
            msgbox, 保存设置文件异常!!
        }
        ; 返回操作窗口
        Gui Restore
    Return


    ButtonExit:
    GuiEscape:
    GuiClose:
        Gui, Destroy
        ExitApp
    return
}

; 时间列表格式
; [
;       [
;          "01:05:03.830",
;          "01:10:20.443"
;       ],
;       [
;          "01:10:26.590",
;          "01:15:43.441"
;       ]
; ]
时间列表转字符串(_时间列表){
    _时间列表str := ""

    Loop % _时间列表.Length() {
        开始时间        := _时间列表[A_Index][1]
        结束时间        := _时间列表[A_Index][2]
        _时间列表str    .= 开始时间 . "-" . 结束时间 . ","
    }
    return _时间列表str
}

;
获取并清洗设置信息(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_"){
    ; 返回结果
    _设置 := {}

    ; 基本参数
    _设置.源文件路径  := _源文件路径

    _源文件obj  := 分析文件路径(_源文件路径)

    _设置.源文件名    := _源文件obj.文件名
    _设置.输出文件名  := _输出文件名!="" ? _输出文件名 : _源文件obj.文件名
    ; 输出参数
    _设置.输出目录    := _输出目录!="" ? _输出目录 : A_Desktop
    _设置.输出扩展名  := SubStr(_源文件路径, InStr(_源文件路径, ".", false, 0)+1)
    _设置.剪辑后缀    := _剪辑后缀

    ; 输出文件名长度务必小于80
    if(StrLen(_设置.输出文件名) > 80){
        msgbox % "输出文件名长度超过80, 需重新设置文件名! `n`n" . _设置.输出文件名 . "`n`n80个字符参考:`n`n" . substr(_设置.输出文件名, 1, 80)
        return false
    }

    剪切时间列表_修正前 := IsObject(_剪切时间列表) ? _剪切时间列表 : StrSplit(_剪切时间列表, ",", " ")
    _设置.剪切时间列表  := []

    ; 剪切时间列表格式, [["开始时间","结束时间"], [...], ...]
    Loop % 剪切时间列表_修正前.Length() {
        _时间段     := StrSplit(剪切时间列表_修正前[A_Index], "-", " ")
        _时间段[1]  := 清洗时间字符串(_时间段[1])
        _时间段[2]  := 清洗时间字符串(_时间段[2])
        if(_时间段[1] == _时间段[2]){
            MsgBox, % Format("第 {1} 组时间段错误, 开始时间==结束时间, `n`n{2}-{3}", A_Index, _时间段[1], _时间段[2])
            return false
        }
        _设置.剪切时间列表.Push(_时间段)
    }

    ; 返回设置对象
    Return _设置
}

创建日志文件路径(_目录, _文件名, _扩展名:="json", _文件名前缀:="剪切任务"){
    return format("{1}\{2}_{3}.{4}"
                    , _目录
                    , _文件名前缀
                    , _文件名
                    , _扩展名)
}

记录操作日志(_argObj设置, _arg日志文件扩展名:="json", _arg日志文件名前缀:="剪切任务"){
    ; 基本参数
    _设置 := _argObj设置
    
    ; ----------------------------------------------------------
    ; 保存修正后的_, 到输出目录; 
    ; 文件名: 剪切视频_源文件名.log 
    _log_file_path := 创建日志文件路径(_设置.输出目录
                                    , _设置.源文件名
                                    , _arg日志文件扩展名
                                    , _arg日志文件名前缀)


    FormatTime, _脚本开始时间,, yyyy-MM-dd HH:mm:ss
    _设置.记录时间 := _脚本开始时间
    ; 把设置信息写入json文件
    JsonFile.write(_设置, _log_file_path)

    ; ----------------------------------------------------------
    ; 验证结果: 预期生成文件验证
    resultBool         := true
    ; 验证结果: 对预期生成文件验证
    if(! FileExist(_log_file_path)){
        resultBool := false
    }
    ; end
    return resultBool
}

; 保存设置(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_")
保存设置(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_"){
    ; 基本参数
    _设置 := 获取并清洗设置信息(_源文件路径, _输出文件名, _剪切时间列表, _输出目录, _剪辑后缀)

    if(_设置){
        return 记录操作日志(_设置)
    }
    Else{
        Return false
    }
}

; ffmpeg剪切视频(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_")
ffmpeg剪切视频(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_"){
    ; 基本参数
    _设置 := 获取并清洗设置信息(_源文件路径, _输出文件名, _剪切时间列表, _输出目录, _剪辑后缀)
    if(! _设置)
        return false        
    
    记录操作日志(_设置)

    ; 验证结果: 预期生成文件验证
    预期生成文件列表    := []
    resultBool       := true
    ; ----------------------------------------------------------
    ; 主要功能部分
    ; 批量剪切时间段开始
    Loop % _设置.剪切时间列表.Length() {

        开始时间    := _设置.剪切时间列表[A_Index][1]
        结束时间    := _设置.剪切时间列表[A_Index][2]
        剪切时间段  := 开始时间 . "-" . 结束时间

        ; 使用时间段后缀
        输出路径:= Format("{1}\{2}{3}{4}.{5}"
                        , _设置.输出目录
                        , _设置.输出文件名
                        , _设置.剪辑后缀
                        , StrReplace(剪切时间段, ":", "_")
                        , _设置.输出扩展名)   
        
        ; 加入预期结果
        预期生成文件列表.push(输出路径)
        strCmd:= format("ffmpeg -ss {1} -to {2} -i ""{3}"" -vcodec copy -acodec copy ""{4}"""
                    , 开始时间
                    , 结束时间
                    , _设置.源文件路径
                    , 输出路径)

        RunWait %comSpec% /c %strCmd%

    }
    ; ----------------------------------------------------------
    ; 验证结果: 对预期生成文件验证
    for i, _file in 预期生成文件列表{
        if(! FileExist(_file)){
            resultBool := false
            break
        }
    }
    return resultBool
}

/*
ffmpeg修改视频分辨率(_源文件路径, _分辨率:="1280x720", _输出目录:="")
*/
ffmpeg修改视频分辨率(_源文件路径, _分辨率:="1280x720", _输出目录:=""){
    源文件路径  := _源文件路径
    分辨率      := _分辨率
    输出目录    := _输出目录!="" ? _输出目录 : A_Desktop
    文件名长度  := InStr(源文件路径, ".", false, 0) - InStr(源文件路径, "\", false, 0) - 1
    输出文件名  := SubStr(源文件路径, InStr(源文件路径, "\", false, 0)+1, 文件名长度)
    输出扩展名  := SubStr(源文件路径, InStr(源文件路径, ".", false, 0)+1)
    输出后缀    := "_resize_" . 分辨率
    输出路径:=  输出目录 . "\" . 输出文件名 . 输出后缀 . "." . 输出扩展名
    ; 生成ffmpeg命令
    strCmd:= format("ffmpeg -i ""{1}"" -s {2} ""{3}"""
                , 源文件路径
                , 分辨率
                , 输出路径)
    ; 在cmd中执行命令
    RunWait %comSpec% /c %strCmd%
    ; 对生成文件进行验证
    if(FileExist(输出路径))
        return true
    else
        return false
}

/*
分析文件路径(_文件路径)
*/
分析文件路径(_文件路径){
    ret := {}
    if(_文件路径 != ""){
        _begin_pos  := InStr(_文件路径, "\", false, 0, 2)
        _end_pos    := InStr(_文件路径, "\", false, 0, 1)
        _dot_pos    := InStr(_文件路径, ".", false, 0, 1)
        ret.文件名   := SubStr(_文件路径, _end_pos + 1, _dot_pos - _end_pos - 1)
        ret.扩展名   := SubStr(_文件路径, _dot_pos + 1)
        ret.当前目录名:= SubStr(_文件路径, _begin_pos + 1, _end_pos - _begin_pos - 1)
        ret.目录路径  := SubStr(_文件路径, 1, _end_pos - 1)
    }
    return ret
}

清洗时间字符串(_时间字符串){
    ; 清洗对象
    ; 00.41.02.715 => 00:41:02.715
    ; 01_54_19.818 => 01:54:19.818
    ret := _时间字符串
    strmatch := "(\d{1,2}).(\d{1,2}).(\d{1,2}).(\d{1,3})"
    if(RegExMatch(_时间字符串, strmatch, match)<0){
        msgbox, 函数 清洗时间字符串(_时间字符串)`n 输入字符串格式不能识别 `n正确格式为"00.41.02.715" "01_54_19.818"
    }
    else{
        ret := Format("{1}:{2}:{3}.{4}"
                    , match1
                    , match2
                    , match3
                    , match4)
    }

    return ret
}
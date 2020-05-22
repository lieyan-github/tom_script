; ----------------------------------------------------------
; ffmpeg视频处理GUI.ahk
;
; tom
;
; 2019-07-05 22:24:37
; ----------------------------------------------------------
;主要功能
;1. 主程序ffmpeg视频处理gui()
;2. 功能, 按时间段剪切, 修改视频分辨率

ffmpeg视频处理gui()

ffmpeg视频处理gui(){
    static 源文件路径, 剪切时间列表, 输出文件名, 输出目录, 剪辑后缀
    ; 获取文件路径, 通过复制获得
    send ^c
    sleep 200
    if FileExist(Clipboard){
        源文件路径   := Clipboard
        ; 获取目录和文件名前的 \ 位置
        _begin_pos  := InStr(源文件路径, "\", false, 0, 2)
        _end_pos    := InStr(源文件路径, "\", false, 0, 1)
        _dot_pos    := InStr(源文件路径, ".", false, 0, 1)
        _文件名      := SubStr(源文件路径, _end_pos + 1, _dot_pos - _end_pos - 1)
        _扩展名      := SubStr(源文件路径, _dot_pos + 1)
        _当前目录名  := SubStr(源文件路径, _begin_pos + 1, _end_pos - _begin_pos - 1)
        if(InStr(_当前目录名, "#") == 1 and not(InStr(_文件名, "#"))){
            输出文件名   := _当前目录名
            输出文件名   := StrReplace(输出文件名, "#av作品#", "#av剪辑#")
        }
        else
            输出文件名   := _文件名
    }
    ; 初始化窗体公共部分
    Gui Add, Button, x11 y350 w80 h23, &Exit
    Gui Add, Button, x409 y350 w80 h23, 剪切
    Gui Add, Button, x309 y350 w80 h23, 修改分辨率
    ;Gui Add, Text, x150 y240 w220 h20 +0x200, 注意: 需提前在path设置ffmpeg路径
    Gui Add, Tab3, x12 y12 w477 h320, Main|Options
    ; Tab Main
    Gui Tab, 1
        gui, font, s10, Consolas
        Gui Add, GroupBox, x19 y41 w461 h85, Files
        Gui Add, Text, x30 y65 w80 h23 +0x200, 源文件路径
        Gui Add, Edit, x121 y66 w350 h19 v源文件路径, %源文件路径%
        Gui Add, Text, x30 y93 w80 h23 +0x200, 时间列表
        Gui Add, Edit, x121 y94 w350 h19 v剪切时间列表
        ; GroupBox Output
        Gui Add, GroupBox, x19 y138 w461 h85, Output
        Gui Add, Text, x30 y159 w80 h23 +0x200, 输出文件名
        Gui Add, Edit, x121 y160 w350 h19 v输出文件名, %输出文件名%
        Gui Add, Text, x30 y187 w80 h23 +0x200, 输出目录
        Gui Add, Edit, x121 y188 w350 h19 +ReadOnly v输出目录, %A_Desktop%
        ; GroupBox Options
        Gui Add, GroupBox, x19 y235 w461 h85, Options
        Gui Add, Text, x30 y256 w80 h23 +0x200, 剪辑后缀
        Gui Add, Edit, x121 y257 w350 h19 +ReadOnly v剪辑后缀, _剪辑_
        Gui Add, Text, x30 y284 w80 h23 +0x200, 改分辨率
        Gui Add, Edit, x121 y285 w350 h19 +ReadOnly, 1280x720
    Gui Tab

    Gui Show, , ffmpeg剪切视频GUI - (需在path设置ffmpeg路径)
    Return

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
        ; 2 检查剪切时间列表格式是否合法; 正则测试无效debug 待解决
        ;剪切时间列表:= "00:00:41.722-00:01:56.771, 00:00:41.722-00:01:56.771, 00:00:41.722-00:01:56.771"
;        剪切时间列表:= "00:00:"
;        if(! 剪切时间列表 ~= "\d{2}:\d{2}:\d{2}(\.\d{1,3})?-\d{2}:\d{2}:\d{2}(\.\d{1,3})?(\,\s?\d{2}:\d{2}:\d{2}(\.\d{1,3})?-\d{2}:\d{2}:\d{2}(\.\d{1,3})?)*"){
;            Gui Restore
;            msgbox 剪切时间列表格式错误, 应该为"00:00:41.722-00:01:56.771, ..."
;            return
;        }
;        else
;            msgbox 匹配 %剪切时间列表%

        if(ffmpeg剪切视频(源文件路径, 输出文件名, Trim(剪切时间列表, ","), 输出目录, 剪辑后缀))
            msgbox finished
        else
            msgbox 剪切结果异常
        ; 返回操作窗口
        Gui Restore
    return

    ButtonExit:
    GuiEscape:
    GuiClose:
        Gui, Destroy
        ExitApp
    return
}

ffmpeg剪切视频(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:="", _剪辑后缀:="_剪辑_"){
    ; 基本参数
    源文件路径  := _源文件路径
    源文件名长度:= InStr(源文件路径, ".", false, 0) - InStr(源文件路径, "\", false, 0) - 1
    输出文件名  := _输出文件名!="" ? _输出文件名 : SubStr(源文件路径, InStr(源文件路径, "\", false, 0)+1, 源文件名长度)
    剪切时间列表:= IsObject(_剪切时间列表) ? _剪切时间列表 : StrSplit(_剪切时间列表, ",", " ")
    输出目录    := _输出目录!="" ? _输出目录 : A_Desktop
    输出扩展名  := SubStr(源文件路径, InStr(源文件路径, ".", false, 0)+1)
    剪辑后缀    := _剪辑后缀
    ; 验证结果: 预期生成文件验证
    预期生成文件列表    := []
    resultBool  := true
    ; ----------------------------------------------------------
    ; 主要功能部分
    ; 批量剪切时间段开始
    for i, value in 剪切时间列表 {
        剪切时间段:= value
        间隔符位置:= InStr(剪切时间段,"-")
        开始时间:= SubStr(剪切时间段, 1, 间隔符位置-1)
        结束时间:= SubStr(剪切时间段, 间隔符位置+1)
        ; 使用序号后缀
        ;输出路径:=  输出目录 . "\" . 输出文件名 . 剪辑后缀 . i . "." . 输出扩展名
        ; 使用时间段后缀
        输出路径:=  输出目录 . "\" . 输出文件名 . 剪辑后缀 . StrReplace(剪切时间段, ":", "_") . "." . 输出扩展名
        ; 加入预期结果
        预期生成文件列表.push(输出路径)
        strCmd:= format("ffmpeg -ss {1} -to {2} -i ""{3}"" -vcodec copy -acodec copy ""{4}"""
                    , 开始时间
                    , 结束时间
                    , 源文件路径
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

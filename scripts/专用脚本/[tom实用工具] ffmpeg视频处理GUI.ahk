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

ffmpeg视频处理gui(){
    static 源文件路径, 剪切时间列表, 输出文件名

    ; 窗体公共部分
    Gui Add, Button, x11 y242 w80 h23, &Exit
    Gui Add, Button, x409 y240 w80 h23, 剪切
    Gui Add, Button, x309 y240 w80 h23, 修改分辨率
    ;Gui Add, Text, x150 y240 w220 h20 +0x200, 注意: 需提前在path设置ffmpeg路径
    Gui Add, Tab3, x12 y12 w477 h215, Main|Options
    ; Tab Main
    Gui Tab, 1
        Gui Add, GroupBox, x19 y41 w461 h85, Files
        Gui Add, Text, x33 y65 w70 h22 +0x200, 源文件路径:
        Gui Add, Edit, x121 y67 w350 h19 v源文件路径
        Gui Add, Text, x33 y93 w66 h23 +0x200, 时间列表:
        Gui Add, Edit, x121 y94 w350 h19 v剪切时间列表
        ; GroupBox Output
        Gui Add, GroupBox, x20 y138 w253 h76, Output
        Gui Add, Text, x27 y159 w64 h23 +0x200, 输出文件名:
        Gui Add, Edit, x96 y161 w160 h19 v输出文件名
        Gui Add, Text, x27 y187 w56 h23 +0x200, 输出目录:
        Gui Add, Edit, x96 y188 w160 h19 +ReadOnly, 默认输出到桌面
        ; GroupBox Options
        Gui Add, GroupBox, x280 y138 w199 h76, Options
        Gui Add, Text, x287 y160 w56 h23 +0x200, 分割后缀:
        Gui Add, Edit, x352 y160 w118 h19 +ReadOnly, _clip
        Gui Add, Text, x287 y187 w56 h23 +0x200, 改分辨率:
        Gui Add, Edit, x352 y188 w118 h19 +ReadOnly, 1280x720
    Gui Tab

    Gui Show, w504 h277, ffmpeg剪切视频GUI - (需在path设置ffmpeg路径)
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

        if(ffmpeg剪切视频(源文件路径, 输出文件名, Trim(剪切时间列表, ",")))
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
        Exit
    return
}

ffmpeg剪切视频(_源文件路径, _输出文件名, _剪切时间列表, _输出目录:=""){
    ; 基本参数
    源文件路径  := _源文件路径
    源文件名长度:= InStr(源文件路径, ".", false, 0) - InStr(源文件路径, "\", false, 0) - 1
    输出文件名  := _输出文件名!="" ? _输出文件名 : SubStr(源文件路径, InStr(源文件路径, "\", false, 0)+1, 源文件名长度)
    剪切时间列表:= IsObject(_剪切时间列表) ? _剪切时间列表 : StrSplit(_剪切时间列表, ",", " ")
    输出目录    := _输出目录!="" ? _输出目录 : A_Desktop
    输出扩展名  := SubStr(源文件路径, InStr(源文件路径, ".", false, 0)+1)
    分割后缀    := "_clip"
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
        输出路径:=  输出目录 . "\" . 输出文件名 . 分割后缀 . i . "." . 输出扩展名
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

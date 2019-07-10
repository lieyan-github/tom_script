; ==========================================================
; ----------------------------------------------------------
; lib_系统窗口控制类
;
; 作者: 烈焰
;
; 2017-02-04 03:55:11
; ----------------------------------------------------------
; ==========================================================

; debugtest 测试使用, 仅在非#include, 单独启动时可用,
; #If !(A_IsCompiled or A_LineFile!=A_ScriptFullPath)
;     F1::
;         MouseGetPos, x, y, wid, cid, 2
;         wid2:=windowFromPoint(x, y, cid2)
;         ;wid2:=windowFromPoint(cid2, 66, 88)
;         MsgBox,4096,, %wid% -- %cid%`n%wid2% -- %cid2%
;     return
; #If

; 获取屏幕指定位置的窗口id和控件id
windowFromPoint(x, y, ByRef cid){
    CoordMode_bak:=A_CoordModeMouse
    CoordMode, Mouse, Screen
    blockinput, on
    MouseGetPos, x_bak, y_bak,
    MouseMove, x, y, 0
    MouseGetPos, , , _wid, _cid, 2
    cid:= _cid
    MouseMove, x_bak, y_bak, 0
    blockinput, off
    CoordMode, Mouse, %CoordMode_bak%
    return _wid
}

; inWinList(_winList, _winTitle_type)
; 判断是否指定窗体
; static method
; _winList :=  [
;                  "ie.exe",
;                  "GomPlayer.exe"
;              ]
inWinList(_winList, _winTitle_type:="exe"){
    _bool := false
    ;---
    if(_winTitle_type == "exe"){
        WinGet, _exe, ProcessName, A
        _bool := arrayIndex(_winList, _exe) > 0
    }
    else if(_winTitle_type == "class"){
        WinGetClass, _class, A
        _bool := arrayIndex(_winList, _class) > 0
    }
    else if(_winTitle_type == "id"){
        WinGet, _hwnd, ID, A
        _bool := arrayIndex(_winList, _hwnd) > 0
    }
    else if(_winTitle_type == "pid"){
        WinGet, _pid, PID, A
        _bool := arrayIndex(_winList, _pid) > 0
    }
    else{
        WinGetTitle, _title, A
        _bool := arrayIndex(_winList, _title) > 0
    }
    ;---
    return _bool
}

; 窗口白名单Config.upath("allowResizeWinsFile")
添加窗口到白名单(){
    ; 获取当前窗口
    _wininfo:= 获取窗口信息()
    ; 检测当前窗口是否已在白名单
    _allowResizeWins := 允许调整窗口白名单()
    _winName := _wininfo["window"]["exe"]
    _exist := arrayIndex(_allowResizeWins, _winName) > 0
    if(! _exist){
        ; 如果不存在 则提示添加, 设置窗口名称
        if(用户修改变量(_winName
            , "窗口名称"
            , _wininfo["window"]["exe"])=true){
            ;修改json对象, 并保存到文件
            _allowResizeWins.push(_winName)
            JsonFile.write(_allowResizeWins, Config.upath("allowResizeWinsFile"))
            show_msg("当前窗口已添加到白名单")
        }
    }
    else
        show_msg("当前窗口已经存在白名单")
}

; 窗口白名单Config.upath("allowResizeWinsFile")
从白名单删除窗口(){
    ; 获取当前窗口
    _wininfo:= 获取窗口信息()
    ;让使用者确认是否进行操作
    if(操作确认("操作确认", "你确定要从白名单删除当前窗口吗?")=false)
        return

    ; 检测当前窗口是否已在白名单
    _allowResizeWins := 允许调整窗口白名单()
    _winName := _wininfo["window"]["exe"]
    _exist := arrayIndex(_allowResizeWins, _winName) > 0
    if(! _exist)
        show_msg("当前窗口不在白名单")
    else{
        ; 如果存在 则提准备删除, 先获取索引
        arrayRemoveByValue(_allowResizeWins, _winName)
        JsonFile.write(_allowResizeWins, Config.upath("allowResizeWinsFile"))
        show_msg("当前窗口已从白名单删除")
    }
}

; 获取窗口白名单()
; 返回json对象
; 窗口白名单Config.upath("allowResizeWinsFile")
允许调整窗口白名单(){
    return JsonFile.read(Config.upath("allowResizeWinsFile"))
}

; ----------------------------------------------------------
; 获取窗口信息()
; ----------------------------------------------------------
获取窗口信息()
{
    _wininfo := {}
    ; 输出结果
    _returns := ""

    ;--- 窗体信息
    WinGet, this_id, ID, A
    WinGet, this_exe, ProcessName, A
    WinGet, this_pid, PID, A
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    WinGetPos , winX, winY, winW, winH, ahk_id %this_id%
    _wininfo.window := {"id": this_id
                      , "pid": this_pid
                      , "exe": this_exe
                      , "class": this_class
                      , "title": this_title
                      , "pos": {"x":winX, "y":winY, "w":winW, "h":winH}}

    ;--- 鼠标信息(默认相对于当前窗体)
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX_screen, mouseY_screen
    CoordMode, Mouse, Window
    MouseGetPos, mouseX, mouseY, mouseUnderwinId, mouseUnderControlClass
    PixelGetColor, pixColor, mouseX, mouseY, RGB
    _wininfo.mouse := {"x_screen": mouseX_screen
                      , "y_screen": mouseY_screen
                      , "x": mouseX
                      , "y": mouseY
                      , "pixColor": new Color(pixColor)
                      , "UnderwinId": mouseUnderwinId
                      , "UnderControlClass": mouseUnderControlClass}

    ;--- 获取监视器的总数
    SysGet, monitorCount, MonitorCount
    SysGet, monitorPrimary, MonitorPrimary
    ;--- 屏幕信息
    SysGet, monitorWorkArea, MonitorWorkArea
    SysGet, monitor, Monitor
    ;--- 虚拟屏幕的宽度和高度, 单位为像素. 虚拟屏幕是所有监视器的边框
    SysGet, VirtualScreenWidth, 78
    SysGet, VirtualScreenHeight, 79
    _wininfo.monitor := {"count": monitorCount
                            , "primary": monitorPrimary
                            , "monitor": {"l": monitorLeft
                                            , "r": monitorRight
                                            , "t": monitorTop
                                            , "b": monitorBottom}
                            , "workArea": {"l": monitorWorkAreaLeft
                                            , "r": monitorWorkAreaRight
                                            , "t": monitorWorkAreaTop
                                            , "b": monitorWorkAreaBottom}
                            , "VirtualScreenW": VirtualScreenWidth
                            , "VirtualScreenH": VirtualScreenHeight}

    ;--- 从 ControlList 中提取每个控件的名称:
    controlList_name := []
    WinGet, ActiveControlList, ControlList, ahk_id %this_id%
    Loop, Parse, ActiveControlList, `n
    {
        arrayAppend(controlList_name, A_LoopField)
    }
    _wininfo.controls := controlList_name
    ;--- ends
    return _wininfo
}

; ----------------------------------------------------------
; 打开并调整窗口()
; ----------------------------------------------------------
打开窗口(_filepath, _position:=4, _总列数:=2, _总行数:=2)
{
    打开并调整窗口(_filepath, _position, _总列数, _总行数)
}

; ----------------------------------------------------------
; 打开并调整窗口()
; ----------------------------------------------------------
打开并调整窗口(_filepath, _position:=4, _总列数:=2, _总行数:=2)
{
    run %_filepath%
    sleep 1000
    if(inWinList(["explorer.exe"])) {
        ; 资源管理器窗口
        快捷操作_移动当前窗口_并调整大小(_position, _总列数, _总行数)
    }
}

; ----------------------------------------------------------
; 窗口置顶,再按一次恢复正常
; ----------------------------------------------------------
窗口置顶()
{
    WinGetPos,,,WidthCheck,HeightCheck,A
    If (WidthCheck>=A_ScreenWidth AND HeightCheck>=A_ScreenHeight)
        Return
    WinSet,AlwaysOnTop,Toggle,A
    WinGetPos,WinX,WinY,WinW,WinH,A
    gui,50:-maximizebox -minimizebox -caption +alwaysontop +Owner
    gui,50:color,CB5B57
    gui,50:show,x%WinX% Y%WinY% w%WinW% h%WinH% NA,flash
    Trans:=255
    Loop,5
    {
        Trans -=50
        WinSet, TransColor, white %Trans%, flash
        sleep 80
    }
    gui,50:destroy
}

; ----------------------------------------------------------
; 快捷操作 - 鼠标快速向左调整窗口()
; ----------------------------------------------------------
鼠标快速向左调整窗口()
{
    WinGet, active_id, ID, A
    SysGet, monitor, MonitorWorkArea
    WinGetPos, x, y, w, h, A
    _空白宽度:=2
    ;---- 先将窗口从可能的最大化状态恢复
    WinRestore, A
    ;---- 以屏幕中线分割, 划分响应处理方式
    if(x<monitorRight/2)    ;--- 左侧响应区域
    {
        ;---- 第一种情况, 窗口在窗口左半边, 则保持在屏幕左侧, 屏幕一半宽度;
        WinMove, A, , 0, 0, monitorRight/2-_空白宽度, monitorBottom,
    }
    else                    ;--- 右侧响应区域
    {
        ;---- 第二种情况, 窗口靠屏幕右半边, 则只是扩大窗口到屏幕的2/3;
        WinMove, A, , monitorRight/3, 0, monitorRight/3*2, monitorBottom,
    }
}

; ----------------------------------------------------------
; 快捷操作 - 鼠标快速向右调整窗口()
; ----------------------------------------------------------
鼠标快速向右调整窗口()
{
    WinGet, active_id, ID, A
    SysGet, monitor, MonitorWorkArea
    WinGetPos, x, y, w, h, A
    _空白宽度:=2
    ;---- 先将窗口从可能的最大化状态恢复
    WinRestore, A
    ;---- 以屏幕中线分割, 划分响应处理方式
    if(x+w<monitorRight/2+3)    ;--- 左侧响应区域
    {
        ;---- 第一种情况, 窗口靠左侧, 则只是扩大窗口到屏幕的2/3;
        WinMove, A, , 0, 0, monitorRight/3*2, monitorBottom,
    }
    else                        ;--- 右侧响应区域
    {
        ;---- 第二种情况, 窗口已经到达右边界
        WinMove, A, , monitorRight/2+_空白宽度, 0, monitorRight/2-_空白宽度, monitorBottom,
    }
}

; ----------------------------------------------------------
; 快捷操作 - 鼠标单键切换窗口y轴大小()
; ----------------------------------------------------------
鼠标单键切换窗口y轴大小()
{
    WinGet, active_id, ID, A
    SysGet, monitor, MonitorWorkArea
    WinGetPos, x, y, w, h, A
    _空白宽度:=2
    ;---- 先将窗口从可能的最大化状态恢复
    WinRestore, A
    ;---- 划分响应处理方式
    if(y==monitorBottom/2+_空白宽度 && h==monitorBottom/2-_空白宽度)
    {
        ;如果窗口在屏幕下半侧, 则把窗口调整到上半侧
        WinMove, A, , , 0, , monitorBottom/2-_空白宽度
    }
    else if(h>=monitorBottom)
    {
        ;如果窗口纵向最大化, 则将窗口调整到屏幕下半侧
        WinMove, A, , , monitorBottom/2+_空白宽度, , monitorBottom/2-_空白宽度
    }
    else
    {
        ;默认将屏幕纵向最大化
        WinMove, A, , , 0, , monitorBottom
    }
}

; ----------------------------------------------------------
; 快捷操作 - 鼠标单键切换窗口x轴大小()
; ----------------------------------------------------------
鼠标单键切换窗口x轴大小()
{
    WinGet, active_id, ID, A
    SysGet, monitor, MonitorWorkArea
    WinGetPos, x, y, w, h, A
    _空白宽度:=2
    ;---- 先将窗口从可能的最大化状态恢复
    WinRestore, A
    ;---- 划分响应处理方式
    if(x==monitorRight/2+_空白宽度 && w==monitorRight/2-_空白宽度)
    {
        ;如果窗口在屏幕右半侧, 则把窗口调整到左半侧
        WinMove, A, , 0, , monitorRight/2-_空白宽度
    }
    else if(w>=monitorRight)
    {
        ;如果窗口纵向最大化, 则将窗口调整到屏幕右半侧
        WinMove, A, , monitorRight/2+_空白宽度, , monitorRight/2-_空白宽度
    }
    else
    {
        ;默认将屏幕横向最大化
        WinMove, A, , 0, , monitorRight
    }
}

; ----------------------------------------------------------
; 快捷操作 - 调整当前窗口大小
; ----------------------------------------------------------
快捷操作_调整当前窗口大小(方向){
    if(方向="up")
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if(y<=0)
        {
            WinMove, A, , , 0, , h-40
            tip_msg:= "Window`n  size: " . w . "*" . (h-40)
            show_msg(tip_msg)
        }
        else
        {
            WinMove, A, , , 0, , monitorBottom
            tip_msg:= "Window`n  size: " . w . "*" . monitorBottom
            show_msg(tip_msg)
        }
    }
    if(方向="down")
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if((y+h)>=monitorBottom)
        {
            WinMove, A, , , y+40, , h-40
            tip_msg:= "Window`n  size: " . w . "*" . (h-40)
            show_msg(tip_msg)
        }
        else
        {
            WinMove, A, , , 0, , monitorBottom
            tip_msg:= "Window`n  size: " . w . "*" . monitorBottom
            show_msg(tip_msg)
        }
    }
    if(方向=8)
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if(y<=0)    ;如果窗口已经顶在上边界, 那么向上就是向上缩小
        {
            WinMove, A, , , , ,h-20
            tip_msg:= "Window`n  size: " . w . "*" . (h-20)
        }
        else
        {
            tmp_y:= y-20
            if(tmp_y<=0)
            {
                tmp_y:= 0
            }
            tmp_h:= h+20
            if((tmp_y+tmp_h)>=monitorBottom)
            {
                tmp_h:= monitorBottom-tmp_y
            }
            WinMove, A, , x, tmp_y, w, tmp_h
            tip_msg:= "Window`n  size: " . w . "*" . tmp_h
            tip_msg.= "`n  x: " . x . "`n  y: " . tmp_y
        }
        show_msg(tip_msg)
    }
    if(方向=2)
    {
        WinGetPos, x, y, w, h, A
        ;如果窗口已经顶在下边界, 那么向下就是向下缩小
        SysGet, monitor, MonitorWorkArea
        if((y+h)>=monitorBottom)
        {
            WinMove, A, , x, y+20, w, h-20
            tip_msg:= "Window`n  size: " . w . "*" . (h-20)
            tip_msg.= "`n  x: " . x . "`n  y: " . (y+20)
        }
        else
        {
            tmp_h:= h+20
            if((y+tmp_h)>=monitorBottom)
            {
                tmp_h:= monitorBottom-y
            }
            WinMove, A, , , , ,tmp_h
            tip_msg:= "Window`n  size: " . w . "*" . tmp_h
        }
        show_msg(tip_msg)
    }
    if(方向=4)
    {
        WinGetPos, x, y, w, h, A

        SysGet, monitor, MonitorWorkArea
        if(x<=0)    ;如果窗口已经顶在左边界, 那么向左就是向左缩小
        {
            WinMove, A, , , , w-20
            tip_msg:= "Window`n  size: " . (w-20) . "*" . h
        }
        else        ;如果不在左边界, 那么一般向左就是向左扩大
        {
            tmp_x:= x-20
            if(tmp_x<=0)
            {
                tmp_x:= 0
            }
            tmp_w:= w+20
            if((tmp_x+tmp_w)>=monitorRight)
            {
                tmp_w:= monitorRight-tmp_x
            }
            WinMove, A, , tmp_x, y, tmp_w, h
            tip_msg:= "Window`n  size: " . tmp_w . "*" . h
            tip_msg.= "`n  x: " . tmp_x . "`n  y: " . y
        }
        show_msg(tip_msg)
    }
    if(方向=6)
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if((x+w)>=monitorRight) ;如果窗口已经顶在右边界, 那么向右就是向右缩小
        {
            WinMove, A, , x+20, y, w-20, h
            tip_msg:= "Window`n  size: " . (w-20) . "*" . h
            tip_msg.= "`n  x: " . (x+20) . "`n  y: " . y
        }
        else        ;如果不在右边界, 那么一般向右就是向左扩大
        {
            tmp_w:= w+20
            if((x+tmp_w)>=monitorRight)
            {
                tmp_w:= monitorRight-x
            }
            WinMove, A, , , , tmp_w
            tip_msg:= "Window`n  size: " . tmp_w . "*" . h
        }
        show_msg(tip_msg)
    }
}

; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口
; _options := {"w":1280, "h":720}
; ----------------------------------------------------------
快捷操作_移动当前窗口(方向, _options=""){
    if(方向=8)
    {
        WinGetPos, x, y, w, h, A
        if((y-20)<0)
        {
            WinMove, A, , , 0
            tip_msg:= "Window`n  x: " . x . "`n  y: " . 0
        }
        else
        {
            WinMove, A, , , y-20
            tip_msg:= "Window`n  x: " . x . "`n  y: " . (y-20)
        }
        show_msg(tip_msg)
    }
    if(方向=2)
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if((y+h+20)>monitorBottom)
        {
            WinMove, A, , , monitorBottom-h
            tip_msg:= "Window`n  x: " . x . "`n  y: " . (monitorBottom-h)
        }
        else
        {
            WinMove, A, , , y+20
            tip_msg:= "Window`n  x: " . x . "`n  y: " . (y+20)
        }
        show_msg(tip_msg)
    }
    if(方向=4)
    {
        WinGetPos, x, y, w, h, A
        if((x-20)<0)
        {
            WinMove, A, , 0
            tip_msg:= "Window`n  x: " . 0 . "`n  y: " . y
        }
        else
        {
            WinMove, A, , x-20
            tip_msg:= "Window`n  x: " . (x-20) . "`n  y: " . y
        }
        show_msg(tip_msg)
    }
    if(方向=6)
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        if((x+w+20)>monitorRight)
        {
            WinMove, A, , monitorRight-w
            tip_msg:= "Window`n  x: " . (monitorRight-w) . "`n  y: " . y
        }
        else
        {
            WinMove, A, , x+20
            tip_msg:= "Window`n  x: " . (x+20) . "`n  y: " . y
        }
        show_msg(tip_msg)
    }
    if(方向=5)
    {
        if(_options=""){
            WinGetPos, x, y, w, h, A
            SysGet, monitor, MonitorWorkArea
            if(w<300 || h<300)
                ;--- 为防止窗口太小, 适当进行扩大调整
                WinMove, A, , monitorRight/4, MonitorBottom/4, monitorRight/2, MonitorBottom/2
            else
                WinMove, A, , (monitorRight-w)/2, (MonitorBottom-h)/2
            tip_msg:= "[屏幕正中]`nWindow`n  x: " . (monitorRight-w)/2 . "`n  y: " . (MonitorBottom-h)/2
            show_msg(tip_msg)
        }
        else{
            WinGetPos, , , , , A
            SysGet, monitor, MonitorWorkArea
            w := _options.w
            h := _options.h
            if(w<300 || h<300)
                ;--- 为防止窗口太小, 适当进行扩大调整
                WinMove, A, , monitorRight/4, MonitorBottom/4, monitorRight/2, MonitorBottom/2
            else
                WinMove, A, , (monitorRight-w)/2, (MonitorBottom-h)/2, w, h
            ; debug
            ; tip_msg:= Format("[屏幕居中]`nwindow`nx: {1}`ny: {2}`nw: {3}`nh: {4}"
            ;                 , (monitorRight-w)/2
            ;                 , (MonitorBottom-h)/2
            ;                 , w
            ;                 , h)
            ; show_msg(tip_msg)
        }
    }
    ;移动窗口到右下角最小化
    if(方向=".")
    {
        WinGetPos, x, y, w, h, A
        SysGet, monitor, MonitorWorkArea
        WinMove, A, , monitorRight, MonitorBottom, 100, 100
        tip_msg:= "`nWindow`n  x: " . monitorRight . "`n  y: " . MonitorBottom
        show_msg(tip_msg)
    }
}

; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口_并调整大小
; ----------------------------------------------------------
快捷操作_移动当前窗口_并调整大小(_单元号, _总列数:=2, _总行数:=2){
    WinGet, active_id, ID, A
    SysGet, monitor, MonitorWorkArea
    定位窗口到指定单元格并自动调整大小(active_id, _单元号, monitorRight, monitorBottom, 0, 0, 0, 5, _总列数, _总行数, 0)
}

; ----------------------------------------------------------
; 快捷操作 - 多窗口管理
; 参数:
; 管理方式, 只有平铺
; 横向分屏比例, 有时候不想全屏平铺, 可以用此项设置部分屏幕
;           进行平铺, 正数在右侧, 负数在左侧
; ----------------------------------------------------------
多窗口管理(管理方式, 横向分屏比例=1, _in表格总列数=2){
    if(管理方式="平铺")
    {
        WinGet, id_list, list,,, Program Manager
        windows_array:= []
        windowsTitle_array:= [] ;debug 用于测试检查窗口标题
        windowsClass_array:= [] ;debug 用于测试检查窗口类
        先检测并获取有效的窗口数[证明有效]
        Loop, %id_list%
        {
            this_id := id_list%A_Index%
            WinActivate, ahk_id %this_id%
            WinGetTitle, this_title, ahk_id %this_id%
            WinGetClass, this_class, ahk_id %this_id%
            if(过滤有效窗口(this_title, this_class))
            {
                windows_array.insert(this_id)
                windowsTitle_array.insert(this_title)
                windowsClass_array.insert(this_class)
            }
        }
        排序有效窗口(windows_array, windowsTitle_array, windowsClass_array)
        ;所有激活窗口都最小化
        WinMinimizeAll
        ;对有效的窗口进行处理, 并记录处理信息
        tmp_result:= ""
        _内边框border:= 3
        _外边框margin:= 0
        SysGet, monitor, MonitorWorkArea
        sleep 200
        Loop % windows_array.MaxIndex()
        {
            _表格总列数:= _in表格总列数
            if(windows_array.MaxIndex()>4)
            {
                _表格总列数:= 3
            }
            if(横向分屏比例<0)
                tmp_result.= 定位窗口到指定单元格并自动调整大小(windows_array[A_Index], A_Index, monitorRight*Abs(横向分屏比例), monitorBottom, 0, 0, _外边框margin, _内边框border, _表格总列数, 2, windows_array.MaxIndex())
            else if(横向分屏比例>0)
                tmp_result.= 定位窗口到指定单元格并自动调整大小(windows_array[A_Index], A_Index, monitorRight*Abs(横向分屏比例), monitorBottom, monitorRight*(1-横向分屏比例), 0, _外边框margin, _内边框border, _表格总列数, 2, windows_array.MaxIndex())
            else    ;默认按1来全屏铺
                tmp_result.= 定位窗口到指定单元格并自动调整大小(windows_array[A_Index], A_Index, monitorRight, monitorBottom, 0, 0, _外边框margin, _内边框border, _表格总列数, 2, windows_array.MaxIndex())
        }
        ;调试, 显示记录结果
        ;msgbox, % tmp_result
        ;debug -----------------------------------
        _窗口列表清单:= arrayToStr(windowsTitle_array)
        show_msg("有效窗口[" . windowsTitle_array.MaxIndex() . "] 个, 清单已存入剪贴板`n`n" . _窗口列表清单)
        clipboard:= _窗口列表清单
        ;debug end -------------------------------
    }
}

; ----------------------------------------------------------
; 定位窗口到指定单元格并自动调整大小
; ----------------------------------------------------------
定位窗口到指定单元格并自动调整大小(_窗口id, _要获取的单元号, _表格w, _表格h, _表格x=0, _表格y=0, _外边框Margin=0, _内边框Border=3, _表格总列数=2, _表格总行数=2, _数据项总数=0)
{
    ;获取单元格定位信息
    cell_info:= 获取指定单元格信息(_要获取的单元号, _表格w, _表格h, _表格x, _表格y, _外边框Margin, _内边框Border, _表格总列数, _表格总行数, _数据项总数)

    ;开始移动定位并调整窗口大小
    this_id := _窗口id
    WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    WinMove, ahk_id %this_id%, , cell_info.x, cell_info.y, cell_info.w, cell_info.h

    ;调试, 记录结果
    tmp_result:=""
    tmp_result.= "Window`n  size: " . cell_info.w . "*" . cell_info.h . "`n"
    tmp_result.= "  x: " . cell_info.x . "`n  y: " . cell_info.y . "`n"
    tmp_result.= a_index . ".  " . this_title . " || " . this_class . "`n"
    tmp_result.= "----------------------------------------------------------`n"
    return tmp_result
}

; ----------------------------------------------------------
; [通用辅助函数]获取指定单元格信息, 返回对象{x,y,w,h,row,col,index}
; ----------------------------------------------------------
获取指定单元格信息(_要获取的单元号, _表格w, _表格h, _表格x=0, _表格y=0, _外边框Margin=0, _内边框Border=3, _表格总列数=2, _表格总行数=2, _数据项总数=0){
    ;数据项总数设置的话, 就会根据表格总列数, 自动适应来设置表格总行数, 同时就屏蔽了表格总行数的手动设置;
    if(_数据项总数>0)
    {
        _表格总行数:= mod(_数据项总数,_表格总列数)=0 ? _数据项总数//_表格总列数 : _数据项总数//_表格总列数+1
    }

    ;首先检查指定的单元号是否有效
    if(_要获取的单元号<1 or _要获取的单元号>(_表格总列数*_表格总行数))
    {
        msgbox, % "指定的单元号无效, 不在有效范围内!"
        return
    }

    ;开始统计单元格信息
    _单元格w:= (_表格w - 2 * _外边框Margin - (_表格总列数-1) * _内边框Border) / _表格总列数

    _单元格h:= (_表格h - 2 * _外边框Margin - (_表格总行数-1) * _内边框Border) / _表格总行数

    _单元格行号:= mod(_要获取的单元号,_表格总列数)=0 ? _要获取的单元号//_表格总列数 : _要获取的单元号//_表格总列数+1

    _单元格列号:= mod(_要获取的单元号,_表格总列数)=0 ? _表格总列数 : mod(_要获取的单元号,_表格总列数)

    _单元格x:= _表格x + _外边框Margin + (_单元格列号-1) * (_单元格w + _内边框Border)

    _单元格y:= _表格y + _外边框Margin + (_单元格行号-1) * (_单元格h + _内边框Border)

    return {x: _单元格x, y: _单元格y, w: _单元格w, h: _单元格h, row: _单元格行号, col: _单元格列号 , index: _要获取的单元号}
}

; ----------------------------------------------------------
; 获取无效的窗口标题_过滤列表()
; ----------------------------------------------------------
获取无效的窗口标题_过滤列表()
{
    _无效的标题内容列表:= [""
        , "开始"
        , "音速启动"
        , "RocketDock"]
    return _无效的标题内容列表
}

; ----------------------------------------------------------
; 获取有效的窗口类_过滤列表()
; ----------------------------------------------------------
获取有效的窗口类_过滤列表()
{
    _有效的窗口类列表:= ["EVERYTHING"
        , "CabinetWClass"
        , "EmEditorMainFrame3"
        , "GomPlayer1.x"]
    return _有效的窗口类列表
}

; ----------------------------------------------------------
; 过滤有效窗口(检查窗口标题, 窗口类)  用于多窗口管理的过滤
; ----------------------------------------------------------
过滤有效窗口(窗口标题, 窗口类)
{
    无效的标题内容:= 获取无效的窗口标题_过滤列表()
    有效的窗口类:= 获取有效的窗口类_过滤列表()
    Loop % 有效的窗口类.MaxIndex()
    {
        if(窗口类=有效的窗口类[A_Index])
        {
            ;过滤掉无效标题, 因为有些窗口标题为空
            Loop % 无效的标题内容.MaxIndex()
            {
               if(窗口标题=无效的标题内容[A_Index])
               {
                   return false
               }
            }
            return true
        }
    }
    return false
}

; ----------------------------------------------------------
; 排序有效窗口(ByRef _窗口id列表, ByRef _窗口标题列表, ByRef _窗口类列表)
; 说明: 根据有效窗口类列表顺序排序
; ----------------------------------------------------------
排序有效窗口(ByRef _窗口id列表, ByRef _窗口标题列表, ByRef _窗口类列表)
{
    有效的窗口类:= 获取有效的窗口类_过滤列表()
    _整理后的窗口id列表:= []
    _整理后的窗口标题列表:= []
    _整理后的窗口类列表:= []
    Loop % 有效的窗口类.MaxIndex()
    {
        _i:= A_Index
        Loop % _窗口类列表.MaxIndex()
            if(_窗口类列表[A_Index]=有效的窗口类[_i])
            {
                _整理后的窗口id列表.insert(_窗口id列表[A_Index])
                _整理后的窗口标题列表.insert(_窗口标题列表[A_Index])
                _整理后的窗口类列表.insert(_窗口类列表[A_Index])
            }
    }
    _窗口id列表:= _整理后的窗口id列表
    _窗口标题列表:= _整理后的窗口标题列表
    _窗口类列:= _整理后的窗口类列表
}

; ----------------------------------------------------------
; MouseIsOver(_WinTitle)
; ----------------------------------------------------------
MouseIsOver(_WinTitle) {
    MouseGetPos,,, Win
    return WinExist(_WinTitle . " ahk_id " . Win)
}


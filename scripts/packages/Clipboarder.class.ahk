; ==========================================================
; 剪贴板管理
;
; 作者: 烈焰
;
; 2016-05-10 17:32:45
; ==========================================================

; ----------------------------------------------------------
; 剪贴板类
; ----------------------------------------------------------
class Clipboarder{
    static list         := []           ;剪贴板数组代替全局变量
    static backupList   := []           ;剪贴板备份, 用于剪贴板临时输出
    static 结束标志      := "###EOF###"
    static undoList     := []           ;剪贴板undo数组代替全局变量
                                        ;记录操作数据, 以便undo恢复
                                        ;undoList := [{"type": "操作类型", "data": [源文件的路径, 改名后的路径]}, .....]

    ; ----------------------------------------------------------
    ; [ 修改list数组 ] : 需要最后进行save保存到文件
    ; ----------------------------------------------------------
    ; static 取数组项目, 或赋值
    item(_index, _value:=""){
        if(_value != ""){
            ; set
            Clipboarder.list[_index] := _value
            Clipboarder.save()
        }
        ; get
        if(_index>0 and _index<=Clipboarder.list.MaxIndex())
            return Clipboarder.list[_index]
        else{
            show_msg("超出Clipboarder.list数组index范围!")
            return ""
        }

    }

    ; public static 在list指定索引插入内容
    insert(_ItemPos, _value)
    {
        list_insert(Clipboarder.list, _ItemPos, _value)
        Clipboarder.save()
    }

    ; public static 删除剪贴板list指定索引内容
    remove(_ItemPos)
    {
        _return := list_remove(Clipboarder.list, _ItemPos)
        Clipboarder.save()
        return _return
    }

    ; public static 清空剪贴板list内容
    clear()
    {
        list_clear(Clipboarder.list)
        Clipboarder.save()
    }

    ; public static 反转list数组内容
    reverse()
    {
        list_reverse(Clipboarder.list)
        Clipboarder.save()
    }

    ; static push() 向剪贴板数组加入新项目, 新添加内容排序在最后;
    push(_newItem){
        list_push(Clipboarder.list, _newItem)
        Clipboarder.save()
    }

    ; static pop() 从剪贴板数组, 弹出最后一项;
    pop(){
        _return := ""
        if(Clipboarder.list.MaxIndex() > 0)
            _return:= list_pop(Clipboarder.list)
        else
        {
            show_msg("剪贴板数组为空! 无法pop数据")
        }
        Clipboarder.save()
        return _return
    }

    ; public static reLoad: 重新加载Clipboarder数组内容
    reLoad()
    {
        Clipboarder.listReadFile()
    }

    ; public static save: 刷新Clipboarder数组内容
    save()
    {
        Clipboarder.listWriteFile()
    }

    ; static listReadFile() 从文件中读取list数组内容
    listReadFile(){
        _content := ""
        _outlist := []
        _endFlag := Clipboarder.结束标志
        _filePath := Config.upath("clipboardFile")
        ; 按行读取文件内容, 进行处理
        Loop, read, % _filePath
        {
            ;检查是否间隔标记行
            if(A_LoopReadLine == _endFlag)
            {
                if( _content == "")
                {
                    ;_content没有内容则无操作
                }
                else
                {
                    ; _content有存内容, 则追加到outlist数组
                    ; 删去末尾多余的"`n"
                    _outlist.push(SubStr(_content, 1, -StrLen("`n")))
                    ;清空_content
                    _content := ""
                }
            }
            else
            {
                _content .= A_LoopReadLine . "`n"
            }
        }
        Clipboarder.list := _outlist
    }

    ; static listWriteFile() list数组内容写入文件
    listWriteFile(){
        _content := ""
        _outlist := []
        _endFlag := Clipboarder.结束标志
        _filePath := Config.upath("clipboardFile")
        try
        {
            _fileObj := FileOpen(_filePath, "w", Config.items["fileEncoding"])
            ; 将数组list写入文件
            For index, value in Clipboarder.list
            {
                _fileObj.WriteLine(value)
                _fileObj.WriteLine(_endFlag)
            }
        }
        catch e
        {
            MsgBox, "Clipboarder.class.ahk" listWriteFile函数写入文件时发生错误: %e%
        }
        finally
        {
            ; 关闭文件
            _fileObj.Close()
        }
    }

    ; ----------------------------------------------------------
    ; [ 读list数组 ]
    ; ----------------------------------------------------------
    ; static 数组长度
    length(){
        Clipboarder.reload()
        return Clipboarder.list.MaxIndex()
    }

    ; ----------------------------------------------------------
    ; [ 剪贴板处理 ]
    ; ----------------------------------------------------------
    ; static 备份剪贴板
    backup(){
        ;备份剪贴板的内容, 到backupList数组
        list_push(Clipboarder.backupList, Clipboard)
    }

    ; static 恢复剪贴板内容
    restore(){
        ;恢复剪贴板的文字内容, 到clipboard
        clipboard := list_pop(Clipboarder.backupList)
    }

    ; static toStr()   打印剪贴板数组内容
    toStr(){
        return list_to_str(Clipboarder.list) . "`n`n剪贴板备份列表:`n" . list_to_str(Clipboarder.backupList)
    }

    ; ----------------------------------------------------------
    ; debug 替代默认ctrl + c, ctrl + x, ctrl + v
    ; ----------------------------------------------------------
    ctrl_c(){

    }

    ctrl_x(){

    }

    ctrl_v(){

    }
    ; ----------------------------------------------------------
    ; static copyToClipboard()
    copyToClipboard(){
        clipboard := ""
        send, ^c
        ClipWait, 0.3
        if ErrorLevel
        {
            show_msg("copy text onto the clipboard failed.")
            return
        }
    }

    ; static cutToClipboard()
    cutToClipboard(){
        clipboard := ""
        send, ^x
        ClipWait, 0.3
        if ErrorLevel
        {
            show_msg("cut text onto the clipboard failed.")
            return
        }
    }

    ; static paste(_out) 粘贴,无参数直接输出粘贴板内容
    paste(_out:=""){
        if(_out != ""){
            clipboard := _out
            sleep 100
        }
        send, ^v
        sleep 100
    }

    ; static [函数]get() 从剪贴板获取值
    ; _type: 默认直接读取剪贴板, 可选拷贝copy或剪切cut方式获取
    ; 目的: 为了减少剪贴板单独占用时间
    get(_type:=""){
        _clip := ""
        if(_type == "copy"){
            Clipboarder.backup()
            Clipboarder.copyToClipboard()
            _clip := clipboard
            Clipboarder.restore()
        }
        else if(_type == "cut"){
            Clipboarder.backup()
            Clipboarder.cutToClipboard()
            _clip := clipboard
            Clipboarder.restore()
        }
        else{
            _clip := clipboard
        }
        return _clip
    }

    ; static 输出: 以粘贴的方式输出字符串
    write(_out){
        Clipboarder.backup()
        Clipboarder.paste(_out)
        Clipboarder.restore()
    }

    ; static 包裹选中的字符串, 用剪贴获取, 然后包裹用粘贴输出
    wrap(_wrapStart:= """", _wrapEnd:=""""){
        result:= Clipboarder.get("cut")
        result:= strWrap(result, _wrapStart, _wrapEnd)
        Clipboarder.write(result)
    }

    ; static 清洗剪贴板数组
    clean(){
        if(Clipboarder.length() > 0){
            Loop % Clipboarder.length(){
                Clipboarder.list[A_Index]:= strClean(Clipboarder.list[A_Index])
            }
            Clipboarder.save()
            show_msg("剪贴板数组清洗完成!")
        }
        else
            show_msg("剪贴板数组为空, 无法进行字符串清洗操作!")
    }

    ; ----------------------------------------------------------
    ; 剪贴板数组字符串拼接
    ; static join(_in参数:="")
    ; return: 拼接后的字符串
    ; ----------------------------------------------------------
    join(_in参数:=""){
        _result:= ""
        if(Clipboarder.length() > 0){
            _参数:= ""
            if(_in参数 != "")
                _参数:= _in参数
            else if(RegExMatch(Clipboarder.list[1], "\d{2}:\d{2}:\d{2}.\d{3}") > 0 && Clipboarder.length()=2){
                ; 针对视频时间识别的字符串拼接 00:33:37.048
                _参数:= {"连接符":"-","结束符":","}
            }
            else
                _参数:= {"连接符":" "}
            ; 重新以逗号连接字符串
            _result:= list_join(Clipboarder.list, _参数["连接符"]) . _参数["结束符"]
        }
        else
            show_msg("剪贴板数组为空, 无法进行连接字符串操作!")
        return _result
    }
}

; ----------------------------------------------------------
; [快捷操作]复制到剪贴板数组()
; ----------------------------------------------------------
复制到剪贴板数组(_index:=0){
    ; 如果指定已存在的数组序号, 则直接修改指定序号内容
    if(_index > 0 and _index <= Clipboarder.length())
        Clipboarder.item(_index, Clipboarder.get("copy"))
    Else
        Clipboarder.push(Clipboarder.get("copy"))
    ; debug
    show_msg(Clipboarder.toStr(), "剪贴板列表")
}

; ----------------------------------------------------------
; [快捷操作]剪贴板数组_清空_复制()
; ----------------------------------------------------------
剪贴板数组_清空_复制(){
    Clipboarder.clear()
    复制到剪贴板数组()
}

; ----------------------------------------------------------
; [快捷操作]粘贴来自剪贴板数组()
; ----------------------------------------------------------
粘贴来自剪贴板数组(_index:=0){
    if(Clipboarder.length() > 0){
        ; 如果指定已存在的数组序号, 则直接输出指定序号内容
        if(_index > 0 and _index <= Clipboarder.length())
            write(Clipboarder.item(_index))
        Else
            write(Clipboarder.item(Clipboarder.length()))
    }
    else{
        msgbox, 剪贴板数组空!
    }
}

; ----------------------------------------------------------
; [快捷操作]剪贴板数组_拼接_粘贴()
; ----------------------------------------------------------
剪贴板数组_拼接_粘贴(){
    Clipboarder.write(Clipboarder.join())
}

; ----------------------------------------------------------
; [快捷操作]粘贴来自剪贴板数组()
; ----------------------------------------------------------
打开剪贴板菜单(){
    ; ----------------------------------------------------------
    ; 菜单部分 实现剪贴板菜单选择输入
    ; ----------------------------------------------------------
    Loop % Clipboarder.length() {
        Menu, ClipMenu
            , Add
            , % A_Index . ". " . strLimitLen(Clipboarder.list[A_Index], 1, 50, "...") . Format(" - [{1}]字符", StrLen(Clipboarder.list[A_Index]))
            , Lab_ClipMenuSelected
    }
    Menu, ClipMenu, Add, [Shift删除 | Ctrl清洗], Lab_End
    menu, ClipMenu, Disable, [Shift删除 | Ctrl清洗]
    ; 选项设置部分菜单
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, % "&v. 当前剪贴板 : " . strLimitLen(Clipboard, 1, 50, "...") . Format(" - [{1}]字符", StrLen(Clipboarder.get())), Lab_Clipboard
    Menu, ClipMenu, Add, [Shift正则分析 | Ctrl清洗], Lab_End
    menu, ClipMenu, Disable, [Shift正则分析 | Ctrl清洗]
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &x. 清空剪贴板数组和剪贴板, Lab_Clear
    Menu, ClipMenu, Add, &c. 清洗剪贴板数组, Lab_Clean_ClipboarderList
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &r. 反转剪贴板数组, Lab_Reverse
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &j. 拼接剪贴板数组, Lab_Join
    Menu, ClipMenu, Add, &s. 剪贴板分割重组(可包裹元素), Lab_SplitAndJoin
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &e. 加密字符串, Lab_Encrypt
    Menu, ClipMenu, Add, &d. 解密字符串, Lab_Decrypt
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &f. 剪贴板文件名⋙内容⋙剪贴板, Lab_fileContentFromClipboard
    Menu, ClipMenu, Add
    Menu, ClipMenu, Add, &u. 查看剪贴板对象内容, Lab_查看剪贴板对象内容
    Menu, ClipMenu, Add

    ; 显示菜单
    Menu, ClipMenu, Show, %A_CaretX%, %A_CaretY%
    ;<……>此时转入选择的标签运行，结束后返回
    Menu, ClipMenu, DeleteAll
    return          ;菜单结束, 不再往下执行

    ; ==========================================================
    ; 菜单执行部分
    ; ==========================================================
    Lab_ClipMenuSelected:
        If GetKeyState("Shift")         ;[按住 Shift 删除选中条目]
        {
            Clipboarder.remove(A_ThisMenuItemPos)
            Return
        }
        If GetKeyState("Ctrl")          ;[按住 Ctrl 清洗并粘贴]
        {
            ; 最后使用过的排最前面
            ; _clipTemp := Clipboarder.remove(A_ThisMenuItemPos)
            ; Clipboarder.insert(1, _clipTemp)
            ; write(_clipTemp)

            ; 清洗当前剪贴板数组元素
            _clipTemp := strClean(Clipboarder.item(A_ThisMenuItemPos))
            Clipboarder.item(A_ThisMenuItemPos, _clipTemp)
            show_msg(Format("剪贴板数组第{1}项清洗完成!", A_ThisMenuItemPos))
            write(_clipTemp)
            Return
        }
        ;[普通粘贴]
        write(Clipboarder.item(A_ThisMenuItemPos))
    Return

    Lab_Clipboard:
        If GetKeyState("Shift")          ;[按住 Shift 分析选中项目并存入剪贴板数组]
        {
            执行正则表达式分析(Clipboard)
            Return
        }
        If GetKeyState("Ctrl")             ;[按住 Ctrl 自动清洗并粘贴]
        {
            ; 清洗当前剪贴板
            _clipTemp := Clipboard
            _clipTemp := strClean(_clipTemp)
            Clipboard := _clipTemp
            write(_clipTemp)
            show_msg("剪贴板清洗完成!")
            Return
        }
        write(Clipboard)
    return

    Lab_Clear:
        Clipboarder.clear()
        clipboard := ""
        if(Clipboarder.length() > 0)
            show_msg("剪贴板数组清空失败!")
        else
            show_msg("剪贴板数组已清空!")
    return

    Lab_Clean_ClipboarderList:
        Clipboarder.clean()
    return

    Lab_Reverse:
        Clipboarder.reverse()
        show_msg("剪贴板数组已反转!")
    return

    Lab_Join:
        if(Clipboarder.length() > 0){
            _参数:= {"包裹开始":"", "包裹结束":"", "连接符":" "}
            _参数str:= JSON.Dump(_参数,, 0)
            if(! 用户修改变量(_参数str, "修改连接参数", _参数str)){
                show_msg("用户取消操作`n")
                return
            }
            _参数:= JSON.Load(_参数str)

            ; 重新以逗号连接字符串
            _clipboard_tmp:= Clipboarder.join(_参数)
            Clipboard:= _clipboard_tmp
            show_msg("拼接字符串存入剪贴板:`n" . _clipboard_tmp)
        }
        else
            show_msg("剪贴板数组为空, 无法进行连接字符串操作!")
    return

    ;剪贴板分割重组(可包裹元素)
    Lab_SplitAndJoin:
        _clipboard_tmp:= clipboard
        if(StrLen(_clipboard_tmp) > 0){
            _clipboard_tmp:= clipboard
            _参数:= {"分割符":",", "包裹开始":"""", "包裹结束":"""", "连接符":", ", "清洗数据":true}
            _参数str:= JSON.Dump(_参数,, 0)
            if(! 用户修改变量(_参数str, "修改分割重组参数", _参数str)){
                show_msg("用户取消操作`n")
                return
            }
            _参数:= JSON.Load(_参数str)

            ; 以逗号分割字符串
            _split_Array:= str_Split(_clipboard_tmp , _参数["分割符"])
            ; 默认以双引号包裹元素
            ; 默认清洗数据
            if(_参数["清洗数据"])
                Loop % _split_Array.Length()
                    _split_Array[A_Index]:= strWrap(strClean(_split_Array[A_Index])
                                                        , _参数["包裹开始"]
                                                        , _参数["包裹结束"])
            else
                Loop % _split_Array.Length()
                    _split_Array[A_Index]:= strWrap(_split_Array[A_Index]
                                                        , _参数["包裹开始"]
                                                        , _参数["包裹结束"])
            ; 重新以逗号连接字符串
            _clipboard_tmp:= list_join(_split_Array, _参数["连接符"])
            Clipboard:= _clipboard_tmp
            show_msg("拼接字符串存入剪贴板:`n" . _clipboard_tmp)
        }
        else
            show_msg("剪贴板为空, 无法分割内容!")
    return

    Lab_Encrypt:
        加密字符串()
    return

    Lab_Decrypt:
        解密字符串()
    return

    Lab_fileContentFromClipboard:
        从剪贴板文件名_获取多文件文本内容_到剪贴板()
    Return

    Lab_查看剪贴板对象内容:
        _剪贴板内容 := "[list] "
                        . "`n; =========================================================="
                        . "`n" . list_to_str(Clipboarder.list)
                        . "`n"
                        . "`n[backupList] "
                        . "`n; =========================================================="
                        . "`n" . list_to_str(Clipboarder.backupList)
                        . "`n`n"
                        . "`n[undoList] "
                        . "`n; =========================================================="
                        . "`n" . list_to_str(Clipboarder.undoList)
                        . "`n`n"
                        . "`n[结束标志] "
                        . "`n; =========================================================="
                        . "`n" . list_to_str(Clipboarder.结束标志)
                        . "`n`n"
        _剪贴板内容 := StrReplace(_剪贴板内容, "`n", "`r`n")
        show_text(_剪贴板内容)
    Return

    Lab_End:
        Gui, Destroy
    return
    ; ==========================================================
}

; 从剪贴板文件名_获取多文件文本内容_到剪贴板
从剪贴板文件名_获取多文件文本内容_到剪贴板(){
    _paths := Clipboard
    _out := ""
    Loop, parse, _paths, `r`n
    {
        _out .= 提取文件文本内容(A_LoopField) . "`n"
    }
    Clipboard := _out
}

; 返回文件文本内容
提取文件文本内容(_path, _encoding:= "utf-8"){
    if FileExist(_path){
        _out := ""
        _f := FileOpen(_path, "r", _encoding)
        _out := _f.Read()
        _f.Close()
        Return _out
    }
    else{
        Return ""
    }
}

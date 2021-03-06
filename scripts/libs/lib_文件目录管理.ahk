﻿; ==========================================================
; ----------------------------------------------------------
; lib_文件目录类
;
; 文档作者: 烈焰
;
; 修改时间: 2016-06-05 03:14:44
; ----------------------------------------------------------
; ==========================================================

; 运行程序(_inPath)
运行程序(_inPath){
    ; 检测路径是否存在
    if FileExist(_inPath)
        run % _inPath
    else
        show_msg("指定的程序路径不存在:`n" . _inPath)
}

打开文件操作菜单(){
    ; ----------------------------------------------------------
    ; 2. 菜单部分 - 单项菜单输入
    ; ----------------------------------------------------------
    ; 加入选项 - 不可修改
    Menu, templateMenu, Add, [文件操作菜单], Lab_打开文件操作菜单_End
    menu, templateMenu, Disable, [文件操作菜单]
    ; 加入横线
    Menu, templateMenu, Add
    ; 加入选项
    Menu, templateMenu, Add, &0. 打开同步文件夹, Lab_打开同步文件夹
    Menu, templateMenu, Add, &1. 备份360收藏夹bookmarks, Lab_备份360收藏夹bookmarks
    Menu, templateMenu, Add
    ; 显示菜单
    Menu, templateMenu, Show, %A_CaretX%, %A_CaretY%
    ;<……>此时转入选择的标签运行，结束后返回
    Menu, templateMenu, DeleteAll
    return          ;菜单结束, 不再往下执行

    ; ----------------------------------------------------------
    ; 单项菜单执行部分
    ; ----------------------------------------------------------
    Lab_打开同步文件夹:
        ;[仅点击选中Item]
        打开窗口("D:\_home_data_\同步备份清单")
    return
    ; ----------------------------------------------------------
    ; 单项菜单执行部分
    ; ----------------------------------------------------------
    Lab_备份360收藏夹bookmarks:
        ;[仅点击选中Item]
        show_msg("备份360收藏夹bookmarks")
        备份文件到多目录_有后缀("C:\Users\Tom\AppData\Local\360Chrome\Chrome\User Data\Default\360UID16303723_V8\Bookmarks"
                        , ["D:\_home_data_\#tom#的文件夹\[ 6-备忘 ]\收藏夹备份"
                            , "F:\_home_data_sync_\#tom#的文件夹_sync\[ 6-备忘 ]\收藏夹备份"]
                        , 3)
    return
    ; ----------------------------------------------------------
    Lab_打开文件操作菜单_End:
        Gui, Destroy
    return
    ; --ends
}

; ----------------------------------------------------------
; 备份文件到多目录
; 备份源文件  := "D:\_home_data_\desktop\Bookmark"
; 备份目录列表:= ["D:\_home_data_\desktop\tmp1", "D:\_home_data_\desktop\tmp2"]
; ----------------------------------------------------------
备份文件到多目录(备份源文件, 备份目录列表){
    ; 检查源文件是否存在
    if(! FileExist(备份源文件)){
        Clipboard := "备份源文件不存在!`n" . 备份源文件
        msgbox % "备份源文件不存在!`n" . 备份源文件
        return
    }
    ; 收集文件名
    ;文件名长度  := InStr(源文件路径, ".", false, 0) - InStr(源文件路径, "\", false, 0) - 1
    文件名      := SubStr(备份源文件, InStr(备份源文件, "\", false, 0)+1)
    ; 验证结果信息
    checkList   := []
    errorList   := []
    result      := true
    ; 开始备份操作
    for _i, 备份目录 in 备份目录列表{
        备份到文件      := 备份目录 . "\" . 文件名
        checkList[_i]   := 备份到文件
        ; 同步备份, 覆盖目的文件
        FileCopy, %备份源文件%, %备份到文件% , true
    }
    ; 检查备份结果文件是否存在
    for _i, _file in checkList{
        if(! FileExist(_file)){
            errorList.push("`n备份文件不存在: " . _file)
            result := false
        }
    }
    ; 记录错误信息到剪贴板
    if(! result){
        strTmp:= ""
        for _i, _error in errorList
            strTmp .= _error
        Clipboard := strTmp
        msgbox, 备份文件不存在, 错误文件信息已拷贝到剪贴板!
    }
    else{
        msgbox, 源文件备份完成!`n%备份源文件%
    }
    ; --end
    return result
}

; ----------------------------------------------------------
; 备份文件到多目录_有后缀
; 备份源文件     := "D:\_home_data_\desktop\Bookmark"
; 备份目录列表   := ["D:\_home_data_\desktop\tmp1", "D:\_home_data_\desktop\tmp2"]
; 限制备份数     :=3 文件顺序按文件名排序;
; ----------------------------------------------------------
备份文件到多目录_有后缀(备份源文件, 备份目录列表, 限制备份数:=3){
    ; 检查源文件是否存在
    if(! FileExist(备份源文件)){
        Clipboard := "备份源文件不存在!`n" . 备份源文件
        msgbox % "备份源文件不存在!`n" . 备份源文件
        return
    }
    ; 收集文件名
    ;文件名长度  := InStr(源文件路径, ".", false, 0) - InStr(源文件路径, "\", false, 0) - 1
    文件名      := SubStr(备份源文件, InStr(备份源文件, "\", false, 0)+1)
    含有扩展名  := InStr(备份源文件, ".")>0
    扩展名      := 含有扩展名 ? SubStr(文件名, InStr(文件名, ".", false, 0)+1) : ""
    文件名长度  := InStr(文件名, ".", false, 0) - 1
    文件名      := 含有扩展名 ? SubStr(文件名, 1, 文件名长度) : 文件名
    FormatTime, 新文件名后缀,, _备份yyyyMMdd_HHmmss
    备份文件名  := 含有扩展名 ? 文件名 . 新文件名后缀 . "." . 扩展名 : 文件名 . 新文件名后缀
    ; 验证结果信息
    checkList   := []
    errorList   := []
    result      := true
    ; 开始备份操作
    for _i, 备份目录 in 备份目录列表{
        备份到文件      := 备份目录 . "\" . 备份文件名
        checkList[_i]   := 备份到文件
        ; 同步备份, 覆盖目的文件
        FileCopy, %备份源文件%, %备份到文件% , true
    }
    ; 限制备份数
    for _i, 备份目录 in 备份目录列表{
        _已备份文件列表 := getFilesFromDir(备份目录, Array(文件名 . "_备份*"))
        if(_已备份文件列表.Length() > 限制备份数){
            _要删除文件数 := _已备份文件列表.Length() - 限制备份数
            ; 删除前n个备份文件
            Loop % _已备份文件列表.Length(){
                if(A_Index > _要删除文件数)
                    break
                FileDelete, % _已备份文件列表[A_Index]
            }
        }
    }
    ; 检查备份结果文件是否存在
    for _i, _file in checkList{
        if(! FileExist(_file)){
            errorList.push("`n备份文件不存在: " . _file)
            result := false
        }
    }
    ; 记录错误信息到剪贴板
    if(! result){
        strTmp:= ""
        for _i, _error in errorList
            strTmp .= _error
        Clipboard := strTmp
        show_msg("备份文件不存在, 错误文件信息已拷贝到剪贴板!")
    }
    else{
        show_msg("源文件备份完成!`n" . 备份源文件)
    }
    ; --end
    return result
}

; ----------------------------------------------------------
; [操作]批量简化内容 - 自动重命名
; 需要选中图标, 限制在文件夹窗口或桌面才能起作用
; _type="undo", 则恢复修改前的内容, 进行undo操作;
; ----------------------------------------------------------
自动重命名(_type:="id")
{
    ; 获取源文件名
    _newFileName := fileRename(Clipboarder.get("cut"), _type)
    ; 输出新文件名
    send ^a
    sleep 100
    ; 输出新文件名, 直接粘贴输出, 不需要再按f2
    write(_newFileName)
}

; ----------------------------------------------------------
; [操作]批量简化内容 - f2自动重命名
; 需要选中图标, 限制在文件夹窗口或桌面才能起作用
; _type="undo", 则恢复修改前的内容, 进行undo操作;
; ----------------------------------------------------------
f2自动重命名(_type:="id")
{
    ; 获取源文件名
    _newFileName := fileRename(Clipboarder.get("cut"), _type)
    ; 输出新文件名
    send {f2}
    sleep 100
    ; 输出新文件名, 直接粘贴输出, 不需要再按f2
    write(_newFileName)
}

; ----------------------------------------------------------
; [函数]fileRename(_oldFilePath, _type:=1)
; ----------------------------------------------------------
fileRename(_oldFilePath, _type:="clip")
{
    ; 输出结果
    _newFileName        := ""
    ; 备份剪贴板原内容
    ; 对剪贴板中存储的文件路径, 只提取不带扩展名的文件名, 另外也用于后面的文件名对比;
    _path_backup   := Path.parse(clipboard)
    ; 准备数据, 分解数据
    _path               := Path.parse(_oldFilePath)
    _filePath           := _path.path
    _fileName           := _path.fileNoExt
    _extFileName        := _path.ext

    ; ----------------------------------------------------------
    ; 备份原文件名, 通过剪贴板管理恢复历史记录
    ; _type=0 "undo"为恢复操作, 只有非恢复操作才有必要备份
    ; ----------------------------------------------------------
    if(_type != "undo")
        if(_extFileName != "")
            Clipboarder.push(_fileName . "." . _extFileName)
        else
            Clipboarder.push(_fileName)
    ; ----------------------------------------------------------
    ; 根据type类型, 制作新的文件名, 不含扩展名
    ; ----------------------------------------------------------
    if(_type == "undo")
    {
        ; undo操作, 恢复修改前的内容;
        if(_extFileName == "")
            _newFileName := Path.parse(Clipboarder.pop()).fileNoExt
        else{
            _newFileName := Path.parse(Clipboarder.pop()).fileNoExt . "." . _extFileName
        }
    }
    else if(_type == "av")
    {
        ; 如果当前文件名与剪贴板相同, 则进行特殊分析
        ; 分析是否是av作品名, 并进行相关格式化
        _newFileName := Av.rename(_fileName)
    }
    else if(_type == "clip"){                               ;使用剪贴板内容作为新文件名;
            _newFileName := _path_backup.fileNoExt
    }
    else if(_type == "id"){                                 ;使用id文件名
        _newFileName := strId()
    }
    else if(_type == "img_id"){                            ;[图片类] 尺寸 + id 进行特殊命名
        ;[图片类]按尺寸进行特殊命名, 仅支持 GIF JPG BMP, 不区分大小写
        if(_extFileName="jpg" or _extFileName="gif" or _extFileName="bmp"){
            _imgInfo := getImageSize(_filePath)
            _newFileName := "(" . 根据图片尺寸划分大小等级(_imgInfo.w, _imgInfo.h) . ")" . strId() . "_" . _imgInfo.w . "×" . _imgInfo.h
        }
        else{
            _newFileName:= strId()
        }
    }
    else if(_type == "img"){                                ;[图片类] 尺寸 + 源文件名 进行特殊命名, 包含旧的文件名;
        ;[图片类]按尺寸进行特殊命名, 仅支持 GIF JPG BMP
        ;[图片类] 尺寸 + 源文件名 进行特殊命名, 包含旧的文件名;
        if(_extFileName="jpg" or _extFileName="gif" or _extFileName="bmp"){
            _imgInfo:=getImageSize(_filePath)
            _newFileName:= "(" . 根据图片尺寸划分大小等级(_imgInfo.w, _imgInfo.h) . ")" . _filename . "_" . _imgInfo.w . "×" . _imgInfo.h
        }
        else{
            _newFileName:= _fileName . "_" . strId()
        }
    }
    else{
        show_msg("重命名类型指定错误, 无法进行操作!")
        _newFileName:= _fileName
    }
    ; ----------------------------------------------------------
    ; 检查并补充新文件名的扩展名, 非undo操作
    ; ----------------------------------------------------------
    ; if(_type != "undo" && _extFileName != "")
    ;     _newFileName:= _newFileName . "." . _extFileName
    ; 输出新文件名
    return _newFileName
}

; ----------------------------------------------------------
; [操作]showFileHash(_type:="md5")
; 显示对比文件的md5或hash值, 参数=""则两种值都计算
; ----------------------------------------------------------
showFileHash(_type:="md5")
{
    _filePathList := getSelectedObjFullPathList()
    Loop % _filePathList.MaxIndex()
    {
        _filePath := _filePathList[A_Index]
        if(_type == "md5"){
            show_msg("[文件]`n" . _filePath . "`n`n计算MD5中, 请等待......")
            _md5_result := Crypt.Hash.FileHash(_filePath)
            StringUpper, _md5_result, _md5_result   ;把结果转换为大写字母
            ;这里只显示md5中的6个字符
            _filePathList[A_Index] := "[MD5:***" . SubStr(_md5_result,-5,6) . "] " . get_fileName(_filePath)
        }
        else if(_type == "hash"){
            show_msg("[文件]`n" . _filePath . "`n`n计算SHA1中, 请等待......")
            _sha1_result := Crypt.Hash.FileHash(_filePath,3)
            StringUpper, _sha1_result, _sha1_result ;把结果转换为大写字母
            ;这里只显示md5中的6个字符
            _filePathList[A_Index] := "[SHA1:***" . SubStr(_sha1_result,-5,6) . "] " . get_fileName(_filePath)
        }
        else{
            ; 计算md5
            show_msg("[文件]`n" . _filePath . "`n`n计算MD5中, 请等待......")
            _md5_result := Crypt.Hash.FileHash(_filePath)
            StringUpper, _md5_result, _md5_result   ;把结果转换为大写字母
            ; 计算sha1
            show_msg("[文件]`n" . _filePath . "`n`n计算SHA1中, 请等待......")
            _sha1_result := Crypt.Hash.FileHash(_filePath,3)
            StringUpper, _sha1_result, _sha1_result ;把结果转换为大写字母
            ;这里只显示md5和sha1中的6个字符
            _filePathList[A_Index] := "[MD5:***" . SubStr(_md5_result,-5,6) . "] " . " [SHA1:***" . SubStr(_sha1_result,-5,6) . "] " . get_fileName(_filePath)
        }
    }
    _result := arrayToStr(_filePathList)
    ClipBoarder.push(_result)
    show_text(_result . "`n`n计算结果已存入剪贴板`n", "FileHash", 600, 400)
}

; ----------------------------------------------------------
; 收集指定目录中所有匹配文件_逆操作
; 还原依据:
;   1. 原文件结构备份.txt;
;   2. 前提是图片名没有改变
; ----------------------------------------------------------
收集指定目录中所有匹配文件_逆操作(_FullFileName)
{
    ;--- 确认当前_dir中是目录, 否则取文件的当前所在目录路径
    _dir:= getDirPath(_fullFileName)

    ;让使用者确认是否进行操作
    if(操作确认("操作确认", "你确定要收集指定目录中所有匹配文件_逆操作吗?")=false)
        return

    _结果存放目录:= _dir
    _原文件结构备份:= _结果存放目录 . "\原文件结构备份.txt"

    ;---开始对列表中的所有文件进行处理
    _counter:= 0
    _error_counter:=0
    Loop, read, % _原文件结构备份
    {
        Loop, parse, A_LoopReadLine, %A_Tab%
        {
            ;SplitPath, A_LoopField, _fileName
            ;_filePath:= _结果存放目录 . "\" . _fileName

            _filepath_pair := StrSplit(A_LoopField, ";", A_Space)
            if(_filepath_pair.MaxIndex()=2)
            {
                恢复文件(_filepath_pair[2], _filepath_pair[1])
                _counter++
            }
            else
                _error_counter++
            show_msg("已还原文件: " . _counter . "`n`n " . "错误记录: " . _error_counter . "`n`n " . A_LoopField)
        }
    }
    show_msg("已还原文件: " . _counter . "`n`n " . "错误记录: " . _error_counter . "`n`n 还原文件操作完成!")
}

; ----------------------------------------------------------
; [文件类] 恢复文件
;
; _filePath: 文件现在的路径
; _oldFilePath: 文件要恢复过去的路径
; ----------------------------------------------------------
恢复文件(_filePath, _oldFilePath)
{
    SplitPath, _oldFilePath, , _dir
    _dir := RegExReplace(_dir, "\\$")  ;移除可能出现在末尾的反斜线.
    _dir := _dir . "\"
    IfNotExist, % _dir
        FileCreateDir, % _dir
    FileCopy, % _filePath, % _oldFilePath, 1
}

; ----------------------------------------------------------
; [图片类] 收集当前目录中所有匹配文件(含子目录)
; ----------------------------------------------------------
收集当前目录中所有匹配文件(_filePatterns)
{
    ;通过点选目录或当前目录中的图片文件--进行获取目录路径
    _fullFileName := Clipboarder.get("copy")
    收集指定目录中所有匹配文件(_fullFileName, _filePatterns)
}

; ----------------------------------------------------------
; [图片类] 收集指定目录中所有匹配文件(含子目录)
; ----------------------------------------------------------
收集指定目录中所有匹配文件(_FullFileName, _filePatterns)
{
;---第一, 获取当前目录路径;
    ;确认当前_dir中是目录, 否则取文件的当前所在目录路径
    _dir:= getDirPath(_fullFileName)

    ;让使用者确认是否进行操作
    if(操作确认("操作确认", "你确定要收集指定目录中所有匹配文件吗?")=false)
        return

    _集中存放目录:= _dir . "\#结果存放目录#"    ;设置存放的根目录

;---第二, 获取目录中(含子目录)所有匹配文件的路径列表
    _filesLongPathList:= getFilesFromDir(_dir, _filePatterns, "R")

    if(_filesLongPathList.MaxIndex()>0)
        FileCreateDir, % _集中存放目录

    ;---开始对列表中的所有文件进行处理
    _counter:= 0
    ;---开始创建操作日志
    _file:=  FileOpen(_集中存放目录 . "\原文件结构备份.txt", "w", Config.items["fileEncoding"])
    ;---记录日志每行的内容
    _log_writeLine:= ""
    Loop % _filesLongPathList.MaxIndex()
    {
        _filePath:= _filesLongPathList[A_Index]
        ;获取文件名
        SplitPath, _filePath, _fileName
        _newFilePath:= _集中存放目录 . "\" . _fileName
        FileCopy, % _filePath, % _newFilePath, 1

        ;---为恢复做记录
        _log_writeLine:= _filePath . ";" . _newFilePath
        _file.WriteLine(_log_writeLine)
        _counter++

        ;---操作进程提示
        show_msg("文件总数: " . _filesLongPathList.MaxIndex() . "`n已处理文件: " . _counter . "`n`n " . _filePath)
    }
    ;---操作进程提示
    show_msg("文件总数: " . _filesLongPathList.MaxIndex() . "`n已处理文件: " . _counter . "`n`n 文件整理操作完成!")
}

; ----------------------------------------------------------
; [图片类] 将当前目录中图片按尺寸重命名并分类存放
; ----------------------------------------------------------
将当前目录中图片按尺寸重命名并分类存放()
{
    ;通过点选目录或当前目录中的图片文件--进行获取目录路径
    _fullFileName := Clipboarder.get("copy")
    将指定目录中图片按尺寸重命名并分类存放(_fullFileName)
}

; ----------------------------------------------------------
; [图片类] 将指定目录中图片按尺寸重命名并分类存放
;
; 按图片尺寸进行分类整理存放,并在文件名前面进行标注,保持原文件名内容;
; 并按文件大小分类存到对应类别的文件夹中;
; ----------------------------------------------------------
将指定目录中图片按尺寸重命名并分类存放(_fullFileName)
{
;---第一, 获取当前目录路径;
    ;确认当前_dir中是目录, 否则取文件的当前所在目录路径
    _dir:= getDirPath(_fullFileName)

    ;让使用者确认是否进行图片分类整理
    if(操作确认("操作确认"
        ,"你确定要将指定目录中图片按尺寸重命名并分类存放吗?")=false)
        return

    _集中存放目录:= _dir    ;设置存放的根目录

;---第二, 获取目录中文件列表, 并过滤全部图片文件, 仅限jpg,gif,bmp
    ;为当前目录预先建立匹配的文件列表, 不递归子文件夹
    _filesList:= getFilesNameFromDir(_dir, ["*.jpg", "*.jpeg", "*.gif", "*.bmp"])

    ;---开始对列表中的所有文件进行处理
    _counter:= 0
    ;---开始创建操作日志
    _file:=  FileOpen(_集中存放目录 . "\原文件结构备份.txt", "w", Config.items["fileEncoding"])
    ;---记录日志每行的内容
    _log_writeLine:= ""
    Loop % _filesList.MaxIndex()
    {

;---第三, 开始按一定顺序检测处理每一个图片文件, 为其创建相应的分类目录,并将其移动到该目录中;
        ;FileMove, %A_LoopField%, renamed_%A_LoopField%
        _imgFileName:= _filesList[A_Index]
        _imgFilePath:= _dir . "\" . _imgFileName
        _imgInfo:= getImageSize(_imgFilePath)

        图片大小等级:= 根据图片尺寸划分大小等级(_imgInfo.w, _imgInfo.h)
        图片大小等级目录:= _dir . "\" . 图片大小等级
        ;为图片大小等级建立相应目录
        IfNotExist, %图片大小等级目录%
            FileCreateDir, %图片大小等级目录%

        _newImgFilePath:= 图片大小等级目录 . "\[" . 图片大小等级 . "]" . strId() . "_" . _imgInfo.w . "×" . _imgInfo.h . "." . get_extName(_imgFileName)
        FileMove, % _imgFilePath, % _newImgFilePath

        ;---为恢复做记录
        _log_writeLine:= _imgFilePath . ";" . _newImgFilePath
        _file.WriteLine(_log_writeLine)
        _counter++

        ;---操作进程提示
        show_msg("文件总数: " . _filesList.MaxIndex() . "`n已处理文件: " . _counter . "`n`n " . _imgFilePath)
    }
    ;---操作进程提示
    show_msg("文件总数: " . _filesList.MaxIndex() . "`n已处理文件: " . _counter . "`n`n 文件整理操作完成!")
}

; ----------------------------------------------------------
; [图片类]辅助工具 - 根据图片尺寸划分大小等级
; ----------------------------------------------------------
根据图片尺寸划分大小等级(_inWidth, _inHeight)
{
    _总像素:= _inWidth*_inHeight
    if(_总像素<200000)
    {
        return "迷你小图"
    }
    else if(_总像素<500000)
    {
        return "小图"
    }
    else if(_总像素<800000)
    {
        return "中图"
    }
    else if(_总像素<2000000)
    {
        return "大图"
    }
    else
    {
        return "高品质大图"
    }
}

; ----------------------------------------------------------
; 2013年02月22日 获取图片文件尺寸, 仅支持 GIF JPG BMP
; ----------------------------------------------------------
getImageSize(_ImageFile)
{
    ;仅支持 GIF JPG BMP
    Gui, 99:Add, Picture, Hidden, % _ImageFile
    Gui, 99:Cancel
    Gui, 99:+LastFound
    ControlGetPos , , , _width, _height, Static1
    Gui, 99:Destroy
    return {"w":_width, "h":_height}
}

; ----------------------------------------------------------
; 获取当前选中多个对象列表(文件或文件夹)的绝对完整路径
; ----------------------------------------------------------
getSelectedObjFullPathList(){
    _filePathList := []
    _clips := Clipboarder.get("copy")
    ; 这句还是废话一下：windows 复制的时候，剪贴板保存的是“路径”。只要转换成字符串就可以粘贴出来了。
    Loop, parse, _clips, `n, `r
    {
        arrayAppend(_filePathList, A_LoopField)
    }
    return _filePathList
}

; ----------------------------------------------------------
; [函数库] getSubDirs
; 获取目录中所有匹配的目录的完整路径列表
;
; 参数:
;   _dir 指定目录末尾无"\";
;   _filePatterns= ["*真木今日子*","*白石茉莉奈*"] 支持星号和问号作为通配符使用;
;   _includeChildFolders R(递归所有子目录)
;
; 返回:
;   _dirPathList[]
getSubDirs(_dir, _filePatterns, _includeChildFolders:=""){
    _dirPathList:= []
    _counter:= 0
    for index, _filePattern in _filePatterns
        Loop, Files, % _dir . "\" . _filePattern, % "D" . _includeChildFolders
        {
            _counter++
            _dirPathList[_counter]:= A_LoopFileLongPath
        }
    return _dirPathList
}

; ----------------------------------------------------------
; [函数库] getFilesFromDir
; 获取目录中所有匹配的文件的完整路径列表
;
; 参数:
;   _dir 指定目录末尾无"\";
;   _filePatterns= ["*.jpg","*.gif"] 支持星号和问号作为通配符使用;
;   _includeChildFolders R(递归所有子目录)
;
; 返回:
;   _filesPathList[]
getFilesFromDir(_dir, _filePatterns, _includeChildFolders:=""){
    _filesPathList:= []
    _counter:= 0
    for index, _filePattern in _filePatterns
        Loop, Files, % _dir . "\" . _filePattern, % "F" . _includeChildFolders
        {
            _counter++
            _filesPathList[_counter]:= A_LoopFileLongPath
        }
    return _filesPathList
}

; ----------------------------------------------------------
; [函数库] getFilesNameFromDir
; 获取目录中所有匹配的文件名(含扩展名)/目录名列表
; 注意: 只是文件名并非完整路径;
;
; 参数:
;   _dir 指定目录末尾无"\";
;   _filePatterns= ["*.jpg","*.gif"] 支持星号和问号作为通配符使用;
;   _includeChildFolders R(递归所有子目录)
;
; 返回:
;   _filesNameList[]
getFilesNameFromDir(_dir, _filePatterns, _includeChildFolders:=""){
    _filesNameList:= []
    _counter:= 0
    for index, _filePattern in _filePatterns
        Loop, Files, % _dir . "\" . _filePattern, % "F" . _includeChildFolders
        {
            _counter++
            _filesNameList[_counter]:= A_LoopFileName
        }
    return _filesNameList
}



;获取字符串中的文件名, "file1.txt"
;========================================================
get_fileName(_FullFileName){
    SplitPath, _FullFileName, _name, _dir, _ext, _name_no_ext, _drive
    return _name
}

;获取字符串中的文件名不含扩展名, "file1"
;========================================================
get_fileNameNoExt(_FullFileName){
    SplitPath, _FullFileName, _name, _dir, _ext, _name_no_ext, _drive
    return _name_no_ext
}

; ----------------------------------------------------------
; 从指定文件路径中获取目录路径, "c:\windows"
; ----------------------------------------------------------
getDirPath(_FullFileName)
{
    ; 如果_FullFileName本身就是目录, 则直接返回_FullFileName
    if InStr(FileExist(_FullFileName), "D")
        return _FullFileName
    SplitPath, _FullFileName, _name, _dir, _ext, _name_no_ext, _drive
    return _dir
}

;获取字符串中的文件扩展名, "txt"
;========================================================
get_extName(_FullFileName){
    SplitPath, _FullFileName, _name, _dir, _ext, _name_no_ext, _drive
    return _ext
}

;获取字符串中的文件扩展名, "c:"
;========================================================
get_drive(_FullFileName){
    SplitPath, _FullFileName, _name, _dir, _ext, _name_no_ext, _drive
    return _drive
}

; [函数--获取ini指定片段中的内容]
; GetIniFileSection
; 返回指定_sectionTitle 区域中的全部文本
;========================================================
GetIniFileSection(_iniFilePath, _sectionTitle){
    ; 查找结果
    _foundSectionTitle  := false
    _resultContent      := ""
    Loop, read, % _iniFilePath
    {
        ;检查是否标题行
        if(substr(A_LoopReadLine,1,1) == "[")
        {
            ; 如果已找到区域标题, 则下一个标题为结束标志
            if(_foundSectionTitle)
                break
            if(A_LoopReadLine == "[" . _sectionTitle . "]")
            {
                ;检查标题行内容
                 _foundSectionTitle := true ;设置找到标记,从下一行开始读内容
                 ;msgbox % A_LoopReadLine
            }
        }
        else
        {
            if(_foundSectionTitle)
            {
                _resultContent .= A_LoopReadLine . "`n"
            }
        }
    }
    return _resultContent
}

; [函数--获取ini所有片段的标题]
; 返回数组: 所有SectionsTitle列表
;========================================================
GetIniFileALLSectionsTitle(_iniFilePath){
    _resultList := []
    Loop, read, % _iniFilePath
    {
        ;检查是否标题行
        if(substr(A_LoopReadLine,1,1)="[")
        {
            _resultList.push(substr(A_LoopReadLine, 2, StrLen(A_LoopReadLine)-2))
        }
    }
    return _resultList
}


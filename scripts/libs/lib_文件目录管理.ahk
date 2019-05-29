; ==========================================================
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

; ----------------------------------------------------------
; [操作]批量简化内容 - 自动重命名
; 需要选中图标, 限制在文件夹窗口或桌面才能起作用
; _type=0, 则恢复修改前的内容, 进行undo操作;
; ----------------------------------------------------------
自动重命名(_type:=1)
{
    _newFileName := fileRename(Clipboarder.get("copy"), _type)
    ;--- 输出新文件名
    send {f2}
    sleep 100
    send ^a
    sleep 100
    write(_newFileName)
    sleep 100
    send {enter}
}

; ----------------------------------------------------------
; [操作]批量简化内容 - f2自动重命名
; 需要选中图标, 限制在文件夹窗口或桌面才能起作用
; _type=0, 则恢复修改前的内容, 进行undo操作;
; ----------------------------------------------------------
f2自动重命名(_type:=1)
{
    ;--- 获取源文件名
    send {f2}
    sleep 100
    send ^a
    sleep 100
    _newFileName := fileRename(Clipboarder.get("cut"), _type)
    ;--- 输出新文件名, 直接粘贴输出, 不需要再按f2
    write(_newFileName)
    sleep 100
    send {enter}
}

; ----------------------------------------------------------
; [函数]fileRename(_oldFilePath, _type:=1)
; ----------------------------------------------------------
fileRename(_oldFilePath, _type:=1)
{
    ; 输出结果
    _newFileName        := ""
    ; 备份剪贴板原内容
    ; 对剪贴板中存储的文件路径, 只提取不带扩展名的文件名, 另外也用于后面的文件名对比;
    _clipboard_backup   := Path.split(clipboard)
    ; 准备数据, 分解数据
    _path               := Path.split(_oldFilePath)
    _filePath           := _path.path
    _fileName           := _path.fileNoExt
    _extFileName        := _path.ext

    ; ----------------------------------------------------------
    ; 备份原文件名, 通过剪贴板管理恢复历史记录
    ; _type=0 为恢复操作, 只有非恢复操作才有必要备份
    ; ----------------------------------------------------------
    if(_type > 0)
        if(_extFileName != "")
            Clipboarder.push(_fileName . "." . _extFileName)
        else
            Clipboarder.push(_fileName)
    ; ----------------------------------------------------------
    ; 根据type类型, 制作新的文件名, 不含扩展名
    ; ----------------------------------------------------------
    if(_type == 0)
    {
        ; undo操作, 恢复修改前的内容;
        if(_extFileName == "")
            _newFileName := Path.split(Clipboarder.pop()).fileNoExt
        else{
            _newFileName := Path.split(Clipboarder.pop()).fileNoExt . "." . _extFileName
        }
    }
    else if(_fileName == _clipboard_backup.fileNoExt)
    {
        ; 如果当前文件名与剪贴板相同, 则进行特殊分析
        ; 分析是否是av作品名, 并进行相关格式化
        _newFileName := Av.rename(_fileName)
    }
    else if(_type == 1){         ;使用剪贴板内容作为新文件名;
            _newFileName := _clipboard_backup.fileNoExt
    }
    else if(_type == 2){         ;使用id文件名
        _newFileName := strId()
    }
    else if(_type == 3){        ;[图片类]按尺寸进行特殊命名
        ;[图片类]按尺寸进行特殊命名, 仅支持 GIF JPG BMP, 不区分大小写
        if(_extFileName="jpg" or _extFileName="gif" or _extFileName="bmp"){
            _imgInfo := getImageSize(_filePath)
            _newFileName := "(" . 根据图片尺寸划分大小等级(_imgInfo.w, _imgInfo.h) . ")" . strId() . "_" . _imgInfo.w . "×" . _imgInfo.h
        }
        else{
            _newFileName:= strId()
        }
    }
    else if(_type == 4){        ;包含旧的文件名, [图片类]按尺寸进行特殊命名
        ;[图片类]按尺寸进行特殊命名, 仅支持 GIF JPG BMP
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
    ; 检查并补充新文件名的扩展名
    ; ----------------------------------------------------------
    if(_type > 0 && _extFileName != "")
        _newFileName:= _newFileName . "." . _extFileName
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
收集当前目录中所有匹配文件(_filePatterns*)
{
    ;通过点选目录或当前目录中的图片文件--进行获取目录路径
    _fullFileName := Clipboarder.get("copy")
    收集指定目录中所有匹配文件(_fullFileName, _filePatterns*)
}

; ----------------------------------------------------------
; [图片类] 收集指定目录中所有匹配文件(含子目录)
; ----------------------------------------------------------
收集指定目录中所有匹配文件(_FullFileName , _filePatterns*)
{
;---第一, 获取当前目录路径;
    ;确认当前_dir中是目录, 否则取文件的当前所在目录路径
    _dir:= getDirPath(_fullFileName)

    ;让使用者确认是否进行操作
    if(操作确认("操作确认", "你确定要收集指定目录中所有匹配文件吗?")=false)
        return

    _集中存放目录:= _dir . "\@结果存放目录@"    ;设置存放的根目录

;---第二, 获取目录中(含子目录)所有匹配文件的路径列表
    _filesLongPathList:= getFilesLongPathList(_dir, 0, 1, _filePatterns*)

    if(_filesLongPathList.MaxIndex()>0)
        FileCreateDir, % _集中存放目录

    ;---开始对列表中的所有文件进行处理
    _counter:= 0
    ;---开始创建操作日志
    _file:=  FileOpen(_集中存放目录 . "\原文件结构备份.txt", 1)
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
    _filesList:= getFilesNameList(_dir, 0, 0, "*.jpg", "*.jpeg", "*.gif", "*.bmp")

    ;---开始对列表中的所有文件进行处理
    _counter:= 0
    ;---开始创建操作日志
    _file:=  FileOpen(_集中存放目录 . "\原文件结构备份.txt", 1)
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
; [函数库] getFilesLongPathList
; 获取目录中所有匹配的文件/目录的完整长路径列表
; 注意: 只是文件名并非完整路径;
;
; 参数:
;   _dir 指定目录末尾无"\";
;   _includeFolders 0(仅文件) 1(文件和目录) 2(仅目录)
;   _includeChildFolders 0(不递归子目录) 1(递归所有子目录)
;   _filePatterns 支持星号和问号作为通配符使用,"*.jpg","*.gif"
;
;   输出结果 filesList[]
getFilesLongPathList(_dir, _includeFolders, _includeChildFolders, _filePatterns*){
    _filesLongPathList:= []
    _counter:= 0
    for index, _filePattern in _filePatterns
        Loop % _dir . "\" . _filePattern, % _includeFolders, % _includeChildFolders
        {
            _counter++
            _filesLongPathList[_counter]:= A_LoopFileLongPath
        }
    return _filesLongPathList
}

; ----------------------------------------------------------
; [函数库] getFilesNameList
; 获取目录中所有匹配的文件名(含扩展名)/目录名列表
; 注意: 只是文件名并非完整路径;
;
; 参数:
;   _dir 指定目录末尾无"\";
;   _includeFolders 0(仅文件) 1(文件和目录) 2(仅目录)
;   _includeChildFolders 0(不递归子目录) 1(递归所有子目录)
;   _filePatterns 支持星号和问号作为通配符使用,"*.jpg","*.gif"
;
;   输出结果 filesList[]
getFilesNameList(_dir, _includeFolders, _includeChildFolders, _filePatterns*){
    _filesNameList:= []
    _counter:= 0
    for index, _filePattern in _filePatterns
        Loop % _dir . "\" . _filePattern, % _includeFolders, % _includeChildFolders
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

;[函数--获取ini指定片段中的内容]
;========================================================
GetIniFileSection(_iniFilePath,_sectionTitle){
    ;要查找的文件对象
    _filePath := _iniFilePath
    ;inputbox,fileFullName,输入查找目标文件

    ;查找内容
    _queryStr := _sectionTitle
    ;inputbox,_queryStr,输入查找内容

    _lineIndex := 0 ;[行号]
    ;查找结果
    _resultLineIndex := -1
    _resultCount := 0
    _hasFound := false  ;是否已找到,在找到指定的标题行后,可以开始读其内容
    _resultContent := ""

    Loop, read, % _filePath
    {
        _lineIndex++
        ;检查是否标题行
        if(substr(A_LoopReadLine,1,1) == "[")
        {
            if(_hasFound)
            {
                _hasFound := false
                ;如果只需要找到第一个,那么这里可以设置退出循环
            }
            ;检查标题行内容
            if(substr(A_LoopReadLine,2,StrLen(A_LoopReadLine)-2) == _queryStr)
            {
                _resultCount ++
                _resultLineIndex := _lineIndex
                _hasFound := true ;设置找到标记,从下一行开始读内容
            }
        }
        else
        {
            if(_hasFound)
            {
                ;如果允许读行,就开始读行
                ;带行号输出
                ;_resultContent .= _lineIndex . ". " . A_LoopReadLine . "`n"
                ;不带行号输出
                _resultContent .= A_LoopReadLine . "`n"
            }
        }
    }
    ;msgbox,% "找到结果:" . _resultCount . "条`n起始位置在第" . _resultLineIndex . "行`n`n" . _resultContent
    return %_resultContent%
}

;[函数--获取ini所有片段的标题]
;========================================================
GetIniFileALLSectionsTitle(_iniFilePath){
    ;要查找的文件对象
    _filePath := _iniFilePath
    ;inputbox,fileFullName,输入查找目标文件

    ;查找内容
    ;_queryStr := _sectionTitle
    ;inputbox,_queryStr,输入查找内容

    _lineIndex := 0 ;[行号]
    ;查找结果
    _resultLineIndex := -1
    _resultCount := 0
    _hasFound := false  ;是否已找到,在找到指定的标题行后,可以开始读其内容
    _resultContent := ""

    Loop, read, % _filePath
    {
        _lineIndex++
        ;检查是否标题行
        if(substr(A_LoopReadLine,1,1)="[")
        {
            _resultCount ++
            ;带行号输出
            _resultContent .= "[" . _resultCount . "]  " . substr(A_LoopReadLine,2,StrLen(A_LoopReadLine)-2) . "`n`n"
            ;不带行号输出
            ;_resultContent .= A_LoopReadLine . "`n"
        }
    }
    clipboard := _resultContent
    _resultContent := ""
}


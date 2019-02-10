; ==========================================================
; 文件类 File.class.ahk
;
; 文档作者: 烈焰
;
; 修改时间: 2018-09-05 22:40:01
;
; 关联文件: json.class.ahk
; ==========================================================

; ----------------------------------------------------------
; class File
; ----------------------------------------------------------
class File {
    static testTag := "文件类"
    ; 单元测试
    test(){
        msgbox, % "未设置操作内容!"
    }

    ; 读文件
    read(){
        msgbox, % "未设置操作内容!"
    }

    ; 写文件
    write(){
        msgbox, % "未设置操作内容!"
    }

    ; 删文件
    delete(){
        msgbox, % "未设置操作内容!"
    }

    ; 更改文件
    update(){
        msgbox, % "未设置操作内容!"
    }
}

; ----------------------------------------------------------
; class JsonFile extends File
; ----------------------------------------------------------
class JsonFile extends File{
    static testTag := "json文件类"

    ; static 读文件
    ; 返回json对象
    read(_jsonPath){
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

; ----------------------------------------------------------
; class CsvFile extends File
; ----------------------------------------------------------
class CsvFile extends File{
    static testTag := "csv文件类"
    ; 单元测试
    test(){

    }

    ; static 读文件
    ; 返回csv二维数组 [[...], [...], [...]]
    read(_filePath){
        return CsvFile.readCsvToList(_filePath, [","])
    }

        ; static 写文件
    write(_filePath, _data*){

    }

    ; static 删文件
    delete(){

    }

    ; static 更改文件
    update(_row_index, _col_key, _value, _filePath){
        ; 1. 从csv文件导入数据到数组中
        ; 2. 迭代数组, 修改key对应的值[{k:v, k:v}, {k:v, k:v}, {k:v, k:v}]
        _list := CsvFile.readCsvToList(_filePath, [","])
        for _rindex, _rvalue in _list {     ; 数组: k是index, 字典: k是key
            for _ckey, _cvalue in _list[_rindex]
                if(_rindex==_row_index && _ckey==_col_key)
                    _list[_rindex][_ckey] := _value
        }
        ; 3. 列表写入到csv文件
        CsvFile.writeListToCsv(_list, _filePath)
    }

    ; static 追加内容
    append(_filePath, _params*){
        _line := ""
        for _index, _param in _params {
            _line .= _param
            if(_index < _params.MaxIndex())
                _line .= ","
        }
        try{
            _fileObj := FileOpen(_filePath, "a")
            _fileObj.WriteLine(_line)
        }
        catch e{
            ; 关于e对象的更多细节, 请参阅 Exception().
            MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
                . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
                . "`ntips: 可能是有其他文件占用csv文档, 导致无法写入文件错误!"
        }
        finally{
            _fileObj.Close()
        }
    }

    ; static 读文件readCsvToList
    ; _Delimiters 数组型, 二级以上多维数组分割符字符
    ; 返回csv二维数组 [[...], [...], [...]]
    readCsvToList(_filePath, _Delimiters, _OmitChars:=" `t`n`r"){
        _array:=[]
        loop, read, % _filePath
        {
            if(InStr(A_LoopReadLine, ",")){
                _array.push(strSplitDeep(A_LoopReadLine, _Delimiters, _OmitChars))
            }
        }
        return _array
    }

    ; static 写文件writeListToCsv
    writeListToCsv(_list, _filePath){
        ; 数组格式: [{k:v, k:v}, {k:v, k:v}, {k:v, k:v}]
        _line := "" ; 行内容将{k1:v1, k2:v2} 转化成 "v1,v2,..."的字符串
        try{
            _fileObj := FileOpen(_filePath, "w")
            for _rindex, _rvalue in _list {
                ; 每行开始缓存清空
                _line := ""
                ; 拼接行内容
                for _ckey, _cvalue in _list[_rindex] {
                    _line .= _cvalue
                    if(A_index < _list[_rindex].MaxIndex())
                        _line .= ","
                }
                ;写入一行到文件
                _fileObj.WriteLine(_line)
            }
        }
        catch e{
            ; 关于e对象的更多细节, 请参阅 Exception().
            MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
                . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
                . "`ntips: 可能是有其他文件占用csv文档, 导致无法写入文件错误!"
        }
        finally{
            _fileObj.Close()
        }
    }
}

; ----------------------------------------------------------
; class IniFile extends File
; ----------------------------------------------------------
class IniFile extends File {
    static testTag := "IniFile类"
    test(){

    }

    ; static 写文件
    write(_Value, _file, _Section, _Key:="")
    {
        _err := 0
        try
            IniWrite, % _Value, % _file, % _Section, % _Key
        catch e
        {
            if(e != 0)
            {
                _err := e
                throw e
            }
        }
        ; 提示处理结果
        return _err
    }

    ; static 读文件
    read(_file, _Section, _Key:="", _Default:="null")
    {
        IniRead, OutputVar, % _file, % _Section, % _Key, % _Default
        return %OutputVar%
    }

    ; static 删文件
    delete(_file, _Section, _Key:="")
    {
        _err := 0
        try
            if(_Key=="")
                IniDelete, % _file, % _Section
            else
                IniDelete, % _file, % _Section , % _Key
        catch e
        {
            if(e != 0)
            {
                _err := e
                throw e
            }
        }
        return _err
    }

    ; static 更改文件
    update(_Value, _file, _Section, _Key:="")
    {
        _err := 0
        try
        {
            IniFile.delete(_file, _Section, _Key)
            IniFile.write(_Value, _file, _Section, _Key)
        }
        catch e
        {
            if(e != 0)
            {
                _err := e
                throw e
            }
        }
        return _err
    }

    ; static 扩展功能: 加载配置变量, 如果配置不存在, 则设置默认值;
    loadInitVar(_file, _Section, _Key, _Default){
        _result := ""
        _result := IniFile.read(_file, _Section, _Key, "null")
        if(_result == "null" || _result == ""){
            _result := _Default
            IniFile.update(_result
                , _file
                , _Section
                , _Key)
        }
        return _result
    }
}

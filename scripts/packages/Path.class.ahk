; ==========================================================
; 路径类 Path.class.ahk
;
; 文档作者: 烈焰
;
; 修改时间: 2017-03-15 17:10:41
; ==========================================================

; ----------------------------------------------------------
; class Path
; ----------------------------------------------------------
class Path {
    static testTag := "路径类"
    ; 单元测试 public static test()
    test(){
        
        Test.eq("Path.hasExtName(""C:\Windows\hh.exe"") == true"
            , true
            , Path.hasExtName("C:\Windows\hh.exe")
            , Path.testTag)
        Test.eq("Path.hasExtName(""C:\Windows\hh.1exe"") == false //异常:扩展名错误"
            , false
            , Path.hasExtName("C:\Windows\hh.1exe")
            , Path.testTag)
        Test.eq("Path.isDir(""C:\Windows\System32"") == true"
            , true
            , Path.isDir("C:\Windows\System32")
            , Path.testTag)
        
        ; path test    
        _path := Path.split("C:\Windows\notepad.exe")
        
        Test.eq("split(""C:\Windows\notepad.exe"") file: notepad.exe"
            , "notepad.exe"
            , _path.file
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad.exe"") dir: C:\Windows"
            , "C:\Windows"
            , _path.dir
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad.exe"") ext: exe"
            , "exe"
            , _path.ext
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad.exe"") fileNoExt: notepad"
            , "notepad"
            , _path.fileNoExt
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad.exe"") drive: C: //区分大小写"
            , "C:"
            , _path.drive
            , Path.testTag)
        
        ; path test 2 对不含扩展名 split自动检测处理   
        _path := Path.split("C:\Windows\notepad")
        Test.eq("split(""C:\Windows\notepad"") file: notepad"
            , "notepad"
            , _path.file
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad"") ext: 空字符"
            , ""
            , _path.ext
            , Path.testTag)
        Test.eq("split(""C:\Windows\notepad"") fileNoExt: notepad"
            , "notepad"
            , _path.fileNoExt
            , Path.testTag)
    }
    
; ----------------------------------------------------------
;     Path 公共静态方法
; ----------------------------------------------------------
    ; static 分解文件路径, 直接对是否有扩展名进行检测
    split(_filePath){
        SplitPath, _filePath, _file, _dir, _ext, _fileNoExt, _drive
        if(Path.hasExtName(_filePath) == false){
            _ext := ""
            _fileNoExt := _file
        }
        return {path: _filePath
                , file: _file
                , dir: _dir
                , ext: _ext
                , fileNoExt: _fileNoExt
                , drive: _drive}
    }
    
    ; static 判断指定文件路径是否是目录
    isDir(__FullFileName){
        _result:= false
        FileGetAttrib, _Attributes, %__FullFileName%
        IfInString, _Attributes, D
            _result:= true
        return _result
    }
    
    ; static 判断字符串是否包含扩展名
    hasExtName(_filePath){
        if(_filePath ~= "i)(?:\.[a-z]\w{1,6})$")
            return true
        else
            return false
    }
}
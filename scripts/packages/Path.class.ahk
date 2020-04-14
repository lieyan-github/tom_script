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

; ----------------------------------------------------------
;     Path 公共静态方法
; ----------------------------------------------------------
    ; static 分析文件路径, 直接对是否有扩展名进行检测
    parse(_filePath){
        SplitPath, _filePath, _file, _dir, _ext, _fileNoExt, _drive
        return {path: _filePath
                , file: _file
                , dir: _dir
                , ext: _ext
                , fileNoExt: _fileNoExt
                , drive: _drive
                , 当前目录名: SubStr(_dir, InStr(_dir, "\", false, 0, 1) + 1)
                , isDir: Path.isDir(_filePath)
                , hasExt: Path.hasExt(_filePath)}
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
    hasExt(_filePath){
        if(Path.isDir(_filePath))
            return False        ; 目录没有扩展名
        if(_filePath ~= "i)(?:\.[a-z0-9]{1,8})$")
            return true         ; 有扩展名
        else
            return false        ; 无扩展名
    }
}

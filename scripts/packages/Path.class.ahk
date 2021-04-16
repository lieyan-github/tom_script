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

        return Path.分析文件路径(_filePath)

        ; SplitPath, _filePath, _file, _dir, _ext, _fileNoExt, _drive
        ; return {path: _filePath
        ;         , file: SubStr(_filePath, InStr(_filePath, "\", false, 0, 1) + 1)
        ;         , dir: _dir
        ;         , ext: Path.isDir(_filePath) ? "" : _ext
        ;         , fileNoExt: Path.getFileNoExt(_filePath)
        ;         , drive: _drive
        ;         , 当前目录名: SubStr(_dir, InStr(_dir, "\", false, 0, 1) + 1)
        ;         , isDir: Path.isDir(_filePath)
        ;         , hasExt: Path.hasExt(_filePath)}

    }

    /*
    分析文件路径(_文件路径)
    */
    分析文件路径(p_文件完整路径){
        
        if(p_文件完整路径 = ""){
            Return ""
        }

        _ret := {}
        _路径 := p_文件完整路径        
        
        ; 对间隔符号定位
        _begin_pos  := InStr(_路径, "\", false, 0, 2)
        _end_pos    := InStr(_路径, "\", false, 0, 1)
        _dot_pos    := InStr(_路径, ".", false, 0, 1)

        ; path 源文件完整路径
        _ret.path       := _路径
        ; dir 当前目录路径
        _ret.dir        := SubStr(_路径, 1, _end_pos - 1)
        ; dir_name 当前目录名
        _ret.dir_name   := SubStr(_路径, _begin_pos + 1, _end_pos - _begin_pos - 1)

        _ret.is_dir     := Path.is_dir(_路径)
        _ret.has_ext    := Path.has_ext(_路径)

        ; file 文件名, 含扩展
        _ret.file       := SubStr(_路径, _end_pos + 1)
        ; ext 扩展名
        _ret.ext        := _ret.has_ext ? SubStr(_路径, _dot_pos + 1) : ""
        ; file_no_ext 文件名, 不含扩展
        _ret.file_no_ext:= InStr(_路径, ".") ? SubStr(_路径, _end_pos + 1, _dot_pos - _end_pos - 1) : SubStr(_路径, _end_pos + 1)


        ; drive 驱动器名
        _ret.drive      := SubStr(_路径, 1, 1) . ":"


        return _ret
    }

    ; static 判断指定文件路径是否是目录
    is_dir(__FullFileName){
        _result:= false
        FileGetAttrib, _Attributes, %__FullFileName%
        IfInString, _Attributes, D
            _result:= true
        return _result
    }

    ; static 判断字符串是否包含扩展名
    has_ext(_filePath){
        if(Path.is_dir(_filePath))
            return False        ; 目录没有扩展名
        if(_filePath ~= "i)(?:\.[a-z0-9]{1,8})$")
            return true         ; 有扩展名
        else
            return false        ; 无扩展名
    }

    ; static 获取文件名, 含扩展名
    getFile(_filePath){
        _file:=  SubStr(_filePath, InStr(_filePath, "\", false, 0, 1) + 1)
    }

    ; static get_file_no_ext
    get_file_no_ext(_filePath){
        _file:=  SubStr(_filePath, InStr(_filePath, "\", false, 0, 1) + 1)
        if(Path.is_dir(_filePath))
            Return _file
        Else
            return SubStr(_file, 1, InStr(_file, ".", false, 0, 1)-1)
    }
}

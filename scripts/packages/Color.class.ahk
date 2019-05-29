; ==========================================================
; Analyser.class.ahk  分析器超类
;
; 文档作者: 烈焰
;
; 修改时间: 2016-06-02 02:44:29
; ==========================================================

; public class Color
class Color{
    __new(_hex){
        this.hex := _hex
        this.rgb:= {}
        this.rgb.r:= (_hex >> 16) & 255                     ;0xff0000
        this.rgb.g:= (_hex >> 8)  & 255                     ;0x00ff00
        this.rgb.b:= _hex & 255                             ;0x0000ff
    }

    r{
        get{
            return this.rgb.r
        }
        set{
            return this.rgb.r := value
        }
    }

    g{
        get{
            return this.rgb.g
        }
        set{
            return this.rgb.g := value
        }
    }

    b{
        get{
            return this.rgb.b
        }
        set{
            return this.rgb.b := value
        }
    }

    print(){
        msgbox % Format("color.r = {1}`ncolor.g = {2}`ncolor.b = {3}"
                , this.r
                , this.g
                , this.b)
    }
}

; test
; ----------------------------------------------------------
; color := new Color(0xfafafa)
; color.print()

; msgbox, % 0x0000ff
; ----------------------------------------------------------

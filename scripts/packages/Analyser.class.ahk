; ==========================================================
; Analyser.class.ahk  分析器超类
; 
; 文档作者: 烈焰
; 
; 修改时间: 2016-06-02 02:44:29
; ==========================================================

; public class Analyser
class Analyser {
    ; public analysand 被分析对象
    analysand := ""
    ; public new()
    __new(_analysand){
        this.analysand := _analysand
    }
    ;public object analyse() 返回分析结果--数据结构对象
    analyse(){
        ; 等派生类实现操作
        throw Exception("do-nothing operation", -1)
    }
}
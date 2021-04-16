; ==========================================================
; Flow.class.ahk  工作流管理
;
; 文档作者: 烈焰
;
; 修改时间: 2016-05-15 02:48:35
; ==========================================================

class Flow {
    ; public
    static flowLog := []
    static runState := false
    ; static
    start(){
        Flow.runState := true
    }
    ; static
    end(){
        Flow.runState := false
        clipboard := "=== 流程记录 ===`n" . Flow.toStr()
        show_msg("流程记录已存入剪贴板数组")
        Flow.clear()
    }
    ; static
    add(_location:=""){
        if(Flow.runState){
            if(_location == ""){
                list_push(Flow.flowLog, "[File]" . A_LineFile
                                    . "  [Line]" . A_LineNumber
                                    . "  [Func]" . A_ThisFunc
                                    . "  [Label]" . A_ThisLabel)
            }
            else
                list_push(Flow.flowLog, _location)
        }
    }
    ; static
    clear(){
        list_clear(Flow.flowLog)
    }
    ; static
    toStr(){
        return list_to_str(Flow.flowLog)
    }
}


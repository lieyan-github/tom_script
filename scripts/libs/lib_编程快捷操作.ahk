; ==========================================================
;
; 编写代码快捷操作
;
; 文档作者: 烈焰
;
; 修改时间: 2017-09-08 20:07:11
;
; ==========================================================

; ----------------------------------------------------------
; 函数--输出代码片段
; ----------------------------------------------------------
writeCodeSnippet(_引导符号:="`;"){
    _pos:= InStr(A_ThisHotkey, _引导符号, 0)
    write(GetIniFileSection(Config.upath("CodeSnippetFile"), SubStr(A_ThisHotkey, _pos+1)))
}

; ----------------------------------------------------------
; [代码块注释]
; ----------------------------------------------------------
; 注释代码块 (需选定内容)
; 参数_enableWrap: 大于0添加上下边界线
; 参数_wrapBorderLinelineType: 大于1使用第二种边框线
; 参数_clearBlankLines: 大于0清理连续的空白行, 只留一个
; ----------------------------------------------------------
注释代码块(_enableWrap=1, _wrapBorderLinelineType=1, _clearBlankLines=0){
    if(_wrapBorderLinelineType>1)
        _wrapBorderLine:= Config.get("wrapBorderLine2")
    else
        _wrapBorderLine:= Config.get("wrapBorderLine1")
    symbol := Config.get("commentSymbol")
    ;备份剪贴板内容
    _clip := Clipboarder.get("cut")
    result := ""
    _blankLinesCount := 0    ;空行计数, 只记录最近连续的空行, 清理多余空行
    if(_enableWrap>0)
    {
        result .= symbol . " " . _wrapBorderLine . "`n"
        Loop, parse, _clip, `n, `r
        {
            ;所有选中的行都进行注释
            ; ----------------------------------------------------------
            ; 补充方案一: 注释非空行, 过滤连续多个空行, 只保留一个空行注释
            if(_clearBlankLines>0)              ;如果允许清理空行, 则只留一个空行
            {
                if ("" = trim(A_LoopField))     ;如果当前行是空行
               {
                    if(_blankLinesCount>0)      ;1. 且上一个也是空行
                    {
                        result .= ""            ;则忽略当前空行, 不进行注释
                    }
                    else                        ;2. 上一行非空行, 则对本行进行注释
                    {
                        result .= symbol . " " . A_LoopField . "`n"
                    }
                    _blankLinesCount++          ;对空行计数累加
               }
               else
               {
                   ;非空行进行注释
                   result .= symbol . " " . A_LoopField . "`n"
                   _blankLinesCount:= 0         ;空行计数清零
               }
            }
            else                                ;如果不允许清理空行, 则直接对每行进行注释
            {
                result .= symbol . " " . A_LoopField . "`n"
            }
            ; ----------------------------------------------------------
        }
        result .= symbol . " " . _wrapBorderLine
    }
    else
    {
        Loop, parse, clipboard, `n, `r
        {
            ;所有选中的行都进行注释
            ; ----------------------------------------------------------
            ; 补充方案一: 注释非空行, 过滤连续多个空行, 只保留一个空行注释
            if(_clearBlankLines>0)              ;如果允许清理空行, 则只留一个空行
            {
                if ("" = trim(A_LoopField))     ;如果当前行是空行
               {
                    if(_blankLinesCount>0)      ;1. 且上一个也是空行
                    {
                        result .= ""            ;则忽略当前空行, 不进行注释
                    }
                    else                        ;2. 上一行非空行, 则对本行进行注释
                    {
                        result .= symbol . " " . A_LoopField . "`n"
                    }
                    _blankLinesCount++          ;对空行计数累加
               }
               else
               {
                   ;非空行进行注释
                   result .= symbol . " " . A_LoopField . "`n"
                   _blankLinesCount:= 0         ;空行计数清零
               }
            }
            else                                ;如果不允许清理空行, 则直接对每行进行注释
            {
                result .= symbol . " " . A_LoopField . "`n"
            }
            ; ----------------------------------------------------------
        }
    }
    write(result)
}

; ----------------------------------------------------------
; 取消注释代码块, 可以识别当前行是否被注释(需选定内容)
; ----------------------------------------------------------
取消注释代码块(){
    symbol := Config.get("commentSymbol")
    ;注意注释的时候还加了一个空格,所以恢复的时候需要连同空格一起清除
    symbol_length := StrLen(symbol . " ")
    ;备份剪贴板内容
    _clip := Clipboarder.get("cut")
    result := ""
    _uncomment_count := 0
    Loop, parse, _clip, `n, `r
    {
        if (1 = InStr(A_LoopField, symbol))
        {
            if(A_LoopField = (symbol . " " . Config.get("wrapBorderLine1")) || A_LoopField = (symbol . " " . Config.get("wrapBorderLine2")))
                ;如果是上下边界则直接清除
                _uncomment_count ++
            else
            {
                ;如果当前行被注释, 则取消注释
                _line := SubStr(A_LoopField, 1+symbol_length)
                result .= _line . "`n"
                _uncomment_count ++
            }
        }
        else
        {
            ;如果当前行未被注释, 则无需取消注释
            result .= A_LoopField . "`n"
        }
    }
    write(result)
    send {Backspace} ;对最后多出的换行进行修正
    if (0 = _uncomment_count)
        show_msg("取消注释行数为零, 很可能是当前注释符不正确!`n当前全局注释符为""" . Config.get("commentSymbol") . """`n")
}

; ----------------------------------------------------------
; xml包裹选定文本段落, 如<p>...</p>, 可通过全局符号进行设置
; 按行进行分割, 可识别空行不包裹, 无上下边界线
; ----------------------------------------------------------
xml包裹选定文本(){
    if(Clipboarder.length() < 1)
    {
        show_msg("注意: 没有设置标签名! <??>...</??>`n`n 备注: 使用Ctrl + Alt + C可以直接复制设置标签名.")
        return
    }
    symbol := Clipboarder.item(Clipboarder.length())
    ;备份剪贴板内容
    _clip := Clipboarder.get("cut")
    result := ""
    Loop, parse, _clip, `n, `r%A_Space%%A_Tab%
    {
        ; ----------------------------------------------------------
        ; 方案一: 当前行为空, 则不进行注释
;       if ("" = trim(A_LoopField))
;       {
;           ;当前行为空, 则不进行注释
;           result .= "`n"
;       }
;       else
;       {
;           ;当前行有代码则注释
;           result .= symbol . " " . A_LoopField . "`n"
;       }
        ; ----------------------------------------------------------
        ; 方案二: 无条件的对当前行注释
        result .= "<" . symbol . ">" . A_LoopField . "</" . symbol . ">" . "`n"
    }
    write(result)
    send {Backspace} ;对最后多出的换行进行修正
}

; ----------------------------------------------------------
; 设置代码段落标题(将当前行全部内容设置为段落标题)
; ----------------------------------------------------------
设置代码段落标题(_wrapBorderLinelineType=1){
    if(_wrapBorderLinelineType>1)
        _wrapBorderLine:= Config.get("wrapBorderLine2")
    else
        _wrapBorderLine:= Config.get("wrapBorderLine1")
    symbol := Config.get("commentSymbol")
    ;备份剪贴板内容
    send {home}+{end}
    sleep 100
    clipboard_content := Clipboarder.get("cut")
    result := ""
    result .= symbol . " " . _wrapBorderLine . "`n"
    result .= symbol . " " . clipboard_content . "`n"
    result .= symbol . " " . _wrapBorderLine
    write(result)
}

; ----------------------------------------------------------
; 代码段边界线
; ----------------------------------------------------------
代码段边界线(_wrapBorderLinelineType=1){
    if(_wrapBorderLinelineType>1)
        _wrapBorderLine:= Config.get("wrapBorderLine2")
    else
        _wrapBorderLine:= Config.get("wrapBorderLine1")
    symbol := Config.get("commentSymbol")
    result := ""
    result .= symbol . " " . _wrapBorderLine
    write(result)
}




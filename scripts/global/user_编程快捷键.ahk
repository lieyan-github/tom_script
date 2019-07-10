; ==========================================================
; ----------------------------------------------------------
; user_编程快捷键
;
; 作者: 烈焰
;
; 2016-04-30 02:53:58
; ----------------------------------------------------------
; ==========================================================

; ----------------------------------------------------------
; [针对python编码]
; ----------------------------------------------------------
:*:;pyimport::
    write("import numpy as np, pandas as pd, matplotlib.pyplot as plt")
    return
; ----------------------------------------------------------
; 功能帮助索引
; ----------------------------------------------------------
:*:;help::
    ;writeCodeSnippet()
    _list:= GetIniFileALLSectionsTitle(Config.upath("CodeSnippetFile"))
    arrayPrint(_list)
    return
; ----------------------------------------------------------
; 编程常用代码片段
; ----------------------------------------------------------
:*:;if::
    writeCodeSnippet()
    return
:*:;while::
    writeCodeSnippet()
    return
:*:;for::
    writeCodeSnippet()
    return
:*:;try::
    writeCodeSnippet()
    return
:*:;class::
    writeCodeSnippet()
    return
:*:;case::
    writeCodeSnippet()
    return
:*:;switch::
    writeCodeSnippet()
    return
; ----------------------------------------------------------
; ahk常用片段
; ----------------------------------------------------------
:*:;ahkclass::
    writeCodeSnippet()
    return

:*:;ahkmenu::
    writeCodeSnippet()
    return
; ----------------------------------------------------------
; js常用片段
; ----------------------------------------------------------
:*:;jsclass::
    writeCodeSnippet()
    return
:*:;jsobject::
    writeCodeSnippet()
    return
:*:;jsfunction::
    writeCodeSnippet()
    return
; ----------------------------------------------------------
; sql常用片段
; ----------------------------------------------------------
:*:;select::
    writeCodeSnippet()
    return
:*:;insert::
    writeCodeSnippet()
    return
:*:;delete::
    writeCodeSnippet()
    return
:*:;update::
    writeCodeSnippet()
    return

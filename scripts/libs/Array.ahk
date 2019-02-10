; ==========================================================
; 数组类 array.ahk
;
; 文档作者: tom
;
; 修改时间: 2019-02-08 15:46:36
; ==========================================================

; ----------------------------------------------------------
; dict functions    字典方法
; ----------------------------------------------------------

; dictHasKey(_dict, _key)
; 检测字典包含指定键, 包含返回true, 无则返回false
dictHasKey(_dict, _key){
    return _dict.HasKey(_key)
}

; dictHasValue(_dict, _value)
; 深度遍历, 检测字典包含指定值, 包含返回key链, 无则返回""
; _pathKey记录当前key链路径, 如下数组, "孙俪"对应链路径"3/姓名"
; _arrayInfo := [
;                   {"姓名": "周星驰"},
;                   {"姓名": "陈道明"},
;                   {"姓名": "孙俪"}
;               ]
dictHasValue(_dict, _value, _pathKey:="", _separate:="/"){
    _result := ""
    for _k, _v in _dict
        ;msgbox % _k . " : " . _v    ;debug专用
        if(IsObject(_v))
            _result .= dictHasValue(_v, _value, _pathKey . _k . _separate)
        else
            if(_v == _value)
                _result .=  _pathKey . _k
    return _result
}

; ----------------------------------------------------------
; array functions   数组方法
; ----------------------------------------------------------

; int arrayIndex(_array, _value) ;
; return index, fail return -1
arrayIndex(_array, _value){
    For k, v in _array
        if(v == _value)
            return k
    return -1
}

; arrayAppend(_array, _value*)
arrayAppend(_array, _value*)
{
    _array.Push(_value*)
}

; arrayInsert(_array, _index, _value*)
; 追加新元素在指定索引位置;
arrayInsert(_array, _index, _value*)
{
    _array.InsertAt(_index, _value*)
}

; arrayPush(_array, _value*)
; 默认加入元素在末尾;
arrayPush(_array, _value*)
{
    return _array.Push(_value*)
}

arrayPushFirst(_array, _value*){
    return _array.InsertAt(1, _value*)
}

; arrayPop
; 默认弹出最后一项
arrayPop(_array)
{
    ; 数组空异常处理
    if(_array.MaxIndex()<1){
        throw Exception("数组为空, 不能弹出数组元素", -1)
        return ""
    }
    return _array.Pop()
}

; arrayPopFirst     弹出第一项
arrayPopFirst(_array){
    ; 数组空异常处理
    if(_array.MaxIndex()<1){
        throw Exception("数组为空, 不能弹出数组元素", -1)
        return ""
    }
    return _array.RemoveAt(1)
}

; arrayPopIndex(_array, _index)     弹出指定项
arrayPopIndex(_array, _index)
{
    if(_index <1 || _index>_array.Length()){
        throw Exception("arrayPopIndex(ByRef _array, _index), _index数值超过数组长度范围")
        return ""
    }
    _item:= _array[_index]
    arrayRemove(_array, _index)
    return _item
}

; arrayRemove(_array, _index)       ; 返回 _index 对应的值
arrayRemove(_array, _index)
{
    return _array.RemoveAt(_index)
}

; arrayReverse(_array)  反转数组函数
arrayReverse(_array){
    _i := 1
    _max := _array.MaxIndex()
    _arrayHalfLength := _array.MaxIndex() // 2
    _tmp := ""
    loop % _arrayHalfLength {
        ; 两头交换
        _tmp := _array[_i]
        _array[_i] := _array[_max]
        _array[_max] := _tmp
        ; 计数
        if(_i != _max){
            _i++
            _max--
        }
    }
}

; arrayJoin(_array)   拼接数组元素输出字符串
; _separator 拼接间隔字符
; _cleanSeparator, 清洗原字符串中包含的间隔符, 默认清洗
; _replaceSeparator, 清洗时, 用指定字符替换间隔符
arrayJoin(_array, _separator:=" ", _cleanSeparator:=true, _replaceSeparator:="_"){
    _result := ""
    for k, v in _array {
        if(_cleanSeparator){
            _result .= StrReplace(trim(v, " `t"), _separator, _replaceSeparator) . _separator
        }
        else{
             _result .= v . _separator
        }
    }
    return SubStr(_result, 1, -StrLen(_separator))
}

; arrayClear(ByRef _array)      ; 清空数组
arrayClear(_array)
{
    _array.RemoveAt(1, _array.Length())
}

; arrayToStr()      可以识别数组或字典, 并分别做处理
; 将指定数组格式化, 返回字符串,
; 遍历内部的所有成员数组和字典
; _array: 数组参数, 递归一定不能使用byRef;
; _indent: 是否缩进, 默认缩进;
; _level: 递推的层数;
; _indentStr: 缩进字符;
; _endStr: 行结束字符;
arrayToStr(_array, _indent:=true, _level:=0, _indentStr:="    ", _endStr:="`n")
{
    _result:= ""
    _indent_str := ""
    if(_indent)
        loop %_level%
            _indent_str .= _indentStr
    for k, v in _array {
        if(IsObject(v)){
            _result .= _indent_str . k . ": " . _endStr
            _result .= arrayToStr(v, _indent, _level+1, _indentStr, _endStr)
        }
        else{
            _result .= _indent_str . k . ": " . v . _endStr
        }
    }
    return _result
}

; arrayPrint(_array, _w:=800, _h:=600)
; ListVars调试界面显示
arrayPrint(_array, _w:=800, _h:=600){
    ; 控制台显示
    _text_out := arrayToStr(_array)
    _text_out := StrReplace(_text_out, "`n", "`r`n") ; for display purposes only
    ListVars
    WinWaitActive ahk_class AutoHotkey
    WinMove, ahk_class AutoHotkey, , , , %_w%, %_h%
    ControlSetText Edit1, %_text_out%`r`n
    WinWaitClose
}

; arrayMap(_funcName, ByRef _list, _params*)
; 根据提供的函数对指定列表每个元素做处理
; _funcName:    函数名字符串, 函数的第一值参数必须是数组value
; _list:        数组(引用调用), 修改原数组
; _params*:     函数其他参数
; return:       返回处理过的数组引用
arrayMap(_funcName, ByRef _list, _params*){
    _func := Func(_funcName)        ; 获得函数对象
    for k, v in _list
        _list[k] := _func.Call(v, _params*)
    return _list                    ;返回处理过的数组引用
}

; public static reduce() 函数会对参数序列中元素进行累积, 比如累加, 阶乘..
; _funcName:    函数名字符串, 函数的前两个参数必须是数组value
; _list:        数组(值调用), 不修改原数组
; _params*:     函数其他参数
; return:       返回处理过的累积值
arrayReduce(_funcName, _list, _params*){
    _func := Func(_funcName)        ; 获得函数对象
    _result =                       ; 存储中间值和结果
    _count  := 1                    ; 循环计数器
    ; produce
    for k, v in _list {
        if(_count == 1){
            _result := v
            _count++
        }
        else{
            _result := _func.Call(_result, v, _params*)
        }
    }
    return _result                 ;返回处理过的累积值
}

; arrayUnique(_array)
; 从指定数组中收集所有唯一项, 返回收集结果数组
arrayUnique(_array){
    _newArray   := []
    _valueCheck := ""
    ; -----------------------
    Loop % _array.Length() {
        _valueCheck := Trim(_array[A_Index], " `t")     ; 获取源数组的每个元素
        if(_valueCheck != "")                           ; 如果当前元素值空, 则进行下一轮匹配
            if(arrayIndex(_newArray, _valueCheck)<0)    ; 如果匹配无, 则追加到新数组
            _newArray.push(_valueCheck)
    }
    return _newArray
}

; arrayFindMinIndex(_array)
; 找出数组中最小值的索引
arrayFindMinIndex(_array){
    _min:= _array[1]
    _min_index:= 1
    ;-----------------
    _i:= 2
    _end:= _array.Length()
    while(_i <= _end){
        if(_array[_i]<_min){
            _min := _array[_i]
            _min_index := _i
        }
        _i++
    }
    ;-----------------
    return _min_index
}

; 对数组进行升序排序
arraySort(_array, _ByAsc:=true){
    _newArr := []
    _minIndex := 0
    ;-----------------
    _i:= 1
    if(_ByAsc)      ;升序
        loop % _array.Length() {
            _minIndex:= arrayFindMinIndex(_array)
            arrayPush(_newArr, arrayPopIndex(_array, _minIndex))
        }
    else
        loop % _array.Length() {
            _minIndex:= arrayFindMinIndex(_array)
            arrayPushFirst(_newArr, arrayPopIndex(_array, _minIndex))
        }
    return _newArr
}

; arrayCollect(_array, _one_dimensional:= true, _indexOrKey:=0)
; 收集数组元素, 并且去除重复内容
; _one_dimensional 是否一维数组
; 非一维数组, 例如
; [ [1, [12,13] ],  [2, [22, 23]]]
; [ {"作品名":"...", "tag":["..", ".."]}, {"作品名":"...", "tag":["..", ".."]}]
arrayCollect(_array, _valueField:="", _one_dimensional:=False){
    _newArr := []
    if(_one_dimensional){                   ; 如果是一维数组
        for k,v in _array{
            _newArr.push(v)
        }
        _newArr := arrayUnique(_newArr)     ; 清除重复
    }
    else{                                   ; 非一维数组
        Loop % _array.Length() {            ; 当前层是数组
            _newArr.push(_array[A_Index][_valueField]*)     ; 压入指定键的值
        }
        _newArr := arrayUnique(_newArr)     ; 清除重复
    }
    return _newArr
}

; arrayAssociate(_arrayTag, _arrayInfo, _keyField, _valueField)
; _valueField 如果值字段是_self, 则获取当前info数组项全部字段
; 创建两个数组之间的关联数组
; _arrayTag := ["导演", "演员", "制片人", "男性", "女性"]
; _arrayInfo := [
;                {"姓名": "周星驰", "tag": ["导演", "演员", "制片人", "男性"]},
;                {"姓名": "陈道明", "tag": ["演员", "制片人", "男性"]},
;                {"姓名": "孙俪", "tag": ["演员", "女性"]},
;                {"姓名": "赵薇", "tag": ["演员", "女性", "导演"]},
;            ]
; 关联数组 := {
;                "导演": ["周星驰"],
;                "演员": ["周星驰", "陈道明", "孙俪", "赵薇"],
;                "男性: ["周星驰", "陈道明"],
;                "女性: ["孙俪", "赵薇"]
;            }
arrayAssociate(_arrayTag, _arrayInfo, _keyField, _valueField:="_self"){
    _assocArr := {}
    for _tagIndex, _tag in _arrayTag {                                            ; tag数组的每个tag标签
        _arrCollect  := []
        Loop % _arrayInfo.Length()                                                ; 每个info数组项
            if(arrayIndex(_arrayInfo[A_Index][_keyField], _tag)>0)                ; 检测当前info数组项,key字段是否包含指定tag
                if("_self" == _valueField)                                        ; 如果值字段是_self, 则获取当前info数组项全部字段
                    _arrCollect.push(_arrayInfo[A_Index])
                else
                    _arrCollect.push(_arrayInfo[A_Index][_valueField])            ; 从当前info数组项获取姓名字段
        _assocArr[_tag] := _arrCollect
    }
    return _assocArr
}

; ----------------------------------------------------------
; test 单元测试
; ----------------------------------------------------------
; _arrayInfo := [{"姓名": "周星驰", "tag": ["导演", "演员", "制片人", "男性", "香港人"]}
;               ,{"姓名": "陈道明", "tag": ["演员", "制片人", "男性", "60后"]}
;               ,{"姓名": "孙俪", "tag": ["演员", "女性", "江苏人"]}
;               ,{"姓名": "赵薇", "tag": ["演员", "女性", "导演", "投资商"]}]
; _arrayTag := ["导演", "演员", "制片人", "男性", "女性"]
; _tags := arrayCollect(_arrayInfo, "tag")
; _arrayResult := arrayAssociate(_arrayTag, _arrayInfo, "tag", "姓名")
; arrayPrint(_arrayResult)
; _arrayResult := arrayAssociate(_tags, _arrayInfo, "tag", "姓名")
; arrayPrint(_arrayResult)

; throw Exception("Exception thrown!`n`nwhat: " . e.what
;                 . "`nfile: " . e.file
;                 . "`nline: " . e.line
;                 . "`nmessage: " . e.message
;                 .  "`nextra: " . e.extra)

; allowResizeWins := {"allowResizeWins": [{"ie":"IEFrame"}
;                                         ,{"GomPlayer":"GomPlayer1.x"}
;                                         ,{"EmEditor": "EmEditorMainFrame3"}
;                                         ,{"360极速浏览器": "Chrome_WidgetWin_1"}
;                                         ,{"EVERYTHING": "EVERYTHING"}
;                                         ,{"AutoHotkeyGUI": "AutoHotkeyGUI"}
;                                         ,{"MetaTrader4": "MetaQuotes::MetaTrader::4.00"}
;                                         ,{"sublime text": "PX_WINDOW_CLASS"}]}
; msgbox % dictHasValue(allowResizeWins, "GomPlayer1.x")

; ==========================================================
; 数组类 list_dict.ahk
;
; 文档作者: tom
;
; 修改时间: 2021-03-22 16:22:39
; ==========================================================

; ----------------------------------------------------------
; dict functions    字典方法
; ----------------------------------------------------------

; dict_has_key(_dict, _key)
; 检测字典包含指定键, 包含返回true, 无则返回false
dict_has_key(_dict, _key){
    return _dict.HasKey(_key)
}

; dict_has_value(_dict, _value)
; 深度遍历, 检测字典包含指定值, 包含返回key链, 无则返回""
; _pathKey记录当前key链路径, 如下数组, "孙俪"对应链路径"3/姓名"
; _arrayInfo := [
;                   {"姓名": "周星驰"},
;                   {"姓名": "陈道明"},
;                   {"姓名": "孙俪"}
;               ]
dict_has_value(_dict, _value, _pathKey:="", _separate:="/"){
    _result := ""
    for _k, _v in _dict {
        ;msgbox % _k . " : " . _v    ;debug专用
        if(IsObject(_v)){
            _result .= dict_has_value(_v, _value, _pathKey . _k . _separate)
        }
        else{
            if(_v == _value){
                _result .=  _pathKey . _k
            }
        }
    }
    return _result
}

; ----------------------------------------------------------
; array functions   数组方法
; ----------------------------------------------------------

; int list_get_index(_array, _value) ;
; return index, fail return -1
list_get_index(_array, _value){
    For k, v in _array{
        if(v == _value)
            return k
    }
    return -1
}

; list_has_value(_array, _value) 检查一维数组中是否包含指定值
list_has_value(_array, _value){
    if(list_get_index(_array, _value)>0){
        return true
    }
    else{
        return false 
    }
}

; list_Append(_array, _value*)
list_Append(_array, _value*)
{
    _array.Push(_value*)
}

; list_insert(_array, _index, _value*)
; 追加新元素在指定索引位置;
list_insert(_array, _index, _value*)
{
    _array.InsertAt(_index, _value*)
}

; list_push(_array, _value*)
; 默认加入元素在末尾;
list_push(_array, _value*)
{
    return _array.Push(_value*)
}

list_push_first(_array, _value*){
    return _array.InsertAt(1, _value*)
}

; list_pop
; 默认弹出最后一项
list_pop(_array)
{
    ; 数组空异常处理
    if(_array.MaxIndex()<1){
        throw Exception("数组为空, 不能弹出数组元素", -1)
        return ""
    }
    return _array.Pop()
}

; list_pop_first     弹出第一项
list_pop_first(_array){
    ; 数组空异常处理
    if(_array.MaxIndex()<1){
        throw Exception("数组为空, 不能弹出数组元素", -1)
        return ""
    }
    return _array.RemoveAt(1)
}

; list_pop_index(_array, _index)     弹出指定项
list_pop_index(_array, _index)
{
    if(_index <1 || _index>_array.Length()){
        throw Exception("list_pop_index(ByRef _array, _index), _index数值超过数组长度范围")
        return ""
    }
    _item:= _array[_index]
    list_remove(_array, _index)
    return _item
}

; list_remove(_array, _index)       ; 返回 _index 对应的值
list_remove(_array, _index)
{
    return _array.RemoveAt(_index)
}

; list_remove_by_value(_array, _key)  ; 返回 _key 对应的值
list_remove_by_value(_array, _value)
{
    _result := ""
    _index := list_get_index(_array, _value)
    if(_index>0)
        _result:= _array.RemoveAt(_index)
    return _result
}

; list_reverse(_array)  反转数组函数
list_reverse(_array){
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

; list_join(_array)   拼接数组元素输出字符串
; _separator 拼接间隔字符
list_join(_array, _separator:=" "){
    _result := ""
    for k, v in _array {
        _result .= v . _separator
    }
    return SubStr(_result, 1, -StrLen(_separator))
}

; list_splice(p_lists*) 粘接多个数组, 返回组合后的新数组
list_splice(p_lists*){
    _list := []

    for index,param in p_lists{
        if(IsObject(param)){
            _list.push(param*)
        }
        else{
            _list.push(param)
        }
    }        

    Return _list
}

; list_clear(ByRef _array)      ; 清空数组
list_clear(_array)
{
    _array.RemoveAt(1, _array.Length())
}

; list_to_str()      可以识别数组或字典, 并分别做处理
; 将指定数组格式化, 返回字符串,
; 遍历内部的所有成员数组和字典
; _array: 数组参数, 递归一定不能使用byRef;
; _indent: 是否缩进, 默认缩进;
; _level: 递推的层数;
; _indentStr: 缩进字符;
; _endStr: 行结束字符;
list_to_str(_array, _indent:=true, _level:=0, _indentStr:="    ", _endStr:="`n")
{
    _result:= ""
    _indent_str := ""
    if(_indent)
        loop %_level%
            _indent_str .= _indentStr
    _maxKeyWidth := list_key_width(_array)                ; 统计数组键字符的最大宽度, 等宽格式化用
    for k, v in _array {
        if(!IsObject(v)){   ; 如果非对象或一维数组
            _result .= Format("{1} : {2}"
                            , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                            , v . _endStr)
        }
        else{
            if(is_list(v)){ ; 如果是多维数组
                _result .= Format("{1} : {2}{3}{4}"
                                , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                                , "[" . _endStr
                                , list_to_str(v, _indent, _level+1, _indentStr, _endStr)
                                , _indent_str . "]" . _endStr)
            }
            else{           ; 如果是字典
                _result .= Format("{1} : {2}{3}{4}"
                                , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                                , "{" . _endStr
                                , list_to_str(v, _indent, _level+1, _indentStr, _endStr)
                                , _indent_str . "}" . _endStr)
            }
        }
    }
    return _result
}

; 检测是否简单数组, 而非字典
is_list(_array){
    _是数组:= false
    _是字典:= false
    if(IsObject(_array)){
        if(_array.MaxIndex()!="")
            _是数组:= true
        else
            _是字典:= true
    }
    return _是数组
}

; list_print(_array, _w:=800, _h:=600)
; ListVars调试界面显示
list_print(_array, _w:=800, _h:=600){
    ; 控制台显示
    _text_out := list_to_str(_array)
    _text_out := StrReplace(_text_out, "`n", "`r`n") ; for display purposes only
    ListVars
    WinWaitActive ahk_class AutoHotkey
    WinMove, ahk_class AutoHotkey, , , , %_w%, %_h%
    ControlSetText Edit1, %_text_out%`r`n
    WinWaitClose
}

; list_map(_array, _funcName, _params*)
; 根据提供的函数对指定列表每个元素做处理
; _array:       数组, 不修改原数组
; _funcName:    函数名字符串, 函数格式Call({"k":k, "v":v}, ..)
; _params*:     函数其他参数
; return:       返回处理过的数组引用
list_map(_arrayIn, _funcName, _params*){
    _array := _arrayIn.Clone()
    _func := Func(_funcName)        ; 获得函数对象
    for k, v in _array
        _array[k] := _func.Call({"k":k, "v":v}, _params*)
    return _array                    ;返回处理过的数组引用
}

; public static reduce() 函数会对参数序列中元素进行累积, 比如累加, 阶乘..
; _array:       数组(值调用), 不修改原数组
; _initValue    初始累计值
; _funcName:    函数名字符串, 函数格式Call({"k":_index, "v":v, "cache":_cache}, ..)
; _params*:     函数其他参数
; return:       返回处理过的累积值
list_reduce(_array, _initValue, _funcName, _params*){
    _func   := Func(_funcName)                                  ; 获得函数对象
    _cache  := _initValue                                       ; 存储累计值
    ; produce
    for _index, v in _array {
        _cache := _func.Call({"k":_index, "v":v, "cache":_cache}, _params*)
    }
    return _cache                                               ;返回处理过的累积值
}

; list_no_dup(_array)
; 从指定数组中收集所有唯一项, 返回收集结果数组
list_no_dup(_array){
    _newArray   := []
    _valueCheck := ""

    Loop % _array.Length() {
        _valueCheck := Trim(_array[A_Index], " `t")             ; 获取源数组的每个元素
        
        if(_valueCheck != ""){                                  ; 如果当前元素值空, 则进行下一轮匹配
            if(! list_has_value(_newArray, _valueCheck)){       ; 如果匹配无, 则追加到新数组
                _newArray.push(_valueCheck)
            }
        }
    }
    return _newArray
}

; list_key_width(_array)
; 找出一维数组中最大的键字符宽度
; 统计数组键字符的最大宽度, 等宽格式化用
list_key_width(_array){
    _MaxKeyWidth:= 0
    _keyWidth   :=0
    for k,v in _array{
        _keyWidth := StrLen(k)
        if(_keyWidth>_MaxKeyWidth)
            _MaxKeyWidth := _keyWidth
    }
    return _MaxKeyWidth
}

; list_min_index(_array) 找出数组中最小值的索引
list_min_index(_array){
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

; list_sort(_array, _ByAsc:=true) 对数组进行升序排序
list_sort(_array, _ByAsc:=true){
    _newArr := []
    _minIndex := 0
    ;-----------------
    _i:= 1
    if(_ByAsc)      ;升序
        loop % _array.Length() {
            _minIndex:= list_min_index(_array)
            list_push(_newArr, list_pop_index(_array, _minIndex))
        }
    else
        loop % _array.Length() {
            _minIndex:= list_min_index(_array)
            list_push_first(_newArr, list_pop_index(_array, _minIndex))
        }
    return _newArr
}

; list_collect(_array, _one_dimensional:= true, _indexOrKey:=0)
; 收集数组元素, 并且去除重复内容
; _one_dimensional 是否一维数组
; 非一维数组, 例如
; [ [1, [12,13] ],  [2, [22, 23]]]
; [ {"作品名":"...", "tag":["..", ".."]}, {"作品名":"...", "tag":["..", ".."]}]
list_collect(_array, _valueField:="", _one_dimensional:=False){
    _newArr := []
    if(_one_dimensional){                   ; 如果是一维数组
        _newArr := list_no_dup(_array)      ; 清除重复
    }
    else{                                   ; 非一维数组
        Loop % _array.Length() {            ; 当前层是数组
            _newArr.push(_array[A_Index][_valueField]*)     ; 压入指定键的值
        }
        _newArr := list_no_dup(_newArr)     ; 清除重复
    }
    return _newArr
}

; list_associate(_arrayTag, _arrayInfo, _keyField, _valueField)
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
list_associate(_arrayTag, _arrayInfo, _keyField, _valueField:="_self"){
    _assocArr := {}
    for _tagIndex, _tag in _arrayTag {                                            ; tag数组的每个tag标签
        _arrCollect  := []
        Loop % _arrayInfo.Length()                                                ; 每个info数组项
            if(list_get_index(_arrayInfo[A_Index][_keyField], _tag)>0)                ; 检测当前info数组项,key字段是否包含指定tag
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

; ----------------------------------------------------------
; 数组打印和关联数组测试
; ----------------------------------------------------------
; _arrayInfo := [{"姓名": "周星驰", "tag": ["导演", "演员", "制片人", "男性", "香港人"]}
;               ,{"姓名": "陈道明", "tag": ["演员", "制片人", "男性", "60后"]}
;               ,{"姓名": "孙俪", "tag": ["演员", "女性", "江苏人"]}
;               ,{"姓名": "赵薇", "tag": ["演员", "女性", "导演", "投资商"]}]
; _arrayTag := ["导演", "演员", "制片人", "男性", "女性"]
; _tags := list_collect(_arrayInfo, "tag")
; _arrayResult := list_associate(_arrayTag, _arrayInfo, "tag", "姓名")
; list_print(_arrayResult)
; _arrayResult := list_associate(_tags, _arrayInfo, "tag", "姓名")
; list_print(_arrayResult)

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
; msgbox % dict_has_value(allowResizeWins, "GomPlayer1.x")

; ----------------------------------------------------------
; list_map list_reduce 数组批处理测试
; ----------------------------------------------------------
; ;list_reduce test
; array1 := [1, 2, 3]
; array2 := []

; _test_乘测试(x){
;     return x["v"]*2
; }

; _test_累加测试(x){
;     return x["cache"] + x["v"]
; }

; msgbox % list_reduce(array1, 0, "_test_累加测试")

; array2 := list_map(array1, "_test_乘测试")
; list_print(array1)
; list_print(array2)


; ----------------------------------------------------------
; 以下是测试内容, 测试列表对象
; ----------------------------------------------------------

; CList 列表类
class CList
{
    __New(_args*)
    {
        this.list := _args
    }

    ; ----------------------------------------------------------
    ; public obj functions
    ; ----------------------------------------------------------
    ; CList对象生成字符串
    tostr(_indent:=true, _level:=0, _indentStr:="    ", _endStr:="`n"){
        return CList._str(this.list, _indent, _level, _indentStr, _endStr)
    }


    ; print(_w:=800, _h:=600)
    ; ListVars调试界面显示
    print(_w:=800, _h:=600){
        ; 控制台显示
        _text_out := this.str()
        _text_out := StrReplace(_text_out, "`n", "`r`n") ; for display purposes only
        ListVars
        WinWaitActive ahk_class AutoHotkey
        WinMove, ahk_class AutoHotkey, , , , %_w%, %_h%
        ControlSetText Edit1, %_text_out%`r`n
        WinWaitClose
    }

    ; CListObj.join(_sep)
    join(_sep) {
        _ret := ""

        Loop % this.Length() {
            _ret .= this.list[A_Index] . _sep
        }

        return SubStr(_ret, 1, -StrLen(_sep))
    }

    ; CListObj.length()
    length(){
        return this.list.Length()
    }

    ; CListObj.push(_args*)
    push(_args*){
        this.list.push(_args*)
    }

    ; CListObj.push_first(_args*)
    push_first(_value*){
        return this.list.InsertAt(1, _value*)
    }

    ; CListObj.pop()
    pop(){
        return this.list.pop()
    }    

    ; CListObj.insert(_pos, values*)
    insert(_pos, values*){
        this.list.InsertAt(_pos, values*)
    }

    ; CListObj.remove(_pos, _length:=1)
    remove(_pos, _length:=1){
        return this.list.RemoveAt(_pos, _length)
    }


    ; CListObj.sort(_ByAsc:=true) 对数组进行排序,默认升序
    sort(_ByAsc:=true){
        _newArr := []
        _minIndex := 0
        ;-----------------
        loop % this.Length() {
            _minIndex := this.min_index()
            if(_ByAsc){      ;升序
                _newArr.Push(this.pop_index(_minIndex))
            }
            Else{            ;降序
                _newArr.InsertAt(1, this.pop_index(_minIndex))
            }
        }
        this.list := _newArr
    }


    ; CListObj.min_index() 找出数组中最小值的索引
    min_index(){
        _min:= this.list[1]
        _min_index:= 1
        ;-----------------
        _i:= 2
        _end:= this.Length()
        while(_i <= _end){
            if(this.list[_i] < _min){
                _min := this.list[_i]
                _min_index := _i
            }
            _i++
        }
        ;-----------------
        return _min_index
    }


    ; CListObj.pop_index(_index)     弹出指定项
    pop_index(_index)
    {
        if(_index <1 || _index>this.Length()){
            throw Exception("CListObj.pop_index(_index), _index数值超过数组长度范围")
            return ""
        }
        _item := this.list[_index]
        this.Remove(_index)
        return _item
    }


    ; ----------------------------------------------------------
    ; static functions
    ; ----------------------------------------------------------

    ; _str()      可以识别数组或字典, 并分别做处理
    ; 将指定数组格式化, 返回字符串,
    ; 遍历内部的所有成员数组和字典
    ; _array: 数组参数, 递归一定不能使用byRef;
    ; _indent: 是否缩进, 默认缩进;
    ; _level: 递推的层数;
    ; _indentStr: 缩进字符;
    ; _endStr: 行结束字符;
    _str(_array, _indent:=true, _level:=0, _indentStr:="    ", _endStr:="`n")
    {
        _result:= ""
        _indent_str := ""
        if(_indent)
            loop %_level%
                _indent_str .= _indentStr
        _maxKeyWidth := list_key_width(_array)                ; 统计数组键字符的最大宽度, 等宽格式化用
        for k, v in _array {
            if(!IsObject(v)){   ; 如果非对象或一维数组
                _result .= Format("{1} : {2}"
                                , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                                , v . _endStr)
            }
            else{
                if(is_list(v)){ ; 如果是多维数组
                    _result .= Format("{1} : {2}{3}{4}"
                                    , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                                    , "[" . _endStr
                                    , list_to_str(v, _indent, _level+1, _indentStr, _endStr)
                                    , _indent_str . "]" . _endStr)
                }
                else{           ; 如果是字典
                    _result .= Format("{1} : {2}{3}{4}"
                                    , _indent_str . str_fill(k, _maxKeyWidth, " ", "right")
                                    , "{" . _endStr
                                    , list_to_str(v, _indent, _level+1, _indentStr, _endStr)
                                    , _indent_str . "}" . _endStr)
                }
            }
        }
        return _result
    }


    

}

; 生成器 - 返回CList对象
list(_args*){
    _obj := new CList(_args*)
    ;_obj.list := _args
    Return _obj
}

; list_swap(p_list, p_i, p_j) 交换数组中,指定两单元的内容
list_swap(p_list, p_i, p_j){
    
    if(p_i == p_j){
        Return
    }

    _tmp        := p_list[p_i]
    p_list[p_i] := p_list[p_j]
    p_list[p_j] := _tmp

}

; 快速排序算法 list_quick_sort(p_list, p_by_asc:=true) 返回排序后的新数组
list_quick_sort(p_list, p_by_asc:=true) {
    
    if(p_list.Length()<2){
        Return p_list
    }
    else{
        _pivot   := p_list[1]
        _less    := []
        _greater := []

        _i       := 2
        _length  := p_list.Length()

        while(_i <= _length){

            if(p_list[_i] <= _pivot){
                _less.push(p_list[_i])
            }
            else{
                _greater.push(p_list[_i])
            }

            _i += 1
        }

        if(p_by_asc){
            Return list_splice(list_quick_sort(_less, p_by_asc)
                                , _pivot
                                , list_quick_sort(_greater, p_by_asc))
        }
        else{
            Return list_splice(list_quick_sort(_greater, p_by_asc)
                                , _pivot
                                , list_quick_sort(_less, p_by_asc))
        }
        
    }

}



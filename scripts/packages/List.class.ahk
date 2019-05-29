; ==========================================================
; 数组类 List.class.ahk
;
; 作者: tom
;
; 修改时间: 2019-02-01 14:52:18
; ==========================================================

; ----------------------------------------------------------
; test 类测试驱动
; ----------------------------------------------------------
;log := "[测试驱动]"
;array1 := [1, 2, 4]
;array2 := ["one", "two", "three"]
;
;list1 := new List(array1)
;
;list1.item(3, 3)
;log .= test("item set"
;            , "3"
;            , list1.item(3))
;
;log .= test("item get"
;            , "1 2 3"
;            , list1.join(" "))
;list1.item(3, 4)
;
;list1.insert(3, 3)
;log .= test("insert"
;            , "1 2 3 4"
;            , list1.join(" "))
;
;list1.push(5, 6)
;log .= test("push"
;            , "1 2 3 4 5 6"
;            , list1.join(" "))
;
;list1.pushFirst(7, 8)
;log .= test("pushFirst"
;            , "7 8 1 2 3 4 5 6"
;            , list1.join(" "))
;
;list1.sortByAsc()
;log .= test("sortByAsc"
;            , "1 2 3 4 5 6 7 8"
;            , list1.join(" "))
;
;list1.append(9, 10)
;log .= test("append"
;            , "1 2 3 4 5 6 7 8 9 10"
;            , list1.join(" "))
;
;list1.pop()
;log .= test("pop"
;            , "1 2 3 4 5 6 7 8 9"
;            , list1.join(" "))
;
;list1.popFirst()
;log .= test("popFirst"
;            , "2 3 4 5 6 7 8 9"
;            , list1.join(" "))
;
;list1.pushFirst(1)
;log .= test("pushFirst"
;            , "1 2 3 4 5 6 7 8 9"
;            , list1.join(" "))
;
;log .= test("length()"
;            , "9"
;            , list1.length())
;
;list1.clear()()
;log .= test("clear()"
;            , ""
;            , list1.join(" "))
;
;list1.push(1,1,2,2,3,3)
;list1._list := list1.collectOnlyItem()
;log .= test("collectOnlyItem"
;            , "1 2 3"
;            , list1.join(" "))
;
;MsgBox % log
;; ----------------------------------------------------------
;test(_标题, _预期结果, _实际结果){
;    if(_预期结果 != _实际结果)
;        return format("`n{1} - [{2}] {3:30.30s}  [结果] {4:s}", "X", _标题, _预期结果, _实际结果)
;    else
;        return format("`n{1} - [{2}] {3:30.30s}  [结果] {4:s}", "O", _标题, _预期结果, _实际结果)
;}
; -------------------------测试结束-------------------------

; ----------------------------------------------------------
; 类定义部分    数组类
; ----------------------------------------------------------
class List {
    __New(_array)
    {
        this._list := _array
    }

    ; ----------------------------------------------------------
    ; public 修改数组的相关函数
    ; ----------------------------------------------------------
    ; public 取数组项目, 或赋值
    item(_index, _value:=""){
        if(_value != ""){
            ; set
            this._list[_index] := _value
        }
        ; get
        return this._list[_index]
    }

    ; [数组函数]public insert(_index, _values1, _values2, ...)
    ; 追加新元素在指定索引位置;
    insert(_index, _values*)
    {
        this._list.InsertAt(_index, _values*)
    }

    ; [数组函数]public push(_values1, _values2, ...)
    ; 默认加入元素在末尾;
    push(_values*)
    {
        return this._list.Push(_values*)
    }

    ; 加入元素在首位;
    pushFirst(_values*){
        return this.insert(1, _values*)
    }

    ; [数组函数]public append(_values1, _values2, ...)
    ; 追加新元素在最后;
    append(_values*)
    {
        this.Push(_values*)
    }

    ; [数组函数]static pop()
    ; 默认弹出最后一项
    pop()
    {
        ; 数组空异常处理
        if(this.length()<1){
            throw Exception("数组为空, 不能弹出数组元素", -1)
            return ""
        }
        return this._list.Pop()
    }

    ; 弹出第一项
    popFirst(){
        ; 数组空异常处理
        if(this.length()<1){
            throw Exception("数组为空, 不能弹出数组元素", -1)
            return ""
        }
        return this._list.RemoveAt(1)
    }

    ; [数组函数]public object popIndex(_index)
    ; 默认弹出指定项
    popIndex(_index)
    {
        if(_index <1 || _index>this.length()){
            throw Exception("函数popIndex(_index), _index数值超过数组长度范围")
            return ""
        }
        _result := this._list[_index]
        this._list.remove(_index)
        return _result
    }

    ; [数组函数]public object remove(_index)
    ; 返回 _index 对应的值
    remove(_index, _length:=1)
    {
        return this._list.RemoveAt(_index, _length)
    }

    ; [数组函数]public clear()
    ; 清空数组
    clear()
    {
        this._list := []
    }

    ; [反转数组函数]public reverse()
    reverse(){
        _i := 1
        _max := this.length()
        _HalfLength := _max // 2
        _tmp := ""
        loop % _HalfLength {
            ; 两头交换
            _tmp := this._list[_i]
            this._list[_i] := this._list[_max]
            this._list[_max] := _tmp
            ; 计数
            if(_i != _max){
                _i++
                _max--
            }
        }
    }

    ; ----------------------------------------------------------
    ; public 非修改数组的相关函数
    ; ----------------------------------------------------------
    ; 返回数组长度
    length(){
        return this._list.Length()
    }

    ; [拼接数组元素输出字符串] static string join()
    ; _separator 拼接间隔字符
    ; _cleanSeparator, 清洗原字符串中包含的间隔符, 默认清洗
    ; _replaceSeparator, 清洗时, 用指定字符替换间隔符
    join(_separator:=" ", _cleanSeparator:=true, _replaceSeparator:="_"){
        _result := ""
        for k, v in this._list {
            if(_cleanSeparator){
                _result .= StrReplace(trim(v, " `t"), _separator, _replaceSeparator) . _separator
            }
            else{
                _result .= v . _separator
            }
        }
        return SubStr(_result, 1, -StrLen(_separator))
    }

    ; [数组函数]public toStr()
    ; 将指定数组格式化, 返回字符串,
    ; 遍历内部的所有成员数组和字典
    ; _indent: 是否缩进, 默认缩进;
    ; _level: 递推的层数;
    ; _indentStr: 缩进字符;
    ; _endStr: 行结束字符;
    toStr(_indent:=true, _level:=0, _indentStr:="    ", _endStr:="`n")
    {
        _result:= ""
        _indent_str := ""
        if(_indent)
            loop %_level%
                _indent_str .= _indentStr
        for k, v in this._list {
            if(!IsObject(v)){
                _result .= _indent_str . k . ": " . v . _endStr
            }
            else{
                _result .= _indent_str . k . ": " . _endStr
                _result .= this.toStr(v, _indent, _level+1, _indentStr, _endStr)
            }
        }
        return _result
    }

    ; public public map(_funcName, _params*)
    ; 根据提供的函数对指定列表每个元素做处理
    ; _funcName:    函数名字符串, 函数的第一值参数必须是数组value
    ; _params*:     函数其他参数
    ; return:       返回处理过的数组引用
    map(_funcName, _params*){
        _func := Func(_funcName)                        ; 获得函数对象
        for k, v in this._list
            _list[k] := _func.Call(v, _params*)
        return _list                                    ;返回处理过的数组引用
    }

    ; public public reduce() 函数会对参数序列中元素进行累积, 比如累加, 阶乘..
    ; _funcName:    函数名字符串, 函数的前两个参数必须是数组value
    ; _params*:     函数其他参数
    ; return:       返回处理过的累积值
    reduce(_funcName, _params*){
        _func := Func(_funcName)                        ; 获得函数对象
        _result =                                       ; 存储中间值和结果
        _count  := 1                                    ; 循环计数器
        ; produce
        for k, v in this._list {
            if(_count == 1){
                _result := v
                _count++
            }
            else{
                _result := _func.Call(_result, v, _params*)
            }
        }
        return _result                                  ;返回处理过的累积值
    }

    ; 从指定数组中收集所有唯一项, 返回收集结果数组
    collectOnlyItem(){
        _resultlist := []
        _valueCheck := 0
        _notExist   := true
        ; -----------------------
        Loop % this.length() {
            _valueCheck := Trim(this._list[A_Index], " `t")
            _notExist   := true
            ; -----------------------
            For index, value in _resultlist {
                if(value == _valueCheck){
                    _notExist:= false
                    break
                }
            }
            ; -----------------------
            if(_notExist && _valueCheck!="")
                _resultlist.push(_valueCheck)
        }
        return _resultlist
    }

    ; public int minIndex()
    ; 找出数组中最小值的索引
    ; 为sortByAsc()专用的函数
    minIndex(){
        _min:= this._list[1]
        _min_index:= 1
        ;-----------------
        _i:= 2
        _end:= this.length()
        while(_i <= _end){
            if(this._list[_i]<_min){
                _min := this._list[_i]
                _min_index := _i
            }
            _i++
        }
        ;-----------------
        return _min_index
    }

    ; public sortByAsc() 对数组进行升序排序
    ; 依赖popIndex
    sortByAsc(){
        _newArr := []
        _result := false
        ;-----------------
        loop % this.length() {
            _newArr.push(this.popIndex(this.minIndex()))
        }
        this._list := _newArr
        _result := true
        return _result
    }

    ; ----------------------------------------------------------
    ; 静态函数 - 特殊需求
    ; ----------------------------------------------------------
    ; [数组函数]static print()
    print(_array, _separator:=" ", _cleanSeparator:=true, _replaceSeparator:="_"){
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
    ; class List end
}





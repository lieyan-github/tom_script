; ==========================================================
; Test.class.ahk 单元测试类
;
; 文档作者: tom
;
; 修改时间: 2021-03-30 21:00:52
; ==========================================================
; 使用说明:
; 0. 单元测试初始化:     test_init()
; 1. 加入单元测试:       test_add(_测试描述, _实际结果, _期望结果, _比较类型:="==") 默认比较类型是"==", 区分大小写
; 2. 运行单元测试:       test_run()
; 3. 显示批量测试结果


; 简化操作
; ----------------------------------------------------------
test_init(){
    Test.me().init()
}

; test_对比测试(ByRef _对比测试结果, _实际结果, _期望结果, _比较类型:="==") 返回是否识别比较类型
test_对比测试(ByRef _对比测试结果, _实际结果, _期望结果, _比较类型:="=="){
    
    _对比测试结果   := False


    if(_比较类型 = "=="){
        _对比测试结果 := _实际结果 == _期望结果
        Return True
    }

    if(_比较类型 = "="){
        _对比测试结果 := _实际结果 = _期望结果
        Return True
    }

    ; 正则匹配
    if(_比较类型 = "~="){
        _对比测试结果 := _实际结果 ~= _期望结果
        Return True
    }    

    if(_比较类型 = ">"){
        _对比测试结果 := _实际结果 > _期望结果
        Return True
    }

    if(_比较类型 = ">="){
        _对比测试结果 := _实际结果 >= _期望结果
        Return True
    }

    if(_比较类型 = "<"){
        _对比测试结果 := _实际结果 < _期望结果
        Return True
    }

    if(_比较类型 = "<="){
        _对比测试结果 := _实际结果 <= _期望结果
        Return True
    }

    if(_比较类型 = "!="){
        _对比测试结果 := _实际结果 != _期望结果
        Return True
    }

    ; end 不能识别比较类型, 返回false
    Return False
}

; test_add(_测试描述, _实际结果, _期望结果, _比较类型:="==") 默认比较类型是"==", 区分大小写
test_add(_测试描述, _实际结果, _期望结果, _比较类型:="=="){

    _对比测试结果   := False

    ; 如果可识别比较类型, 则记录比较结果
    if(test_对比测试(_对比测试结果, _实际结果, _期望结果, _比较类型)){

        Test.me().add(_对比测试结果, _测试描述, _实际结果, _期望结果, _比较类型)
        
    }
    else{
        MsgBox, 未识别的比较类型, `n`ntest_add(_测试描述, _实际结果, _期望结果, _比较类型:="==") #84行
    }
    
}

test_run(){
    Test.me().run()
}

; 同test_add一样 ; test_add(_测试描述, _实际结果, _期望结果, _比较类型:="==") 默认比较类型是"==", 区分大小写
assert(测试描述, _实际结果, _期望结果, _比较类型:="=="){
    test_add(测试描述, _实际结果, _期望结果, _比较类型)
}
; ----------------------------------------------------------

; public class Test
class Test {
    ; public 测试结果
    validList := []
    errorList := []
    ; static instance var 单件模式
    static uniqueInstance := "null"
; ----------------------------------------------------------
; Test 单元测试主程序
; ----------------------------------------------------------
    ; public void test() 单元测试主程序
    run(){
        ; end 显示测试单元结果
        this.showResult()
        this.clear()
    }

; ----------------------------------------------------------
; Test 公共测试框架, 由外部调用以下静态函数
; ----------------------------------------------------------
    ; public static method getInstance() 单件模式
    getInstance()
    {
        if(Test.uniqueInstance == "null")
        {
            Test.uniqueInstance := new Test()
        }
        return Test.uniqueInstance
    }

    ; public static Test me()
    me(){
        return Test.getInstance()
    }

; ----------------------------------------------------------
; Test 对象辅助操作
; ----------------------------------------------------------
    init(){
        this.clear()
    }

    ; 记录测试结果
    add(_测试表达式结果, _测试描述, _实际结果, _期望结果, _比较类型){
        if(_测试表达式结果)
            list_push(this.validList, [_测试描述, _实际结果, _期望结果, _比较类型])
        else
            list_push(this.errorList, [_测试描述, _实际结果, _期望结果, _比较类型])
    }

    ; public string toStr()
    toStr(){
        _str:= ""
        _str.= "; ==========================================================`n"
        _str.= "; 单元测试`n"
        _str.= "; ==========================================================`n"
        _str.= "; error list -- [" . this.errorList.MaxIndex() . "]`n"
        _str.= "; ==========================================================`n"
        
        Loop % this.errorList.MaxIndex(){            

            _str .= Format("{1}. {2} `n【比较类型】{3} `n【实际结果】{4} `n【正确结果】{5}`n`n`n"
                        , A_Index
                        , this.errorList[A_Index][1]
                        , this.errorList[A_Index][4]
                        , this.errorList[A_Index][2]
                        , this.errorList[A_Index][3])

        }

        _str .= "`n`n`n"
        _str .= "; valid list -- [" . this.validList.MaxIndex() . "]`n"
        
        _str .= "; ==========================================================`n"
        
        Loop % this.validList.MaxIndex() {

            _str .= A_Index . ". " . this.validList[A_Index][1] . "`n"

        }
        return _str
    }

    ; public void clear()
    clear(){
        list_clear(this.validList)
        list_clear(this.errorList)
    }

    ; public void show()
    showResult(){
        show_debug(this.toStr())
    }
}


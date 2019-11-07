; ==========================================================
; Test.class.ahk 单元测试类
;
; 文档作者: tom
;
; 修改时间: 2019-06-30 20:21:24
; ==========================================================
; 使用说明:
; 0. 单元测试初始化:     test_init()
; 1. 加入单元测试:       test_add(_测试描述, _测试表达式)
; 2. 运行单元测试:       test_run()
; 3. 显示批量测试结果


; 简化操作
; ----------------------------------------------------------
test_init(){
    Test.me().init()
}

test_add(_测试描述, _测试表达式){
    Test.me().add(_测试描述, _测试表达式)
}

test_run(){
    Test.me().run()
}
; 与test_add一样
assert(_测试描述, _测试表达式){
    Test.me().add(_测试表达式, _测试描述)
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
    add(_测试表达式结果, _测试描述){
        if(_测试表达式结果)
            arrayPush(this.validList, _测试描述)
        else
            arrayPush(this.errorList, _测试描述)
    }

    ; public string toStr()
    toStr(){
        _str:= ""
        _str.= "; ==========================================================`n"
        _str.= "; 单元测试`n"
        _str.= "; ==========================================================`n"
        _str.= "; error list -- [" . this.errorList.MaxIndex() . "]`n"
        _str.= "; ==========================================================`n"
        Loop % this.errorList.MaxIndex()
            _str .= A_Index . ". " this.errorList[A_Index] . "`n"
        _str.= "`n`n`n"
        _str.= "; valid list -- [" . this.validList.MaxIndex() . "]`n"
        _str.= "; ==========================================================`n"
        Loop % this.validList.MaxIndex()
            _str .= A_Index . ". " this.validList[A_Index] . "`n"
        return _str
    }

    ; public void clear()
    clear(){
        arrayClear(this.validList)
        arrayClear(this.errorList)
    }

    ; public void show()
    showResult(){
        show_debug(this.toStr())
    }
}


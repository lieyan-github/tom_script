; ==========================================================
; Test.class.ahk 单元测试类
;
; 文档作者: 烈焰
;
; 修改时间: 2016-06-05 01:02:50
; ==========================================================

; public class Test
class Test {
    ; public 测试清单
    testList := []
    ; public 测试结果
    testResultList := []
    ; static instance var 单件模式
    static uniqueInstance := "null"
; ----------------------------------------------------------
; Test 单元测试主程序
; ----------------------------------------------------------
    ; public void test() 单元测试主程序
    test(){
        ; init()
        this.clear()
        ; add test
        ; ----------------------------------------------------------
        this.add(TestTemplate.test())
        this.add(Path.test())
        this.add(Av.test())
        this.add(Sys.test())
        ; ----------------------------------------------------------
        ; start test
        this.runTestList()
        ; end 显示测试单元结果
        this.showResult()
        this.saveResult()
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

    ; public static void assertEquals
    eq(_testName, _trueResult, _execResult, _tag:="分组1"){
        boolResult := false
        if(_trueResult == _execResult)
            boolResult := true
        Test.me().recordResult(Test.commentResult(boolResult), _tag, _testName)
    }

    ; public static void match
    match(_testName, _trueRegexp, _execResult, _tag:="分组1"){
        boolResult := false
        if(RegExMatch(_execResult, _trueRegexp) >0 )
            boolResult := true
        Test.me().recordResult(Test.commentResult(boolResult), _tag, _testName)
    }

; ----------------------------------------------------------
; Test 对象辅助操作
; ----------------------------------------------------------
    ; public void add(_func)
    add(_func){
        arrayPush(this.testList, _func)
    }

    ; public void runTestList()
    runTestList(){
        Loop % this.testList.MaxIndex(){
            this.testList[A_Index].call()
        }
    }

    ; public void recordResult() 记录测试结果
    recordResult(_testResult*){
        arrayPush(this.testResultList, _testResult)
    }

    ; public string toStr()
    toStr(){
        _str:= ""
        Loop % this.testResultList.MaxIndex()
            _str .= this.testResultList[A_Index][1] . "[" . this.testResultList[A_Index][2] . "] " . this.testResultList[A_Index][3] . "`n"
        return _str
    }

    ; public void clear()
    clear(){
        arrayClear(this.testList)
        arrayClear(this.testResultList)
    }

    ; public void show()
    showResult(){
        show_text(this.toStr(), "单元测试结果", 800, 600)
    }

    ; public void saveResult()
    saveResult(){
        Clipboarder.push(this.toStr())
    }

    ; public string commentResult 对布尔结果进行描述转换
    commentResult(_boolResult){
        if(_boolResult)
            return "   Ok - "
        else
            return "***Er - "
    }
}

; ----------------------------------------------------------
; 测试实例 1
; ----------------------------------------------------------
; public class TestTemplate
class TestTemplate {
    ; static test
    test(){
        TestTemplate.oneVariable()
        TestTemplate.differentValue()
    }

    ; static oneVariable
    oneVariable(){
        template := new Template("Hello, ${name}")
        template.set("name", "Reader")
        Test.eq(A_ThisFunc, "Hello, Reader", template.evaluate())
    }

    ; static differentValue
    differentValue(){
        template := new Template("Hello, ${name}")
        template.set("name", "someone else")
        Test.eq(A_ThisFunc, "Hello, someone else", template.evaluate())
    }
}

; public class Template
class Template {
    ; public new
    __new(_templateText){
        this.templateText := _templateText
    }
    ; public set()
    set(_variable, _value){
        this.variableValue := _value
    }
    ; public string evaluate()
    evaluate(){
        return "Hello, " . this.variableValue
    }
}




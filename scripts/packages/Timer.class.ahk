; ==========================================================
; 计时器类 Timer
; 
; 作者: tom
; 
; 修改时间: 2019-01-21 14:46:36
; ==========================================================


; ----------------------------------------------------------
; 测试用例
; ----------------------------------------------------------
;#Persistent
;#SingleInstance Force
;showTimer("这是个测试")
;showTimer(_msg, _time:=5000)
;{
;    _obj := new Timer_showmsg(_msg, _time)
;    _obj.start()
;    _obj := ""
;}

; ----------------------------------------------------------
; 计时器基类 Timer
; 子类只需用需要的操作, 覆盖这三个方法
;   start_todo()
;   stop_todo()
;   tick_todo()
; ----------------------------------------------------------
class Timer {
    __New(_totalTime:=3000) {
        this.totalTime      := _totalTime           ; 计时器预定总时长
        this.interval       := 1000                 ; 计时器间隔
        this.count          := 0                    ; 计数次数
        this.countTime      := 0                    ; 计数时间
        this.startTime      := ""                   ; 记录start开始时间
        this.tickTime       := ""                   ; 记录tick当前时间
        this.timer := ObjBindMethod(this, "tick")   ; Tick() 有一个隐式参数 "this" 引用一个对象;
                                                    ; 所以,我们需要创建一个封装 "this" 和 Tick 方法的函数来调用:
    }
    ; 计数器核心框架 start stop tick(周期性运行)
    ; ----------------------------------------------------------
    start() {
        this.startTime      := this.__now()         ; 记录计时器开始时间
        _timer              := this.timer           ; 已知限制: SetTimer 需要一个纯变量引用.
        SetTimer % _timer, % this.interval
        ; todo...
        this.start_todo()
    }
    stop() {
        _timer := this.timer                        ; 在此之前传递一个相同的对象来关闭计时器:
        SetTimer % _timer, Off
        ; todo...
        this.stop_todo()
        this.__reset()                              ; 计数器重置
    }
    tick() {                                        ; 计时器周期性运行方法:
        this.__count()                              ; 周期计数
        ; todo...
        this.tick_todo()
        ; todo end
        if(this.__isOvertime())                     ; 如果到达结束时间, 则停止计数器
            this.stop()
    }
    ; ----------------------------------------------------------
    __isOvertime(){                                 ; 计数器是否到达结束时间
        if(this.countTime >= this.totalTime)
            return true
        else
            return false
    }
    __count(){                                      ; 周期计数 运行时间计数
        ++this.count
        this.countTime += this.interval
    }
    __reset(){                                      ; 重置计数器
        this.count        := 0
        this.countTime    := 0
    }
    __now(){                                        ; 获取当前时间字符串
        FormatTime, _result,, yyyy-MM-dd HH:mm:ss
        return _result
    }
    ; ----------------------------------------------------------
    ; 子类自定义覆盖内容开始
    ; ----------------------------------------------------------
    start_todo() {
        ; todo
        ToolTip % format("Timer类的start`ncount = {1}`n{2}", this.count, this.__now())
    }
    stop_todo() {
        ; todo
        ToolTip    ; 清除显示内容
    }
    tick_todo() {
        ; todo
        ToolTip % format("Timer类的tick`ncount = {1}`n{2}", this.count, this.__now())
    }
}

; ----------------------------------------------------------
; Timer_showmsg 计时提示器类
; 子类只需用需要的操作, 覆盖这三个方法
;   start_todo()
;   stop_todo()
;   tick_todo()
; 需要显示的信息用this.msg设置
; ----------------------------------------------------------
class Timer_showmsg extends Timer {
    __new(_inmsg, _totalTime:=5000) {
        base.__new(_totalTime)
        this.progressBar    := ""                   ; 进度条
        this.progressStr    := "="                  ; 进度条字符
        this.msg            := _inmsg               ; 要显示的提示信息内容
        this.fullMsg        := ""                   ; 包含进度条的全部信息内容
    }
    ; ----------------------------------------------------------
    ; 子类自定义覆盖内容开始
    ; ----------------------------------------------------------
    start_todo() {
        this.updateMsg()
        this.showMsg()
    }
    stop_todo() {
        ToolTip                                     ;清除显示内容
    }
    tick_todo() {
        this.updateProgressBar()
        this.updateMsg()
        this.showMsg()
    }
    __reset(){
        base.__reset()
        this.resetProgressBar()
        this.msg := ""
        this.fullMsg := ""
    }
    ; ----------------------------------------------------------
    ; 附加功能函数
    ; ----------------------------------------------------------
    ; 清空进度条
    resetProgressBar(){
        this.progressBar := ""
    }
    ; 更新进度条
    updateProgressBar(){
        this.progressBar .= this.progressStr
    }
    ; 更新提示信息, 主要用来更新进度和倒计时
    updateMsg(){
        ; 实际操作
        this.fullMsg := format("{1}`n[{2}] {3:d}秒/{4:d} {5}"
            , this.msg
            , this.startTime
            , this.countTime/1000
            , this.totalTime/1000
            , this.progressBar)
    }
    ; 显示提示内容
    showMsg(){
        ToolTip % this.fullMsg
    }
}
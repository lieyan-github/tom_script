﻿; ==========================================================
;
; [全局] global_按键绑定.ahk
;
; 文档作者: tom
;
; 修改时间: 2021-03-10 01:43:43
;
; ==========================================================


; ----------------------------------------------------------
; [按键绑定规则] 
; ----------------------------------------------------------
; 绑定按键与功能函数, 组合键排序规则
;   ctrl > shift > alt > win > 普通键
;   caps > 普通键
;   Fn > 数字 > 字母 > 符号 > 功能键 > 特殊键
;
; ----------------------------------------------------------
; [keyPress_event] 热键绑定事件
; ----------------------------------------------------------
; 绑定按键_函数命名_功能键简写约定:
; ctrl: c_ | shift: s_ | alt: a_ | win: w_
;
; 功能键一律小写加下换线
; 如caps键: caps_ 
; ----------------------------------------------------------



; ==========================================================
; 临时使用快捷键
; ==========================================================

^+#f::c_s_w_f()



; ==========================================================
; 全局固定快捷键
; ==========================================================
; [ 常用功能设置]
; ----------------------------------------------------------

;$!`::打开音速启动()
$^!`::打开音速启动()   

^+#del::批量关闭进程(JsonFile.read(Config.upath("批量关闭程序")))


; ==========================================================
; [全局]win/caps + F1-F12 F快捷键        打开特殊常用操作
; ==========================================================
#f1::web_购物()
#f2::web_下载()
#f3::web_it()
#f4::web_财经()    
#f5::script_reload()
#f6::run jupyter notebook
#f7::打开文件比较()    
#f8::打开文件操作菜单()
#f9::list_print(获取窗口信息(), 1024, 768)        ; 调试: 设置断点调试
#f10::打开正则表达式编辑器()                       ; 调试: 调试保留备用    - 打开正则表达式
#f11::打开windowspy()                           ;打开spy探针
#f12::_nop_()                                  ; 调试: 打开配置文件

; ----------------------------------------------------------
^#f1::打开ahk本地帮助()
^#f2::
^#f3::
^#f4::
^#f5::
^#f6::
^#f7::
^#f8::
^#f9::
^#f10::
^#f11::_nop_()
^#f12::运行单元测试()

; ----------------------------------------------------------
+#f1::临时测试1()
+#f2::临时测试2()
+#f3::临时测试3()
+#f4::临时测试4()
+#f5::临时测试5()
+#f6::
+#f7::
+#f8::
+#f9::
+#f10::
+#f11::
+#f12::_nop_()

; ----------------------------------------------------------
!#f1::
!#f2::
!#f3::
!#f4::
!#f5::
!#f6::
!#f7::
!#f8::
!#f9::
!#f10::
!#f11::
!#f12::_nop_()

; ----------------------------------------------------------
Capslock & f1::打开脚本主菜单()
Capslock & f2::打开脚本主目录()
Capslock & f3::_nop_()
Capslock & f4::Log.print()
Capslock & f5::
Capslock & f6::
Capslock & f7::
Capslock & f8::
Capslock & f9::
Capslock & f10::
Capslock & f11::
Capslock & f12::_nop_()


; ==========================================================
; [全局]win & 数字快捷键          打开常用操作
; ==========================================================
#1::打开文本编辑器()
#2::打开计算器()
#3::打开截图()
#4::打开ocr文字识别()
#5::打开制图工具()
#6::打开截图2()
#7::web_微博()
#8::_nop_()
#9::_nop_()
#0::打开路由器()

; ----------------------------------------------------------
^#1::
^#2::
^#3::
^#4::
^#5::
^#6::
^#7::
^#8::
^#9::
^#0::_nop_()

; ----------------------------------------------------------
+#1::复制到剪贴板数组(1)
+#2::复制到剪贴板数组(2)
+#3::复制到剪贴板数组(3)
+#4::复制到剪贴板数组(4)
+#5::复制到剪贴板数组(5)
+#6::复制到剪贴板数组(6)
+#7::
+#8::
+#9::
+#0::_nop_()

; ----------------------------------------------------------
!#1::
!#2::
!#3::
!#4::
!#5::
!#6::
!#7::
!#8::
!#9::
!#0::_nop_()

; ----------------------------------------------------------
Capslock & 1::粘贴来自剪贴板数组(1)
Capslock & 2::粘贴来自剪贴板数组(2)
Capslock & 3::粘贴来自剪贴板数组(3)
Capslock & 4::
Capslock & 5::
Capslock & 6::
Capslock & 7::
Capslock & 8::
Capslock & 9::
Capslock & 0::_nop_()


; ==========================================================
; [全局]win & 字母快捷键          打开常用操作
; ==========================================================
;#a::                   ; Windows快捷键 通知
;#b::
;#c::
;#d::                   ; Windows快捷键 桌面
;#e::                   ; Windows快捷键 资源管理器
#f::_nop_()
#g::_nop_()
;#h::                   ; Windows快捷键 听写功能
;#i::                   ; Windows快捷键 设置
#j::_nop_()
;#k::                   ; Windows快捷键 连接设备
;#l::                   ; Windows快捷键 锁定系统
;#m::                   ; Windows快捷键 最小化
#n::_nop_()
#o::_nop_()
;#p::                   ; Windows快捷键 投影
#q::打开搜索菜单()        ; Windows快捷键 搜索
;#r::                   ; Windows快捷键 运行
;#s::                   ; Windows快捷键 搜索
;#t::                   ; Windows快捷键 任务栏切换
;#u::                   ; Windows快捷键 设置-显示
;#v::                   ; Windows快捷键 剪贴板          
#w::_nop_()             ; Windows快捷键 截图和白板
;#x::                   ; Windows快捷键 左下角徽标-快捷系统菜单 等于右键单击徽标
#y::_nop_()
#z::_nop_()

; ----------------------------------------------------------
^#a::添加备注_av女优()
^#b::
^#c::_nop_()
^#d::解密字符串()
^#e::加密字符串()
^#f::
^#g::
^#h::
^#i::
^#j::
^#k::
^#l::
^#m::
^#n::
^#o::
^#p::_nop_()
^#q::c_w_q()
^#r::绑定_从文件名获取AV作品编号_重命名()
^#s::_nop_()
^#t::窗口置顶()
^#u::
^#v::
^#w::
^#x::
^#y::_nop_()
^#z::添加备注_av作品()

; ----------------------------------------------------------
+#a::tags默认备注_av女优()
+#b::
+#c::
+#d::
+#e::
+#f::
+#g::
+#h::
+#i::
+#j::
+#k::
+#l::
+#m::
+#n::
+#o::
+#p::
+#q::
+#r::
+#s::
+#t::
+#u::
+#v::
+#w::
+#x::
+#y::_nop_()
+#z::tags默认备注_av作品()

; ----------------------------------------------------------
!#a::
!#b::
!#c::
!#d::
!#e::_nop_()
!#f::a_w_f()
!#g::
!#h::
!#i::
!#j::
!#k::
!#l::
!#m::
!#n::
!#o::
!#p::
!#q::_nop_()
!#r::绑定_从文件名获取AV作品编号_重命名()
!#s::
!#t::
!#u::
!#v::
!#w::
!#x::
!#y::
!#z::_nop_()

; ----------------------------------------------------------
Capslock & a::
Capslock & b::
Capslock & c::
Capslock & d::
Capslock & e::
Capslock & f::
Capslock & g::
Capslock & h::
Capslock & i::
Capslock & j::
Capslock & k::
Capslock & l::
Capslock & m::
Capslock & n::
Capslock & o::
Capslock & p::
Capslock & q::
Capslock & r::
Capslock & s::
Capslock & t::
Capslock & u::
Capslock & v::
Capslock & w::
Capslock & x::
Capslock & y::
Capslock & z::_nop_()


; ==========================================================
; [全局]win & 键盘符号快捷键
; ==========================================================
#`::打开制图工具()
#-::代码段边界线(1)                 ; 代码段行间隔
#=::代码段边界线(2)                 ; 代码段行间隔加粗
#[::Clipboarder.wrap("[", "]")    ; 中括号包裹
#]::
#\::
#`;::_nop_()
#'::Clipboarder.wrap("""", """")                            ; 双引号包裹
#,::xml包裹选定文本()               ; xml包裹选定文本, 如<td>...</td>, 使用# C可以直接复制设置标签名
#.::_nop_()
#/::注释代码块(1,1,1)              ; 注释选定行并添加上下边界线 (清理连续空行)

; ----------------------------------------------------------
^#`::
^#-::
^#=::
^#[::
^#]::
^#\::_nop_()
^#;::
^#'::
^#,::
^#.::
^#/::_nop_()

; ----------------------------------------------------------
+#`::剪贴板数组_清空_复制()
+#-::设置代码段落标题()               ; 设置代码段落标题(将当前行全部内容设置为标题)
+#=::_nop_()
+#[::Clipboarder.wrap("{", "}")    ; 大括号包裹
+#]::
+#\::
+#;::
+#'::_nop_()
+#,::Clipboarder.wrap("<", ">")    ; <>包裹
+#.::_nop_()
+#/::取消注释代码块()                                        ; 取消注释代码块, 可以识别当前行是否被注释
; ----------------------------------------------------------
!#`::
!#-::
!#=::
!#[::
!#]::
!#\::
!#;::
!#'::
!#,::
!#.::_nop_()
!#/::注释代码块(1,1,0)              ; 注释选定行并添加上下边界线

; ----------------------------------------------------------
Capslock & `::粘贴来自剪贴板数组()   ;获取最新一个内容
Capslock & -::
Capslock & =::
Capslock & [::
Capslock & ]::
Capslock & \::
Capslock & `;::
Capslock & '::
Capslock & ,::
Capslock & .::
Capslock & /::_nop_()


; ==========================================================
; [全局]win & 功能键快捷键
; ==========================================================
#Esc::打开视频剪辑()
#Tab::
#Space::
#Backspace::_nop_()
#Enter::打开字符串文件()        ; 快速打开字符串文件, 根据选中的路径字符串
;
#Home::打开用户主目录()
#End::
#PgUp::
#PgDn::_nop_()
;
#Up::增大音量()
#Down::减小音量()
#Left::绑定_向左调整窗口()
#Right::绑定_向右调整窗口()
;
#Delete::
#Insert::
;
#Pause::
#PrintScreen::_nop_()

; ----------------------------------------------------------
^#Esc::_nop_()
^#Tab::c_w_tab()
^#Space::
^#Backspace::
^#Enter::_nop_()
;
^#Home::
^#End::
^#PgUp::
^#PgDn::
;
^#Up::
^#Down::
^#Left::
^#Right::_nop_()
;
^#Delete::从白名单删除窗口()
^#Insert::添加窗口到白名单()
;
^#Pause::
^#PrintScreen::_nop_()

; ----------------------------------------------------------
+#Esc::
+#Tab::
+#Space::
+#Backspace::_nop_()
+#Enter::打开字符串目录()       ; 快速打开字符串目录, 根据选中的路径字符串
;
+#Home::
+#End::
+#PgUp::
+#PgDn::_nop_()
;
+#Up::快捷操作_调整当前窗口大小("up")                         ; 快速纵向最大化
+#Down::快捷操作_调整当前窗口大小("down")                     ; 快速纵向缩小
+#Left::快捷操作_调整当前窗口大小("left")
+#Right::快捷操作_调整当前窗口大小("right")
;
+#Delete::
+#Insert::
;
+#Pause::
+#PrintScreen::_nop_()

; ----------------------------------------------------------
!#Esc::
!#Tab::
!#Space::
!#Backspace::
!#Enter::_nop_()
;
!#Home::
!#End::
!#PgUp::
!#PgDn::_nop_()
;
!#Up::
!#Down::
!#Left::
!#Right::_nop_()
;
!#Delete::
!#Insert::_nop_()
;
!#Pause::
!#PrintScreen::_nop_()

; ----------------------------------------------------------
Capslock & Esc::
Capslock & Tab::
Capslock & Space::
Capslock & Backspace::
Capslock & Enter::_nop_()
;
Capslock & Home::
Capslock & End::
Capslock & PgUp::
Capslock & PgDn::_nop_()
;
Capslock & Up::
Capslock & Down::
Capslock & Left::
Capslock & Right::_nop_()
;
Capslock & Delete::
Capslock & Insert::_nop_()
;
Capslock & Pause::
Capslock & PrintScreen::_nop_()


; ==========================================================
; [全局] win/caps + 鼠标快捷键
; ==========================================================
#LButton::绑定_向左调整窗口()
#RButton::绑定_向右调整窗口()
#MButton::绑定_切换窗口y轴大小()
#WheelUp::增大音量()
#WheelDown::减小音量()
#WheelLeft::
#WheelRight::
#XButton1::
#XButton2::_nop_()

; ----------------------------------------------------------
^#LButton::_nop_()
^#RButton::
^#MButton::
^#WheelUp::
^#WheelDown::
^#WheelLeft::
^#WheelRight::
^#XButton1::
^#XButton2::_nop_()

; ----------------------------------------------------------
+#LButton::
+#RButton::_nop_()
+#MButton::绑定_切换窗口x轴大小()
+#WheelUp::
+#WheelDown::
+#WheelLeft::
+#WheelRight::
+#XButton1::
+#XButton2::_nop_()

; ----------------------------------------------------------
!#LButton::_nop_()
!#RButton::
!#MButton::
!#WheelUp::
!#WheelDown::
!#WheelLeft::
!#WheelRight::
!#XButton1::
!#XButton2::_nop_()

; ----------------------------------------------------------
Capslock & LButton::绑定_向左调整窗口()
Capslock & RButton::绑定_向右调整窗口()
Capslock & MButton::绑定_切换窗口y轴大小()
Capslock & WheelUp::
Capslock & WheelDown::
Capslock & WheelLeft::
Capslock & WheelRight::
Capslock & XButton1::
Capslock & XButton2::_nop_()


; ==========================================================
; [全局] win/caps + 小键盘数字快捷键
; ==========================================================
#NumpadDot::快捷操作_移动当前窗口(".")              ; 移动窗口到右下角最小化
#Numpad0::_nop_()
#Numpad1::快捷操作_移动当前窗口_并调整大小(3)         ; 移到左下方
#Numpad2::快捷操作_移动当前窗口(2)                  ; 下移
#Numpad3::快捷操作_移动当前窗口_并调整大小(4)         ; 移到右下方
#Numpad4::快捷操作_移动当前窗口(4)                  ; 左移
#Numpad5::快捷操作_移动当前窗口(5)                  ; 自动移到屏幕正中
#Numpad6::快捷操作_移动当前窗口(6)                  ; 右移
#Numpad7::快捷操作_移动当前窗口_并调整大小(1)         ; 移到左上方
#Numpad8::快捷操作_移动当前窗口(8)                  ; 上移
#Numpad9::快捷操作_移动当前窗口_并调整大小(2)         ; 移到右上方
; Numpad + - * /
#NumpadMult::多窗口管理("平铺",1)                  ; 全部窗口平铺

; ----------------------------------------------------------
^#NumpadDot::
^#Numpad0::
^#Numpad1::_nop_()
^#Numpad2::快捷操作_调整当前窗口大小(2)             ; 纵向向下伸缩
^#Numpad3::_nop_()
^#Numpad4::快捷操作_调整当前窗口大小(4)             ; 横向缩小(向左)
^#Numpad5::_nop_()
^#Numpad6::快捷操作_调整当前窗口大小(6)             ; 横向扩大(向右)
^#Numpad7::_nop_()
^#Numpad8::快捷操作_调整当前窗口大小(8)             ; 纵向向上伸缩
^#Numpad9::_nop_()
; Numpad + - * /
^#NumpadMult::多窗口管理("平铺",-0.49)

; ----------------------------------------------------------
+#NumpadDot::
+#Numpad0::
+#Numpad1::
+#Numpad2::
+#Numpad3::
+#Numpad4::
+#Numpad5::
+#Numpad6::
+#Numpad7::
+#Numpad8::
+#Numpad9::_nop_()
; Numpad + - * /

; ----------------------------------------------------------
!#NumpadDot::
!#Numpad0::
!#Numpad1::
!#Numpad2::
!#Numpad3::
!#Numpad4::
!#Numpad5::
!#Numpad6::
!#Numpad7::
!#Numpad8::
!#Numpad9::_nop_()
; Numpad + - * /
!#NumpadMult::多窗口管理("平铺",0.49)

; ----------------------------------------------------------
Capslock & NumpadDot::
Capslock & Numpad0::
Capslock & Numpad1::
Capslock & Numpad2::
Capslock & Numpad3::
Capslock & Numpad4::
Capslock & Numpad5::
Capslock & Numpad6::
Capslock & Numpad7::
Capslock & Numpad8::
Capslock & Numpad9::_nop_()
; Numpad + - * /


; ----------------------------------------------------------
; [全局]多媒体键盘快捷键
; ----------------------------------------------------------
Launch_Media::                          ;fn+f3
Media_Prev::                            ;fn+f4
Media_Play_Pause::                      ;fn+f5
Media_Next::_nop_()               ;fn+f6
;Volume_Mute::_nop_()            ;fn+f7
;Volume_Down::_nop_()            ;fn+f8
;Volume_Up::_nop_()              ;fn+f9
; -------------------------------
; fn快捷键 无法实现
Browser_Back::
Browser_Forward::
Browser_Refresh::
Browser_Stop::
Browser_Search::
Browser_Favorites::
Browser_Home::_nop_()
; -------------------------------
Media_Stop::
Launch_Mail::
Launch_App1::
Launch_App2::_nop_()


; ----------------------------------------------------------
; 剪贴板数组 Caps组合键
; ----------------------------------------------------------
; 打开剪贴板菜单
; Capslock用ESC + Capslock代替
$Capslock::caps()

; Capslock 操作剪贴板数组
; 方案一
^Capslock::剪贴板数组_清空_复制()
#Capslock::复制到剪贴板数组()
!Capslock::剪贴板数组_拼接_粘贴()
+Capslock::Clipboarder.clean()
^!Capslock::
^#Capslock::剪贴板数组清洗_拼接_粘贴()


; ----------------------------------------------------------
; [文件目录类]检查文件的md5和sha值
; ----------------------------------------------------------
; 资源管理器窗口
; ---------------------------------------
$!f8::a_f8()
$^!f8::c_a_f8()


; ---------------------------------------
; 资源管理器窗口 - 重命名操作
; ---------------------------------------
$^r::c_r()
$^!r::c_a_r()
$^+r::c_s_r()       ; undo撤销操作

$!f2::a_f2()        ; 自定义重命名操作
$+f2::s_f2()        ; undo撤销操作


; ----------------------------------------------------------
; [窗口控制操作]针对四键鼠标的设置
; ----------------------------------------------------------

; 向左调整窗口()
; 按ctrl + 鼠标中键/右键
;#LButton::
;#Left::
$XButton1::
$Wheelleft::
$^RButton::绑定_向左调整窗口()

; 向右调整窗口()
; 按alt + 鼠标中键/右键
;#Right::
$XButton2::
$Wheelright::
$!RButton::绑定_向右调整窗口()

; 切换窗口x轴大小
; 按鼠标中键 / win + 鼠标右键 
$MButton::绑定_mbutton()           ; 第三方软件保留键

; 切换窗口y轴大小
; 按 +鼠标中键 / #+右键
; 对播放器, 自动用720窗口居中显示
;$+MButton::绑定_切换窗口y轴大小()   ; 第三方软件保留键

; 窗口屏幕居中, 1440*720
; 按ctrl + alt + 鼠标中键/右键
$^!MButton::绑定_窗口屏幕居中()


; ----------------------------------------------------------
; 快捷操作 - 调整当前窗口大小
; ----------------------------------------------------------


; ^#Numpad8::快捷操作_调整当前窗口大小(8)                       ; 纵向向上伸缩
; ^#Numpad2::快捷操作_调整当前窗口大小(2)                       ; 纵向向下伸缩
; ^#Numpad4::快捷操作_调整当前窗口大小(4)                       ; 横向缩小(向左)
; ^#Numpad6::快捷操作_调整当前窗口大小(6)                       ; 横向扩大(向右)
; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口
; ----------------------------------------------------------
; #NumpadDot::快捷操作_移动当前窗口(".")                        ; 移动窗口到右下角最小化
; #Numpad8::快捷操作_移动当前窗口(8)                            ; 上移
; #Numpad2::快捷操作_移动当前窗口(2)                            ; 下移
; #Numpad4::快捷操作_移动当前窗口(4)                            ; 左移
; #Numpad6::快捷操作_移动当前窗口(6)                            ; 右移
; #Numpad5::快捷操作_移动当前窗口(5)                            ; 自动移到屏幕正中
; ----------------------------------------------------------
; 快捷操作 - 移动当前窗口(并自动调整窗口大小)
; ----------------------------------------------------------
; #Numpad7::快捷操作_移动当前窗口_并调整大小(1)                  ; 移到左上方
; #Numpad1::快捷操作_移动当前窗口_并调整大小(3)                  ; 移到左下方
; #Numpad9::快捷操作_移动当前窗口_并调整大小(2)                  ; 移到右上方
; #Numpad3::快捷操作_移动当前窗口_并调整大小(4)                  ; 移到右下方
; ----------------------------------------------------------
; 多窗口管理
; ----------------------------------------------------------
; #NumpadMult::多窗口管理("平铺",1)                            ; 全部窗口平铺
; ^#NumpadMult::多窗口管理("平铺",-0.49)
; !#NumpadMult::多窗口管理("平铺",0.49)
; #IfWinActive ahk_class Progman
;     ~left & NumpadMult::多窗口管理("平铺",-0.49)
;     ~right & NumpadMult::多窗口管理("平铺",0.49)
;     ~down & NumpadMult::多窗口管理("平铺",1)
; #IfWinActive
; ----------------------------------------------------------
; [功能实现部分] 编程快捷操作类
; ----------------------------------------------------------
;#=::代码段边界线(2)                                          ; 代码段行间隔加粗
;#-::代码段边界线(1)                                          ; 代码段行间隔
;+#-::设置代码段落标题()                                      ; 设置代码段落标题(将当前行全部内容设置为标题)
; ----------------------------------------------------------
; [代码块注释]
; ----------------------------------------------------------
;#/::注释代码块(1,1,1)                                        ; 注释选定行并添加上下边界线 (清理连续空行)
;!#/::注释代码块(1,1,0)                                       ; 注释选定行并添加上下边界线
;+#/::取消注释代码块()                                        ; 取消注释代码块, 可以识别当前行是否被注释
; ----------------------------------------------------------
;#,::xml包裹选定文本()                                        ; xml包裹选定文本, 如<td>...</td>, 使用# C可以直接复制设置标签名
; ----------------------------------------------------------
;#'::Clipboarder.wrap("""", """")                            ; 双引号包裹
;#+9::Clipboarder.wrap("(", ")")                             ; 小括号包裹
;#[::Clipboarder.wrap("[", "]")                              ; 中括号包裹
;#+[::Clipboarder.wrap("{", "}")                             ; 大括号包裹
;#+,::Clipboarder.wrap("<", ">")                             ; <>包裹
;#+3::Clipboarder.wrap("#", "#")                             ; #...#包裹
;#+5::Clipboarder.wrap("%", "%")                             ; %...%包裹



; ==========================================================
; user_用户特殊快捷键
; ==========================================================

^+#a::tags默认备注提示_av女优()
^+#z::tags默认备注提示_av作品()
    

; ----------------------------------------------------------
; 常用快捷键
; ----------------------------------------------------------
:x*:@@@::write("lie_yan@126.com")             ; 输出邮箱

; 输出"评级星星"
:x*:;5x::
:x*:;4x::
:x*:;3x::
:x*:;2x::
:x*:;1x::
:x*:;0x::Write(strLevel(substr(A_ThisHotkey,-1,1)))


>!,::write(strTime("yyyy-MM-dd HH_mm_ss"))   ; 输出19位短id -- "2020-12-22 18_12_48" 下划线间隔

:x*:;id::                                ; 输出17位短id -- "14位时间+3位随机数" 下划线间隔
>!'::write(strId())

:x*:;now::                               ; 输出"日期时间字符串"
:x*:;nnn::
>!`;::write(Sys.now())

:x*:;date::                              ; 输出"日期字符串"
>!.::write(Sys.date())

:x*:;time::                              ; 输出"时间字符串"
>!/::write(Sys.time())

; ----------------------------------------------------------
; [测试] 模拟vim快捷键功能
; ----------------------------------------------------------
; 复制
:c*:;Y::
    write("这是大写的y")
Return







; ==========================================================
; user_编程快捷键
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
    list_print(_list)
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

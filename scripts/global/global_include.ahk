; ==========================================================
; [全局] 加载外部文件
;
; 文档作者: 烈焰
;
; 修改时间: 2019-01-21 21:11:35
; ==========================================================

; ----------------------------------------------------------
; Include 系统常用脚本
; ----------------------------------------------------------
; --- 全局变量必须放首行
#include scripts\packages\Config.class.ahk
#include scripts\packages\Menus.class.ahk

; ----------------------------------------------------------
; [全局libs]函数库
; ----------------------------------------------------------
#include scripts\packages\Crypt.class.ahk
#include scripts\packages\Analyser.class.ahk
#include scripts\packages\List.class.ahk
#include scripts\packages\Json.class.ahk
#include scripts\packages\Clipboarder.class.ahk
#include scripts\packages\Flow.class.ahk
#include scripts\packages\File.class.ahk
#include scripts\packages\Path.class.ahk
#include scripts\packages\Timer.class.ahk
#include scripts\packages\Color.class.ahk
; ----------------------------------------------------------
#include scripts\libs\list_dict.ahk
#include scripts\libs\lib_正则表达式.ahk
#include scripts\libs\lib_日志管理.ahk
#include scripts\libs\lib_文件目录管理.ahk
#include scripts\libs\lib_字符串处理.ahk
#include scripts\libs\lib_窗口管理.ahk
#include scripts\libs\lib_系统管理.ahk
#include scripts\libs\lib_搜索.ahk
#include scripts\libs\lib_用户交互GUI.ahk
#include scripts\libs\lib_编程快捷操作.ahk
#include scripts\libs\lib_网络通信和数据采集.ahk
#include scripts\libs\lib_其他内容.ahk
; 自定义的用户功能
#include scripts\packages\Av.class.ahk
; 单元测试
#include scripts\packages\TestUnit.class.ahk
#include scripts\testUnit\单元测试.ahk

; --- end

; ----------------------------------------------------------
; [全局]autorun管理, 必须在所有热键,热字符串,GUI,OnMessage前
; ----------------------------------------------------------
#include scripts\global\system_autorun.ahk

; ****** 开始所有热键,热字符串,GUI,OnMessage ******
; ----------------------------------------------------------
; [全局]加载任务栏菜单
; ----------------------------------------------------------
; 用menus.class替代
; #include scripts\global\global_menus.ahk

; ----------------------------------------------------------
; [用户]专用操作
; ----------------------------------------------------------
#include scripts\专用脚本\[烈焰实用工具] 通达信股票软件相关操作.ahk
#include scripts\专用脚本\[烈焰实用工具] MT4外汇软件相关操作.ahk
#include scripts\专用脚本\[烈焰实用工具] 文华财经软件相关操作.ahk
#include scripts\专用脚本\[tom实用工具] sublimeText操作.ahk

; ----------------------------------------------------------
; [全局]用户热键管理
; ----------------------------------------------------------
#include scripts\global\global_按键绑定_函数.ahk
#include scripts\global\global_按键绑定.ahk











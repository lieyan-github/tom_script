; ==========================================================
; tom常用操作(工具包)
;
; 作者: tom
;
; 最后修改时间: 2019-02-10 14:49:28
; ==========================================================

#Persistent
#NoEnv
#SingleInstance force

; 设置当前的工作目录为脚本所在的目录
SetWorkingDir %A_ScriptDir%

;--- 启动提醒
show_splash("", "AHK启动")

; Include 系统常用脚本
#include scripts\global\global_include.ahk



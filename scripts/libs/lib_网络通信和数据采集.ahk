; ==========================================================
; lib_网络通信和数据采集
;
; 作者: 烈焰
;
; 2015年12月24日 14:45:32
; ==========================================================

; ----------------------------------------------------------
; [网络Com组件] 获取外网ip [具有参考意义, 不要删]
; ----------------------------------------------------------
获取外网ip()
{
   WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   WebRequest.Open("GET", "http://www.ip138.com")
   WebRequest.Send()
   RegExMatch(WebRequest.ResponseText, "(?<=<center>).*?(?=</center>)", ver)
   ip:= StrSplit(StrSplit(ver, "[")[2], "]")[1]
   return ip
}

;获取外网ip()
;{
;   _ResponseText := UrlDownloadToVar("http://www.ip138.com/")
;   RegExMatch(_ResponseText, "(?<=<center>).*?(?=</center>)", match)
;   _ip:= StrSplit(StrSplit(match, "[")[2], "]")[1]
;   ;_ip := match
;   return _ip
;   ;return _ResponseText
;}

; ----------------------------------------------------------
; 下载网络内容到字符串变量
; ----------------------------------------------------------
UrlDownloadToVar(url)
{
   static whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   whr.Open("GET", url, true)
   whr.Send()
   whr.WaitForResponse()
   return whr.ResponseText
}





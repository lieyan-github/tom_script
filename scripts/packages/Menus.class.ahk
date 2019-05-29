; ==========================================================
; 菜单类 Menus.class.ahk
;
; Author: Tom
;
; 修改时间: 2017-10-08 18:56:45
; ==========================================================

class Menus {

   ; ----------------------------------------------------------
   ; static main_menu()
   ; 主菜单
   ; ----------------------------------------------------------
   main_menu()
   {
      ; ----------------------------------------------------------
      ; 第1组菜单内容
      ; ----------------------------------------------------------
      Menu, menu_文件, add, 图片按尺寸重命名并分类存放, 图片按尺寸重命名并分类存放_func
      Menu, menu_文件, add, 收集所有匹配文件, 收集所有匹配文件_func
      Menu, menu_文件, add, 收集所有匹配文件逆操作, 收集所有匹配文件逆操作_func
      ; ------------------------------------------------
      ; 网络 子菜单内容
      Menu, menu_网络, add, 查看外网IP, 查看外网IP_func
      ; ------------------------------------------------
      ; [主菜单] 将子菜单组挂接到父节点
      Menu, MainMenu, add, 常用, :menu_文件
      Menu, MainMenu, add, 文件, :menu_文件
      Menu, MainMenu, add, 网络, :menu_网络
      Menu, MainMenu, add  ;创建一条分割线。
      ; ------------------------------------------------
      ; test debug 创建带有复选框的菜单项
      menu, MainMenu, add, 剪贴板, pasteEnable_func
      if(Clipboard == ""){
         menu, MainMenu, Disable, 剪贴板 ; 它不能撤销自己的禁用状态.
      }
      Menu, MainMenu, add  ;创建一条分割线。
      ; ----------------------------------------------------------
      ; 第2组菜单内容 全局变量编辑
      ; ----------------------------------------------------------
      ; 创建一组子菜单内容
      Menu, menu_全局变量编辑, add, 编辑全局注释符, 编辑全局注释符_func
      Menu, menu_全局变量编辑, add,
      Menu, menu_全局变量编辑, add, 编辑文本注释边框_1, 编辑文本注释边框_1_func
      Menu, menu_全局变量编辑, add, 编辑文本注释边框_2, 编辑文本注释边框_2_func
      Menu, menu_全局变量编辑, add, 编辑白名单_允许鼠标调大小的窗口, 编辑白名单_允许鼠标调大小的窗口_func
      Menu, menu_全局变量编辑, add,
      ; 将一组子菜单挂接到父节点
      Menu, MainMenu, add, 全局变量编辑, :menu_全局变量编辑
      Menu, MainMenu, add                   ;创建一条分割线。
      ; ----------------------------------------------------------
      ; [托盘菜单]ahk自身管理
      ; ----------------------------------------------------------
      Menu, MainMenu, add, 刷新(Win+F12),刷新_func
      Menu, MainMenu, Default, 刷新(Win+F12)
      Menu, MainMenu, add, 编辑脚本(&E),编辑_func
      Menu, MainMenu, add, 打开脚本目录(Win+End),打开脚本目录_func
      Menu, MainMenu, add, 帮助(Win+F1),帮助_func
      Menu, MainMenu, add                   ;创建一条分割线。
      Menu, MainMenu, add, 退出(&X),退出_func
      ; ----------------------------------------------------------
      ; [托盘菜单] 菜单制作结束
      ; ----------------------------------------------------------
      Menu, MainMenu, Show
      ;<……>此时转入选择的标签运行，结束后返回
      Menu, MainMenu, DeleteAll
      Menu, menu_全局变量编辑, DeleteAll
      Return
      ; ----------------------------------------------------------
      ; [托盘菜单功能实现部分]
      ; ----------------------------------------------------------
      图片按尺寸重命名并分类存放_func:
      ;   FileSelectFile, _filePath, 2, , % "选择当前所处的目录,仅整理当前目录下的图片", ImgFiles(*.jpg;*.jpeg;*.gif;*.bmp)
      ;   if _filePath =
      ;   {
      ;      show_msg("[当前操作结束]`n用户取消操作, 且没有选定任何目录!")
      ;      return
      ;   }
         if(获取用户输入(_filePath
            ,"输入要处理的目录"
            ,"选择当前所处的目录,仅整理当前目录下的图片"
            ,
            ,
            ,"^"""
            ,"""$"
            ,"\\$")=true)
            将指定目录中图片按尺寸重命名并分类存放(_filePath)
      return
      ; ----------------------------------------------------------
      收集所有匹配文件_func:
         if(获取用户输入(_filePattern
            ,"输入文件的匹配模式"
            ,"单个文件的名称或者通配符模式.`n(支持星号和问号作为通配符使用)")=true)
             if(获取用户输入(_filePath
                ,"输入要处理的目录"
                ,"选择当前所处的目录, 处理过程将递归子目录."
                ,
                ,
                ,"^"""
                ,"""$"
                ,"\\$")=true)
                收集指定目录中所有匹配文件(_filePath,_filePattern)
      return
      ; ----------------------------------------------------------
      收集所有匹配文件逆操作_func:
         if(获取用户输入(_filePath
            ,"输入结果存放目录"
            ,"选择结果存放目录"
            ,
            ,
            ,"^"""
            ,"""$"
            ,"\\$")=true)
            收集指定目录中所有匹配文件_逆操作(_filePath)
      return
      ; ----------------------------------------------------------
      查看外网IP_func:
         show_msg(format("ip = {1}`n`n*已存剪贴板*", 获取外网ip()))
      return
      ; ----------------------------------------------------------
      pasteEnable_func:
         write(Clipboard)
      return
      ; ----------------------------------------------------------
      编辑全局注释符_func:
         _tmp := Config.get("commentSymbol")
         if(用户修改变量(_tmp
            , "全局注释符号"
            , _tmp)=true)
            Config.set("commentSymbol", _tmp)
      return
      ; ----------------------------------------------------------
      编辑文本注释边框_1_func:
         _tmp := Config.get("wrapBorderLine1")
         if(用户修改变量(_tmp
            , "文本注释边框_1"
            , _tmp)=true)
            Config.set("wrapBorderLine1", _tmp)
      return
      ; ----------------------------------------------------------
      编辑文本注释边框_2_func:
         _tmp := Config.get("wrapBorderLine2")
         if(用户修改变量(_tmp
            , "文本注释边框_2"
            , _tmp)=true)
            Config.set("wrapBorderLine2", _tmp)
      return
      ; ----------------------------------------------------------
      编辑白名单_允许鼠标调大小的窗口_func:
         _tmp := arrayJoin(Config.get("allowResizeWins"), ",")
         if(用户修改对象变量(_tmp
            , "白名单_允许鼠标调大小的窗口"
            , _tmp)=true)
            Config.set("allowResizeWins", str_Split(trim(_tmp, ","), ","))
      return
      ; ----------------------------------------------------------
      刷新_func:
         script_reload()
      return
      ; ----------------------------------------------------------
      编辑_func:
         run D:\_home_\tom\program\green_program\应用软件\编辑工具\EmEditor\EmEditor.exe %A_ScriptFullPath%
      return
      ; ----------------------------------------------------------
      打开脚本目录_func:
         run %A_ScriptDir%
      return
      ; ----------------------------------------------------------
      帮助_func:
         run "D:\_home_\tom\program\green_program\辅助工具\AutoHotkey\AutoHotkey.chm"
      return
      ; ----------------------------------------------------------
      退出_func:
         ExitApp
      Return
   }
}


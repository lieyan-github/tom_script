; ==========================================================
;
; lib_搜索
;
; 作者: 烈焰
;
; 修改时间: 2018-03-10 05:02:30
;
; ==========================================================

; 清洗搜索关键字, 返回字符串
cleanSearchKey(_searchKey, _RegEx:="[,\n\r]", _replace:=""){
    return RegExReplace(trim(_searchKey, " `t"), _RegEx, _replace)
}

; ----------------------------------------------------------
; [快捷搜索] 运行搜索器 - 搜索指定内容
;
; 参数: _searchKey
; 参数: _searcher  {name:""..."", cmd:"...", args:"...", log:true}
; 参数中关键字用 "{1}" 代替
; 无搜索关键字, 则只打开cmd路径或url
; ----------------------------------------------------------
运行搜索器(_searchKey, _searcher){

    _搜索命令    := ""
    _搜索关键字  := cleanSearchKey(_searchKey)
    _搜索name   := _searcher["name"]

    ; ---------------------------------
    ; 如果没有指定搜索内容, 则仅仅启动默认搜索器
    if(_搜索关键字 == ""){

        show_msg("搜索关键字空白, 仅打开对应搜索工具或网址!")

        _搜索命令 :=  _searcher["cmd"]

        run %_搜索命令%

    }
    else{

        ; 如果获取的是路径, 则搜文件名, 含扩展名
        if(InStr(_搜索关键字, ":\") >0 ){

            ; 取 文件名.扩展名
            ; SubStr(String, StartingPos [, Length])
            _pos := InStr(_搜索关键字, "\", false, 0)
            _fileAndExt := SubStr(_搜索关键字, _pos + 1)

            ; 取 文件名 不含扩展名
            _pos := InStr(_fileAndExt, ".", false, 0)
            _搜索关键字 := SubStr(_fileAndExt, 1, _pos - 1)

        }

        _搜索命令 :=  format(_searcher["cmd"] . _searcher["args"]
                            , _搜索关键字)
    
        run %_搜索命令%

        ; 写入搜索历史文件, 只记录有搜索内容的操作
        if(_searcher["log"]){
            CsvFile.append(Config.upath("searchHistoryFile")
                            , Format("[{1}],{2},{3},{4}"
                                , Sys.now()
                                , _搜索name
                                , _搜索关键字
                                , _搜索命令))
        }    
    }

    ; end
}

; 保存更改到搜索器文件
; _valueObjSearcher 搜索器结构同一般搜索器结构, 仅作为备份信息
; {name:""..."", path:"...", args:"..." tag:[..]}
保存更改到搜索器文件(_key, _valueObjSearcher, _jsonPath){

    _searchersJson  := JsonFile.read(_jsonPath)

    _searchersJson[_key] := _valueObjSearcher

    ; 将更新过的搜索器信息, 保存到searchers.json
    JsonFile.write(_searchersJson, _jsonPath)

}

; 打开搜索菜单
打开搜索菜单(){
    if(inWinList(Config.get("视频播放器"))){

        ; 如果是视频播放器, 则通过标题搜索当前播放文件
        WinGetTitle, path, A

        _pos := InStr(path, " - ", False, 0)
        if(_pos > 0){
            _fileExtName := SubStr(path, 1, _pos-1)
            search_menu(_fileExtName)        
        }
        Else
            msgbox, 当前播放器标题中的文件名不能识别! `n`n标题内容: %path%

    }
    else{

        search_menu()
    
    }
}

; 修改搜索器命令和参数
; 只修改, 需另外保存到文件
修改搜索器命令和参数(_argSearcher){
    
    _searcherCmd := _argSearcher["cmd"] . "," . _argSearcher["args"]

    if(用户修改变量(_searcherCmd
                , "编辑搜索器 - " . _argSearcher["name"]
                , _searcherCmd) 
        and InStr(_searcherCmd,",")){
        _tmpCmd := StrSplit(_searcherCmd, ",")
        _argSearcher["cmd"] := _tmpCmd[1]
        _argSearcher["args"] := _tmpCmd[2]
        ; 发生修改, 返回true
        return true
    }    
    return false
}

; search_menu 打开搜索主菜单
search_menu(_argSearchKey:="")
{
    _searchKey := _argSearchKey != "" ? _argSearchKey : trim(Clipboarder.get("copy"), " `t")
    ; ----------------------------------------------------------
    ; 加载数据文件, 生成相应数组
    ; ----------------------------------------------------------
    _searchersJson  := JsonFile.read(Config.upath("searchersFile"))
    _searchers      := _searchersJson["searchers"]
    _localSearcher  := _searchersJson["localSearcher"]
    _recentSearcher := _searchersJson["recentSearcher"]["cmd"] == "" ? _localSearcher : _searchersJson["recentSearcher"]

    ; ----------------------------------------------------------
    ; 菜单部分
    ; ----------------------------------------------------------
    Gui +OwnDialogs
    ; [菜单] 提示搜索内容
    Menu, SearchMenu, Add, % "当前搜索关键字: ", lab_SearchMenu_End
    Menu, SearchMenu, disable, % "当前搜索关键字: "
    Menu, SearchMenu, Add
    if(_searchKey == "") {
        Menu, SearchMenu, Add, ***无搜索内容***, lab_SearchMenu_End
        Menu, SearchMenu, disable, ***无搜索内容***
        Menu, SearchMenu, Add
    }
    else {
        Menu, SearchMenu, Add, % strLimitLen(_searchKey, 1, 50, "..."), lab_SearchMenu_End
        Menu, SearchMenu, disable, % strLimitLen(_searchKey, 1, 50, "...")
        Menu, SearchMenu, Add
    }

    ; 主菜单 - 选择搜索引擎
    Loop % _searchers.Length(){
        Menu, SearchMenu
            , Add
            , % "&" . A_Index . ". " . _searchers[A_Index]["name"]
            , lab_SearchMenu_tagsMenuSelected
    }


    ; 提示信息
    Menu, SearchMenu, Add, [按住Shift修改搜索器 | 按住Ctrl显示搜索器], lab_SearchMenu_End
    Menu, SearchMenu, disable, [按住Shift修改搜索器 | 按住Ctrl显示搜索器]
    Menu, SearchMenu, Add
    Menu, SearchMenu, Add, % "&``. 使用最近的搜索器: " . _recentSearcher["name"], lab_使用最近的搜索器
    Menu, SearchMenu, Add

    ; ----------------------------------------------------------
    ; AV菜单内容
    ; ----------------------------------------------------------
    Menu, menu_av, add, &``. AV作品, lab_查询AV作品
    Menu, menu_av, add, &1. AV女优, lab_查询AV女优
    Menu, menu_av, add, &2. AV制作商, lab_查询AV制作商
    Menu, menu_av, add, &3. AV发行商, lab_查询AV发行商
    Menu, menu_av, add, &4. AV导演, lab_查询AV导演
    ; ------------------------------------------------
    ; AV分支选项
    Menu, SearchMenu, add, &a. 查询AV资料, :menu_av
    Menu, SearchMenu, Add

    ; 其他搜索功能
    Menu, SearchMenu, Add, &q. 使用本地搜索器, lab_使用本地搜索器
    Menu, SearchMenu, Add
    Menu, SearchMenu, Add, &h. 查看搜索历史, lab_SearchMenu_History
    Menu, SearchMenu, Add
    Menu, SearchMenu, Add, &e. 编辑搜索列表, lab_SearchMenu_Edit
    Menu, SearchMenu, Add

    ; 显示菜单
    Menu, SearchMenu, Show, %A_CaretX%, %A_CaretY%
    ;<……>此时转入选择的标签运行，结束后返回
    Menu, SearchMenu, DeleteAll
    return          ;菜单结束, 不再往下执行

    ; ==========================================================
    ; 菜单执行部分
    ; ==========================================================
    lab_SearchMenu_tagsMenuSelected:

        _searcherSelectIndex := A_ThisMenuItemPos - 4

        If GetKeyState("Ctrl"){         
            ;[按住 Ctrl 显示searcher对象信息]

            list_print(_searchers[_searcherSelectIndex])
            
            ; end
            Return
        }

        If GetKeyState("Shift"){          
            ;[按住 Shift 修改当前searcher命令和参数]

            if(修改搜索器命令和参数(_searchers[_searcherSelectIndex])){
                ; 保存更改到搜索器文件
                保存更改到搜索器文件("searchers", _searchers, Config.upath("searchersFile"))
            }
            ; end
            Return
        }

        ; 执行搜索
        运行搜索器(_searchKey, _searchers[_searcherSelectIndex])
        sleep 200

        ; 保存更改到搜索器文件
        保存更改到搜索器文件("recentSearcher", _searchers[_searcherSelectIndex], Config.upath("searchersFile"))

    return

    lab_SearchMenu_Clipboard:
        write(Clipboard)
    return

    ; av相关查询
    ; ----------------------------------------------------------
    lab_查询AV作品:
        av查询_作品(_searchKey)
    return

    lab_查询AV女优:
        av查询_女优(_searchKey)
    return

    lab_查询AV制作商:
        show_msg("查询AV制作商  暂无功能")
    return

    lab_查询AV发行商:
        show_msg("查询AV发行商  暂无功能")
    return

    lab_查询AV导演:
        show_msg("查询AV导演  暂无功能")
    return
    ; ----------------------------------------------------------

    lab_使用最近的搜索器:
        运行搜索器(_searchKey, _recentSearcher)
    return

    lab_使用本地搜索器:

        If GetKeyState("Ctrl"){         
            ;[按住 Ctrl 显示searcher对象信息]

            list_print(_localSearcher)
            
            ; end
            Return
        }

        If GetKeyState("Shift"){          
            ;[按住 Shift 修改当前searcher命令和参数]

            if(修改搜索器命令和参数(_localSearcher)){
                ; 保存更改到搜索器文件
                保存更改到搜索器文件("localSearcher", _localSearcher, Config.upath("searchersFile"))
            }
            ; end
            Return
        }

        运行搜索器(_searchKey, _localSearcher)
        sleep 200

        ; 保存更改到搜索器文件
        保存更改到搜索器文件("recentSearcher", _localSearcher, Config.upath("searchersFile"))
        
    return

    lab_SearchMenu_History:
        if(FileExist(Config.upath("searchHistoryFile")))
            Run, % "Notepad.exe " . Config.upath("searchHistoryFile")
        Else
            msgbox, searchHistoryFile 文件不存在!
    return

    lab_SearchMenu_Edit:
        if(FileExist(Config.upath("searchersFile")))
            Run, % "Notepad.exe " . Config.upath("searchersFile")
        Else
            msgbox, searchersFile 文件不存在!
    return

    lab_SearchMenu_End:
        Gui, Destroy
    return
}



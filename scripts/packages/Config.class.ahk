; ==========================================================
;
; [全局] 变量定义
;
; 文档作者: tom
;
; 修改时间: 2019-02-10 01:17:54
;
; ==========================================================

class Config {

    ; 配置项目列表(字典)
    static items := {}
    ; 配置文件路径
    static data_dir         := a_workingdir . "\data"
    static userdata_dir     := a_workingdir . "\userdata"
    static config_file      := Config.data_dir . "\config.json"

    ; ----------------------------------------------------------
    ; 特殊应用软件变量定义
    ; 全局变量
    ; ----------------------------------------------------------
    static rename_regexMatch   := format("i).*?({1}|{2}|{3}|{4}|{5}).*"
                                        , "carib[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "1pon[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "CAPPV[^-]*[_-]\d{6}[_-]\d{3}"
                                        , "Avs[_-]museum[_-]\d{6}"
                                        , "[a-z]{2,5}-\d+")
    static rename_regexReplace := "$1"
    ; [mt4平台] 十字光标开关切换标志
    static mt4_ctrl_f_switch := 0

    ; ----------------------------------------------------------
    ; static method:
    ; ----------------------------------------------------------
    ; 配置文件初始化, 启动检测常用设置并设置相关内容
    init(){
        文件错误检测(Config.config_file)
        Config.reload()
        Config.folders_init()
    }

    ; 初始化用户目录
    folders_init(){
        folders := Config.items["data_user"]["folders"]
        for k,folder in folders{
            _path := A_ScriptDir . "\" . folder
            if(! FileExist(_path)){
                FileCreateDir, %_path%
            }
        }
    }

    ; 重新加载配置文件, 刷新配置变量, 用于修改后的刷新
    reload(){
        Config.loadConfigItemsList()
    }

    ; 加载配置变量列表
    loadConfigItemsList(){
        ; 从config.json加载配置变量
        Config.items:= JsonFile.read(Config.config_file)
    }

    ; 获取data转换文件的完整路径
    path(_datafileKey){
            return Config.data_dir . "\" . Config.items["data"][_datafileKey]
    }

    ; 获取data_user转换文件的完整路径
    upath(_datafileKey){
            return Config.userdata_dir . "\" . Config.items["data_user"][_datafileKey]
    }

    ; static读取配置数据项
    get(_inKey){
        return Config.items[_inKey]
    }

    ; static修改配置项
    set(_inKey, _inValue){
        Config.items[_inKey] := _inValue
        Config.save()
    }

    ; static保存配置项到配置文件
    save(){
        ; 将修改后的json写入json文件
        show_debug(JSON.dump(Config.items,,3))
        JsonFile.write(Config.items, Config.config_file)
    }
}



